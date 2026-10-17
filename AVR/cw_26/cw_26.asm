MainLoop:
nop
nop
ldi R22, 5
rcall DelayInMs ;
nop
nop
rjmp MainLoop


DelayInMs: 
loopbigInMs:
rcall DelayOneMs ;
dec R22
brne loopbigInMs
ret

DelayOneMs: 
sts 0x60, R22
sts 0x61, R24
loopbigOne:
ldi R22, 1
ldi R24, $30
ldi R25, $F8
loopOne:
adiw R24, 1
brne loopOne
dec R22
brne loopbigOne
lds R22, 0x60
lds R24, 0x61
ret
