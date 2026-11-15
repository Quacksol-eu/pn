		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		
	LDR R0, =5
	LDR R1, =15000
	MUL R2, R0, R1
		
petla
		
	SUBS R2, R2, #1
	BNE petla
		
		
main_loop
		
	
	B main_loop

	END

