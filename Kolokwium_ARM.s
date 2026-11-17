		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		
CURRENT_DIGIT RN 12
DIGIT_0 RN 8
DIGIT_1 RN 9
DIGIT_2 RN 10
DIGIT_3 RN 11

	;inicjalizacja wyswietlacza
	LDR R4, = IO0DIR
	LDR R5, =(1<<16)|(1<<17)|(1<<18)|(1<<19)
	STR R5, [R4]
	
	LDR R4, = IO1DIR
	LDR R5, =(1<<16)|(1<<17)|(1<<18)|(1<<19)|(1<<20)|(1<<21)|(1<<22)|(1<<23)
	STR R5, [R4]
	
	mov DIGIT_0, #0
	mov DIGIT_1, #0
	mov DIGIT_2, #0
	mov DIGIT_3, #0	
	
	mov CURRENT_DIGIT, #0
		
main_loop
	
	; czyszcze wyswietlacz
	LDR R4, =IOCLR0
	LDR R5, =(1<<16)|(1<<17)|(1<<18)|(1<<19)
	STR R5, [R4]
	
	LDR R4, =IOCLR1
	LDR R5, =(1<<16)|(1<<17)|(1<<18)|(1<<19)|(1<<20)|(1<<21)|(1<<22)|(1<<23)
	STR R5, [R4]
	
	; wlaczam wybrana cyfre
	LDR R4, =IOSET0
	LDR R5, =(1<<19)
	LSR R5, R5, CURRENT_DIGIT
	STR R5, [R4]
	
	;wybieram ktora liczbe zamienic na seg
	cmp CURRENT_DIGIT, #0
	moveq R6, DIGIT_0
	cmp CURRENT_DIGIT, #1
	moveq R6, DIGIT_1
	cmp CURRENT_DIGIT, #2
	moveq R6, DIGIT_2
	cmp CURRENT_DIGIT, #3
	moveq R6, DIGIT_3
	
	; zamiana na 7segcode
	ADR R4, digits
	add R4, R6
	LDRB R6, [R4]
	
	LDR R4, =IOSET1
	LSL R6, R6, #16
	STR R6, [R4]
	
	; licznik dekadowy
	add DIGIT_0, #1
	cmp DIGIT_0, #10
	moveq DIGIT_0, #0
	addeq DIGIT_1, #1
	
	cmp DIGIT_1, #10
	moveq DIGIT_1, #0
	addeq DIGIT_2, #1
	
	cmp DIGIT_2, #10
	moveq DIGIT_2, #0
	addeq DIGIT_3, #1
	
	cmp DIGIT_3, #10
	moveq DIGIT_3, #0
	
	; licznik obecnie opracowywanej cyfry
	add CURRENT_DIGIT, #1
	cmp CURRENT_DIGIT, #4
	moveq CURRENT_DIGIT, #0
	
	;wywolanie opoznienia
	LDR R0, =1
	bl delay_in_ms
	
	b	main_loop



;Funkcja Delay_in_ms wywolywana z wartoscia R0

delay_in_ms
	LDR R4, =15000
	MUL R5, R0, R4
	
petla
	
	SUBS R5, R5, #1
	BNE petla
	
	MOV PC, LR

digits
	DCB 0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0x7f,0x6f
	ALIGN
	
	END