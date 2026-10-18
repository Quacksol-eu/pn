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

Load_Const R16, R17, 5
rcall DelayInMs 

.endmacro

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

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



MainLoop:

ldi R16, 1
add PulseEdgeCtrL, R16
clr R16
adc PulseEdgeCtrH, R16

ldi R16, low(1000)
ldi R17, high(1000)

cp  PulseEdgeCtrL, R16
cpc PulseEdgeCtrH, R17
brlo NoWrap

clr PulseEdgeCtrL
clr PulseEdgeCtrH
NoWrap:

mov R16, PulseEdgeCtrL
mov R17, PulseEdgeCtrH
rcall NumberToDigits       
mov Digit_0, R16
mov Digit_1, R17
mov Digit_2, R18
mov Digit_3, R19

Set_Digit 0
Set_Digit 1
Set_Digit 2
Set_Digit 3

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

mov  R24, YL1
or   R24, YH1
breq DivByZero

clr QCtrL
clr QCtrH

InnerLoop:

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


;*** NumberToDigits ***
;input : Number: R16-17
;output: Digits: R16-19
;internals: X_R,Y_R,Q_R,R_R - see _Divide
; internals

.undef QCtrL
.undef QCtrH

.def Dig0=R22 ; Digits temps
.def Dig1=R23 ;
.def Dig2=R24 ;
.def Dig3=R25 ;

NumberToDigits:
push R22
push R23
push R24
push R25

ldi  R18, low(1000)
ldi  R19, high(1000)    
rcall Divide
mov  Dig0, R18 

ldi  R18, 100
ldi  R19, 0
rcall Divide
mov  Dig1, R18          

ldi  R18, 10
ldi  R19, 0
rcall Divide
mov  Dig2, R18          

mov  Dig3, R16          

mov  R16, Dig0          
mov  R17, Dig1
mov  R18, Dig2
mov  R19, Dig3

pop R25
pop R24
pop R23
pop R22
ret



Table: .db 63, 6, 91, 79, 102, 109, 125, 7, 127, 111