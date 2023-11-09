#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x00 ;PC = 0x00

    ; store num to [pos]
    ; BSR == 0, WREG == num at the end
    MOVLF macro num, pos
	    MOVLB 0
        MOVLW num ; WREG = num
        MOVWF pos ; [pos] = WREG
        endm

    ; arithmetic right shift
    ARITHRS macro reg
        RRNCF reg ;
        BCF reg, 7
        BTFSC reg, 6 ;
            BSF reg, 7;
        endm

        ; logical right shift
    LOGICRS macro reg
        RRNCF reg ;
        BCF reg, 7
        endm

    num1 EQU b'11010111'
    MOVLF num1, TRISA

    ; arithmetic right shift
    ARITHRS TRISA
    ; logical right shift
    LOGICRS TRISA

    end
