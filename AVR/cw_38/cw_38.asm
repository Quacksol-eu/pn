ldi R16, 5
DigitTo7segCode:
push R30
push R31
push R16

ldi R30, low(Table<<1) 
ldi R31, high(Table<<1)

add R30, R16
clr R16
adc R31, R16
lpm R21, Z

pop R16
pop R31
pop R30

Table: .db 63, 6, 91, 79, 102, 109, 125, 7, 127, 111