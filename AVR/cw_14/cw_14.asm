start: 
ldi R20, 25
ldi R21, 20
loopout:
ldi R20, 25
loopin:
nop
dec R20
brne loopin
dec R21
brne loopout
breq start

