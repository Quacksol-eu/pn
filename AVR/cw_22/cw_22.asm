MainLoop:
nop
nop
ldi R22, 5
rcall DelayInMs ;
nop
nop
rjmp MainLoop


DelayInMs: 
loopbig:
ldi R24, $30
ldi R25, $F8
loop:
adiw R24, 1
brne loop
dec R22
brne loopbig
ret
