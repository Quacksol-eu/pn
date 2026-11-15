		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		
CURRENT_DIGIT RN R12

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
	mov R11, #4
		
main_loop
		
	mov 	R5, #0xf0000
	LDR     R4, =IOCLR0
	STR     R5, [R4]
	
	mov 	R6, #0x80000
	mov 	R5, R6, LSR CURRENT_DIGIT
	LDR     R4, =IOSET0
	STR     R5, [R4]
	
	add CURRENT_DIGIT, #1
	cmp CURRENT_DIGIT, R11
	eoreq CURRENT_DIGIT, R11
	
	ldr r0,=2000
	bl delay_in_ms
	
	B main_loop


delay_in_ms
	LDR R4, =15000
	MUL R5, R0, R4
		
petla
		
	SUBS R5, R5, #1
	BNE petla
	
	MOV		PC, LR	
	
	
	END
