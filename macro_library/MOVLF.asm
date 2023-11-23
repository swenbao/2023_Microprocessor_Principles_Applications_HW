; store num to [pos]
    ; BSR == 0, WREG == num at the end
    MOVLF macro num, pos
	    MOVLB 0
        MOVLW num ; WREG = num
        MOVWF pos ; [pos] = WREG
        endm