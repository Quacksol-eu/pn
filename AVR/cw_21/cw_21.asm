MainLoop:
nop
nop
rcall DelayNCycles ;
nop
nop
rjmp MainLoop
DelayNCycles: ;zwyk³a etykieta
nop
rcall Another ;
nop
ret ;powrót do miejsca wywo³ania
Another:
nop 
nop
ret
