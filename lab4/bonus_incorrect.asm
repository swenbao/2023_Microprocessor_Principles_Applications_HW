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
        rcall Cnk ; Cnk(n, k)
        goto finish

    Cnk:
        MOVF 0x11, W ; WREG = k
        SUBWF 0x10, W ; WREG = n - k
        MOVWF 0x12 ; 0x12 = n - k

        ; If k > n-k, swap them.
        MOVF 0x12, W ; WREG = n - k
        SUBWF 0x11, W ; WREG = k - (n - k)
        BTFSS STATUS, N ; If k > n-k, N = 0
            rcall swap ; swap(k, n-k)

        rcall Fact
    RETURN

    swap: 
        MOVF 0x11, W ; WREG = 0x11
        MOVFF 0x12, 0x11 ; 0x11 = 0x12
        MOVFF WREG, 0x12 ; 0x12 = WREG
    RETURN

    Fact: 
        ; Compute factorial using recursive relation of Pascal's triangle.
        ; C(n, k) = C(n-1, k) + C(n-1, k-1)
        DECF 0x11, W ; WREG = k - 1
        BNN recur ; if k - 1 >= 0, then goto recur
            INCF 0x00 ; 0x00++
            RETURN
        recur:
            DECF 0x10, F ; 0x10-- ; n--
            rcall Cnk ; Cnk(n-1, k)
            MOVFF 0x00, 0x01 ; 0x01 = 0x00

            DECF 0x11, F ; 0x11-- ; k--
            rcall Cnk ; Cnk(n-1, k-1)
            MOVF 0x00, W ; WREG = 0x00

            ADDWF 0x01, F ; 0x01 += WREG
            MOVFF 0x01, 0x00 ; 0x00 = 0x01
            RETURN

    finish: 
    end