#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x00 ;PC = 0x00

    MOVLF macro num, pos
        MOVLW num ; WREG = num
        MOVWF pos ; pos = WREG
    endm

    SETAB macro a1, a2, a3, a4, b1, b2, b3, b4
        MOVLF a1, 0x10
        MOVLF a2, 0x11
        MOVLF a3, 0x20
        MOVLF a4, 0x21
        MOVLF b1, 0x12
        MOVLF b2, 0x13
        MOVLF b3, 0x22
        MOVLF b4, 0x23
    endm

    PROCESS macro src1, src2, src3, src4, dest
        ; dest = src1 * src3 + src2 * src4
        MOVF src3, W ; WREG = src3
        MULWF src1 ; PRODL = WREG * src1
        MOVFF PRODL, dest ; dest = PRODL

        MOVF src4, W ; WREG = src4
        MULWF src2 ; PRODL = WREG * src2
        MOVFF PRODL, WREG ; WREG = PRODL
        ADDWF dest, F ; dest = dest + WREG
    endm

    initial:
        SETAB 1, 0, 0, 1, 3, 3, 1, 4
        CLRF WREG
        rcall multiply
        goto finish
    multiply:
        ; matrix multiplication
        ; a1 * b1 + a2 * b3
        PROCESS 0x10, 0x11, 0x12, 0x22, 0x00
        ; a1 * b2 + a2 * b4
        PROCESS 0x10, 0x11, 0x13, 0x23, 0x01
        ; a3 * b1 + a4 * b3
        PROCESS 0x20, 0x21, 0x12, 0x22, 0x02
        ; a3 * b2 + a4 * b4 
        PROCESS 0x20, 0x21, 0x13, 0x23, 0x03
        RETURN

    finish: 
    end