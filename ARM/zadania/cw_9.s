		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		
CURRENT_DIGIT RN R12
DIGIT_0 RN R8
DIGIT_1 RN R9
DIGIT_2 RN R10
DIGIT_3 RN R11

	LDR		R0, =IO0DIR		
	LDR		R1, =2_11110000
	STR		R1, [R0]

	LDR R4, = IO1DIR
	LDR R5, =2_00000000111111110000000000000000
	LDR R6, [R4]
	ORR R6, R6, R5
	STR R6, [R4]
	
	LDR R4, = IO0DIR
	LDR R5, =2_00000000000011110000000000000000 
	LDR R6, [R4]
	ORR R6, R6, R5
	STR R6, [R4]
	
	LDR R4, =IOSET1
	LDR R5, =(1<<17)|(1<<18)
	STR R5, [R4]
	
	mov CURRENT_DIGIT, #0
	mov DIGIT_0, #0
	mov DIGIT_1, #1
	mov DIGIT_2, #2
	mov DIGIT_3, #3
		
main_loop
		
	mov 	R5, #0xf0000
	LDR     R4, =IOCLR0
	STR     R5, [R4]
	
	mov 	R5, #0xFF0000
	LDR     R4, =IOCLR1
	STR     R5, [R4]
	
	mov 	R6, #0x80000
	mov 	R5, R6, LSR CURRENT_DIGIT
	LDR     R4, =IOSET0
	STR     R5, [R4]
	
	cmp CURRENT_DIGIT, #0 
	moveq R6, DIGIT_0
	cmp CURRENT_DIGIT, #1 
	moveq R6, DIGIT_1
	cmp CURRENT_DIGIT, #2 
	moveq R6, DIGIT_2
	cmp CURRENT_DIGIT, #3 
	moveq R6, DIGIT_3
	
	ADR R4, digits
	add R4, R6
	LDRB R6, [R4]

	LDR     R4, =IOSET1
	LSL 	R6, R6, #16
	STR     R6, [R4]
	
	add CURRENT_DIGIT, #1
	cmp CURRENT_DIGIT, #4
	moveq CURRENT_DIGIT, #0
	
	ldr r0,=200
	bl delay_in_ms
	
	B main_loop


delay_in_ms
	LDR R4, =15000
	MUL R5, R0, R4
		
petla
		
	SUBS R5, R5, #1
	BNE petla
	
	MOV		PC, LR	
	

digits
		DCB		0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
		ALIGN

	END