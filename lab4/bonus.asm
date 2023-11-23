#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x00 ;PC = 0x00

    MOVLF macro num, pos
        MOVLW num ; WREG = num
        MOVWF pos ; pos = WREG
    endm

    initial:
        MOVLF 3, 0x10 ; n value
        MOVLF 1, 0x11 ; k value
        rcall combination ; call combination function
	    NOP
        goto finish ; 

    combination:
        MOVF 0x11, W ; WREG = k
        CPFSEQ 0x10 ; if n == k
            goto nNEQUk
        goto nEQUk ; return 1

        nEQUk:  ; if n == k
            INCF 0x00, F ; 0x00++ ; return 1
            RETURN
        nNEQUk: ; if n != k
            TSTFSZ 0x11 ; check k value
                goto recur ; if k != 0
            goto kEQU0

        kEQU0:  ; if k == 0
            INCF 0x00, F ; 0x00++ ; return 1
            RETURN

    recur: ; if k != 0
        DECF 0x10, F ; [0x10]-- ; n--
        rcall combination ; combination(n-1, k)

        DECF 0x11, F ; 0x11-- ; k--
        rcall combination ; combination(n-1, k-1)

        INCF 0x10
        INCF 0x11

        RETURN

    finish:
    end