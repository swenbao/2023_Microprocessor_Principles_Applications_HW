List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00

    MOVLF macro num, pos
        MOVLW num ; WREG = num
        MOVWF pos ; pos = WREG
    endm

    ; reg2 = re1 XOR reg2 = (not reg1 AND reg2) OR (reg1 AND not reg2)
    ; WREG = result 
    XOR macro reg1, reg2 
        ; collect not reg1 AND reg2
        COMF reg1, W ; WREG = not reg1
        ANDWF reg2, W ; WREG = not reg1 AND reg2
        MOVWF 0xF0 ; 0xF0 = not reg1 AND reg2

        ; collect reg1 AND not reg2
        COMF reg2, W ; WREG = not reg2
        ANDWF reg1, W ; WREG = reg1 AND not reg2

        ; collect (not reg1 AND reg2) OR (reg1 AND not reg2)
        ; WREG = 0xF0 OR WREG
        IORWF 0xF0, W ; WREG = (not reg1 AND reg2) OR (reg1 AND not reg2)
    endm

    main: 
        var equ b'01100010' ; test data

        ; put test data in [0x00] and [0x01]
        MOVLF var, 0x00
        MOVWF 0x01

        ; right rotate [0x01]
        RRNCF 0x01, F
        BCF 0x01, 7

        XOR 0x00, 0x01 ; WREG = 0x00 XOR 0x01
        MOVWF 0x01

    end 

