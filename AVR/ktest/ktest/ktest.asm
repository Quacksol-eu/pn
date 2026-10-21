 ;### MACROS & defs (.equ)###

; Macro LOAD_CONST loads given registers with immediate value, example: LOAD_CONST  R16,R17 1234 
.MACRO LOAD_CONST  
ldi @0, low(@2)
ldi @1, high(@2)
.ENDMACRO 

/*** Display ***/
.equ DigitsPort    = PORTB
.equ SegmentsPort  = PORTD
.equ DisplayRefreshPeriod  = 5

; SET_DIGIT diplay digit of a number given in macro argument, example: SET_DIGIT 2
.MACRO SET_DIGIT  
mov R16, Dig_@0
rcall DigitTo7segCode
out SegmentsPort, R16
ldi R16, (0b00000010 << @0)
out DigitsPort, R16

LOAD_CONST R16, R17, 5
rcall DelayInMs
.ENDMACRO 

; ### GLOBAL VARIABLES ###

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

.def Dig_0=R2
.def Dig_1=R3
.def Dig_2=R4
.def Dig_3=R5

; ### INTERRUPT VECTORS ###
.cseg		     ; segment pamiêci kodu programu 

.org	 0      rjmp	_main	 ; skok do programu g³ównego
.org OC1Aaddr	rjmp  _Timer_ISR
.org 0x0B   rjmp _ExtInt_ISR ; skok do procedury obs³ugi przerwania zenetrznego 

; ### INTERRUPT SEERVICE ROUTINES ###

_ExtInt_ISR: 	 ; procedura obs³ugi przerwania zewnetrznego
push R16
in R16, SREG
push R16

ldi R16, 1
add PulseEdgeCtrL, R16
clr R16
adc PulseEdgeCtrH, R16

pop R16
out SREG, R16
pop R16

reti   ; powrót z procedury obs³ugi przerwania (reti zamiast ret)      

_Timer_ISR:
    push R16
	in R16, SREG
	push R16
    push R17
    push R18
    push R19

    mov R16, PulseEdgeCtrL
	mov R17, PulseEdgeCtrH
	clr PulseEdgeCtrL
	clr PulseEdgeCtrH
	rcall _NumberToDigits
	mov Dig_0, R16
	mov Dig_1, R17
	mov Dig_2, R18
	mov Dig_3, R19


	pop R19
    pop R18
    pop R17
    pop R16
	out SREG, R16
	pop R16

  reti

; ### MAIN PROGAM ###

_main: 
    ; *** Initialisations ***

    ;--- Ext. ints --- PB0
    ldi R16, (1<<PCINT0)
	out PCMSK, R16
	ldi R16, (1<<PCIE)
	out GIMSK, R16

	;--- Timer1 --- CTC with 256 prescaller
    ldi R16, high(15624)
	out OCR1AH, R16
	ldi R16, low(15624)
	out OCR1AL, R16
	ldi R16, (1<<WGM12)|(1<<CS12)
	out TCCR1B, R16
	ldi R16, (1<<OCIE1A)
	out TIMSK, R16
			
	;---  Display  --- 
	ldi R16, 0b11111111
	out DDRD, R16
	ldi R16, 0b00011110
	out DDRB, R16
	; --- enable gloabl interrupts
    sei

MainLoop:   ; presents Digit0-3 variables on a Display
			SET_DIGIT 0
			SET_DIGIT 1
			SET_DIGIT 2
			SET_DIGIT 3

			RJMP MainLoop

; ### SUBROUTINES ###

;*** NumberToDigits ***
;converts number to coresponding digits
;input/otput: R16-17/R16-19
;internals: X_R,Y_R,Q_R,R_R - see _Divider

; internals
.def Dig0=R22 ; Digits temps
.def Dig1=R23 ; 
.def Dig2=R24 ; 
.def Dig3=R25 ; 

_NumberToDigits:

	push Dig0
	push Dig1
	push Dig2
	push Dig3

	; thousands 
    ldi R19, high(1000)
	ldi R18, low(1000)
	rcall _Divide
	mov Dig0, R18

	; hundreads 
    ldi R19, high(100)
	ldi R18, low(100)
	rcall _Divide
	mov Dig1, R18
     

	; tens 
    ldi R19, high(10)
	ldi R18, low(10)
	rcall _Divide
	mov Dig2, R18
    

	; ones 
    mov Dig3, R16

	; otput result
	mov R16,Dig0
	mov R17,Dig1
	mov R18,Dig2
	mov R19,Dig3

	pop Dig3
	pop Dig2
	pop Dig1
	pop Dig0

	ret

;*** Divide ***
; divide 16-bit nr by 16-bit nr; X/Y -> Qotient,Reminder
; Input/Output: R16-19, Internal R24-25

; inputs
.def XL=R16 ; divident  
.def XH=R17 

.def YL=R18 ; divider
.def YH=R19 

; outputs

.def RL=R16 ; reminder 
.def RH=R17 

.def QL=R18 ; quotient
.def QH=R19 

; internal
.def QCtrL=R24
.def QCtrH=R25

_Divide:push R24 ;save internal variables on stack
        push R25
		
        mov R24, YL
		or R24, YH
		breq DivByZero

		clr QCtrL
		clr QCtrH

		DivLoop:
		cp XL, YL
		cpc XH, YH
		brlo SkipDiv
		sub XL, YL
		sbc XH, YH
		adiw QCtrL, 1
		rjmp DivLoop

		SkipDiv:
		mov QL, QCtrL
		mov QH, QCtrH


		DivByZero:

		pop R25 ; pop internal variables from stack
		pop R24

		ret

; *** DigitTo7segCode ***
; In/Out - R16

Table: .db 0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0xff,0x6f

DigitTo7segCode:

push R30
push R31

ldi R31, high(Table<<1)
ldi R30, low(Table<<1)

add R30, R16
clr R16
adc R31, R16
lpm R16, Z

pop R31
pop R30

ret

; *** DelayInMs ***
; In: R16,R17
DelayInMs:  
            push R24
			push R25

            DelayLoop:
			rcall OneMsLoop
			subi R16, 1
			sbci R17, 0
			brne DelayLoop

			pop R25
			pop R24

			ret

; *** OneMsLoop ***
OneMsLoop:	
			push R24
			push R25 
			
			LOAD_CONST R24,R25,2000                    

L1:			SBIW R24:R25,1 
			BRNE L1

			pop R25
			pop R24

			ret



