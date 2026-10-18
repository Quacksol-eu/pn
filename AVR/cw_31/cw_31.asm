.macro Load_Const
ldi @0 , low(@2)
ldi @1 , high(@2)
.endmacro

.equ Digits_P = PORTB
.equ Segments_P = PORTD

.equ Zero  = 0b00111111
.equ One   = 0b00000110
.equ Two   = 0b01011011
.equ Three = 0b01001111
.equ Four  = 0b01100110
.equ Five  = 0b01101101
.equ Six   = 0b01111101
.equ Seven = 0b00000111
.equ Eight = 0b01111111
.equ Nine  = 0b01101111

ldi R16, 0b11111111
out DDRD, R16
ldi R16, 0b11111111
out DDRB, R16


MainLoop:

ldi R16, Zero
out Segments_P, R16
ldi R16, 0b00000010
out Digits_P, R16

Load_Const R16, R17, 1000 
rcall DelayInMs 

ldi R16, Zero
out Segments_P, R16
ldi R16, 0b00000100
out Digits_P, R16

Load_Const R16, R17, 1000 
rcall DelayInMs 

ldi R16, Zero
out Segments_P, R16
ldi R16, 0b00001000
out Digits_P, R16

Load_Const R16, R17, 1000 
rcall DelayInMs

ldi R16, Zero
out Segments_P, R16
ldi R16, 0b00010000
out Digits_P, R16

Load_Const R16, R17, 1000 
rcall DelayInMs

rjmp MainLoop


DelayInMs: 
push R16
push R17
loopbigInMs:
rcall DelayOneMs 
subi R16, 1
sbci R17, 0
brne loopbigInMs
pop R17
pop R16
ret

DelayOneMs: 
push R22
push R24
push R25
ldi R22, 1
ldi R24, $36
ldi R25, $F8
loopOne:
adiw R24, 1
brne loopOne
dec R22
pop R25
pop R24
pop R22
ret

