MainLoop:
nop
nop
ldi R22, 5
rcall DelayInMs ;
rcall DelayOneMs ;
nop
nop
rjmp MainLoop


DelayInMs: 
loopbigInMs:
ldi R24, $30
ldi R25, $F8
loopInMs:
adiw R24, 1
brne loopInMs
dec R22
brne loopbigInMs
ret

DelayOneMs: 
loopbigOne:
ldi R22, 1
ldi R24, $30
ldi R25, $F8
loopOne:
adiw R24, 1
brne loopOne
dec R22
brne loopbigOne
ret

