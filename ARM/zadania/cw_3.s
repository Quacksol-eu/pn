		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		

		
		
main_loop
		
	LDR R0, =5
	BL delay_in_ms
	
	LDR R0, =10
	BL delay_in_ms
	
	B main_loop


delay_in_ms
	LDR R1, =15000
	MUL R2, R0, R1
		
petla
		
	SUBS R2, R2, #1
	BNE petla
	
	MOV		PC, LR	
	
	
	END
