ldi R16, 2
square:
ldi R30, low(Table<<1) 
ldi R31, high(Table<<1)

add R30, R16
clr R16
adc R31, R16
lpm R21, Z 

nop

Table: .db 0,1,4,9,16,25,36,49,64,81