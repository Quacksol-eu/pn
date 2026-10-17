start: 
ldi R22, 5
ldi R16, 1    
ldi R17, 0
loopbig:
ldi R20, $30
ldi R21, $F8
loop:
add R20, R16
adc R21, R17
brne loop
dec R22
brne loopbig
breq start
nop