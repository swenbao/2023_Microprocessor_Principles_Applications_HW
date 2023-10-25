#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x00 ;PC = 0x00

    MOVLF macro num, pos
        MOVLW num ; WREG = num
        MOVWF pos ; pos = WREG
    endm

    initial:
        MOVLF 5, 0x10 ; n value
        MOVLF 2, 0x11 ; k value
        rcall combination ; call combination function
	NOP
        goto finish ; 

    combination:
        MOVF 0x11, W ; WREG = k
        CPFSEQ 0x10 ; if n == k
            goto label ; return 1
        INCF 0x00, F ; 0x00++ ; return 1
        RETURN
        label:
        TSTFSZ 0x11 ; check k value
            goto recur
        INCF 0x00, F ; 0x00++ ; return 1
        RETURN

    recur:
            DECF 0x10, F ; 0x10-- ; n--
            rcall combination ; combination(n-1, k)
            ;MOVFF 0x00, 0x01 ; 0x01 = 0x00

            DECF 0x11, F ; 0x11-- ; k--
            rcall combination ; combination(n-1, k-1)
            MOVF 0x00, W ; WREG = 0x00
	    incf 0x10
	    incf 0x11

            ;ADDWF 0x01, F ; 0x01 += WREG
            ;MOVFF 0x01, 0x00 ; 0x00 = 0x01
            RETURN

    finish:
    end