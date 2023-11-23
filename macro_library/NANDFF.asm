; WREG = reg1 NAND reg2 = ~(reg1 AND reg2)
NAND macro reg1, reg2
    MOVF reg1, W
    ANDWF reg2, W
    COMF WREG, W
    endm
