.macro Load_Const
ldi @0 , low(@2)
ldi @1 , high(@2)
.endmacro

.macro Set_Digit

mov R16, Digit_@0
rcall DigitTo7segCode
out Segments_P, R16
ldi R16, (0b00000010 << @0)
out Digits_P, R16

Load_Const R16, R17, 1
rcall DelayInMs 

.endmacro

.equ Digits_P = PORTB
.equ Segments_P = PORTD

ldi R16, 0b11111111
out DDRD, R16
ldi R16, 0b11111111
out DDRB, R16

.def Digit_0 = R2
.def Digit_1 = R3
.def Digit_2 = R4
.def Digit_3 = R5

ldi R16, 0
mov Digit_0, R16
ldi R16, 0
mov Digit_1, R16
ldi R16, 0
mov Digit_2, R16
ldi R16, 0
mov Digit_3, R16

MainLoop:

Set_Digit 0
Set_Digit 1
Set_Digit 2
Set_Digit 3

inc Digit_0
ldi R16, 10
cp Digit_0, R16
brne Skip
clr Digit_0
inc Digit_1
cp Digit_1, R16
brne Skip
clr Digit_1
inc Digit_2
cp Digit_2, R16
brne Skip
clr Digit_2
inc Digit_3
cp Digit_3, R16
brne Skip
clr Digit_3
Skip:

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


DigitTo7segCode:
push R31
push R30

ldi R30, low(Table<<1)
ldi R31, high(Table<<1)

add R30, R16
clr R16
adc R31, R16
lpm R16, Z

pop R30
pop R31

ret

;*** Divide ***
; X/Y -> Quotient,Remainder
; Input/Output: R16-19, Internal R24-25

; inputs
.def XL1=R16 ; divident
.def XH1=R17

.def YL1=R18 ; divisor
.def YH1=R19

; outputs
;.def RL=R16 ; remainder
;.def RH=R17

;.def QL=R18 ; quotient
;.def QH=R19

; internal
.def QCtrL=R24
.def QCtrH=R25

Divide:

push R24
push R25

clr QCtrL
clr QCtrH

InnerLoop:

mov  R24, YL1
or   R24, YH1
breq DivByZero

cp XL1, YL1
cpc XH1, YH1
brlo skipq
sub XL1, YL1
sbc XH1, YH1
adiw QCtrL, 1
rjmp InnerLoop
skipq:
mov YL1, QctrL
mov YH1, QctrH

DivByZero:

pop R25
pop R24

ret

Table: .db 63, 6, 91, 79, 102, 109, 125, 7, 127, 111