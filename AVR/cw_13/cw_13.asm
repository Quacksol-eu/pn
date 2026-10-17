start: ldi R20, 5
loop: dec R20
brne loop
breq start
nop

; Cycles = 3 * R20   (dla pomiaru do momentu wejœcia na breq)
; 1 ldi + 4*3 (dec + 2*brne (skok)) + 1 dec + 1 brne bez zawrotki
; Cycles = (3 * R20) + 2   (dla pe³nej pêtli wraz ze skokiem breq)
; Dla 5*R20 dwa nop po dec R20 (Cykl pe³ny +2 
