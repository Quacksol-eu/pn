MainLoop:
nop
nop
ldi R16, low(5)
ldi R17, high(5)
rcall DelayInMs ;
nop
nop
rjmp MainLoop


DelayInMs: 
push R16
push R17
loopbigInMs:
rcall DelayOneMs ;
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

