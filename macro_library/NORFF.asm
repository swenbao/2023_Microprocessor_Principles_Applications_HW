; WREG = reg1 NOR reg2 = ~(reg1 OR reg2)
NOR macro reg1, reg2
    MOVF reg1, W
    IORWF reg2, W
    COMF WREG, W
    endm
