		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		

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
	
	LDR     R4, =IOSET0
    LDR     R5, =(1<<16)
    STR     R5, [R4]
	
		
main_loop
		
	LDR R0, =5
	BL delay_in_ms
	
	LDR R0, =10
	BL delay_in_ms
	
	B main_loop


delay_in_ms
	LDR R4, =15000
	MUL R5, R0, R4
		
petla
		
	SUBS R5, R5, #1
	BNE petla
	
	MOV		PC, LR	
	
	
	END
