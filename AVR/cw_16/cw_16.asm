start: 
ldi R20, 100
ldi R21, 33
loopout:
ldi R20, 100
loopin:
dec R20
brne loopin
dec R21
brne loopout
breq start
nop
