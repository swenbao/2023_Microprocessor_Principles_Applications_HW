; XOR without using XORWF
; WREG = re1 XOR reg2 = (~reg1 AND reg2) OR (reg1 AND ~reg2)
; !!!! use 0xF0 as a temporary register, make sure you don't use it for anything else !!!

XOR macro reg1, reg2 
    ; collect ~reg1 AND reg2
    COMF reg1, W ; WREG = ~reg1
    ANDWF reg2, W ; WREG = ~reg1 AND reg2
    MOVWF 0xF0 ; 0xF0 = ~reg1 AND reg2

    ; collect reg1 AND ~reg2
    COMF reg2, W ; WREG = ~reg2
    ANDWF reg1, W ; WREG = reg1 AND ~reg2

    ; collect (~reg1 AND reg2) OR (reg1 AND ~reg2)
    ; WREG = 0xF0 OR WREG
    IORWF 0xF0, W ; WREG = (~reg1 AND reg2) OR (reg1 AND ~reg2)
    endm