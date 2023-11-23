; [dividend] = [divisor] * [quotient] + [remainder]
; WREG = [quotient]
; dividend >= 0
DIVFF macro reg_dividend, reg_divisor, reg_quotient
    CLRF reg_quotient;
    loop:
        MOVF reg_divisor, W
        SUBWF reg_dividend, F
        BN final
        INCF reg_quotient, F
    BRA loop

    final:
        ADDWF reg_dividend, F
    endm

