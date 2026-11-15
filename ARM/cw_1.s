		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		
	LDR R0, =1000
		
petla
		
	SUBS R0, R0, #1
	BNE petla
		
		
main_loop
		
	
	B main_loop

	END

