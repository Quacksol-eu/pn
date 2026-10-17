start: 
ldi R22, 5
ldi R20, 101
loopmega:
ldi R21, 26
loopout:
ldi R20, 101
loopin:
dec R20
brne loopin
dec R21
brne loopout
nop                  ; 1
    nop                  ; 2
    nop                  ; 3
    nop                  ; 4
    nop                  ; 5
    nop                  ; 6
    nop                  ; 7
    nop                  ; 8
    nop                  ; 9
    nop                  ; 10
    nop                  ; 11
    nop                  ; 12
    nop                  ; 13
    nop                  ; 14
    nop                  ; 15
    nop                  ; 16
    nop                  ; 17
    nop                  ; 18
    nop                  ; 19
    nop                  ; 20
    nop                  ; 21
    nop                  ; 22
    nop                  ; 23
    nop                  ; 24
    nop                  ; 25
    nop                  ; 26
    nop                  ; 27
    nop                  ; 28
    nop                  ; 29
    nop                  ; 30
    nop                  ; 31
    nop                  ; 32
    nop                  ; 33
    nop                  ; 34
    nop                  ; 35
    nop                  ; 36
    nop                  ; 37
    nop                  ; 38
    nop                  ; 39
    nop                  ; 40
    nop                  ; 41
    nop                  ; 42
    nop                  ; 43
    nop                  ; 44
    nop                  ; 45
dec R22
brne loopmega
breq start
nop