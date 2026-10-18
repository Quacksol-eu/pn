.macro Load_Const
ldi @0 , low(@2)
ldi @1 , high(@2)
.endmacro

.equ Digits_P = PORTB
.equ Segments_P = PORTD

ldi R16, 0b00111111
mov R2, R16
ldi R16, 0b00000110
mov R3, R16
ldi R16, 0b01011011
mov R4, R16
ldi R16, 0b01001111
mov R5, R16
.def Zero  = R2
.def One   = R3
.def Two   = R4
.def Three = R5


ldi R16, 0b11111111
out DDRD, R16
ldi R16, 0b11111111
out DDRB, R16


MainLoop:

mov R16, Zero
out Segments_P, R16
ldi R16, 0b00000010
out Digits_P, R16

Load_Const R16, R17, 5
rcall DelayInMs 

mov R16, One
out Segments_P, R16
ldi R16, 0b00000100
out Digits_P, R16

Load_Const R16, R17, 5
rcall DelayInMs 

mov R16, Two
out Segments_P, R16
ldi R16, 0b00001000
out Digits_P, R16

Load_Const R16, R17, 5
rcall DelayInMs

mov R16, Three
out Segments_P, R16
ldi R16, 0b00010000
out Digits_P, R16

Load_Const R16, R17, 5 
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

