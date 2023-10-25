#include"xc.inc"
GLOBAL _is_square
    
PSECT mytext, local, class=CODE, reloc=1

_is_square:
    ; set [0x010] = 1
    CLRF 0x010
    INCF 0x010

    loop:
        MOVF 0x010, W ; WREG = [0x010]
	square:
	    CPFSEQ 0x001 ; if WREG == [0x001] skip next line
		GOTO not_square
	    CLRF WREG
	    INCF WREG ; WREG++
	    RETURN ; return WREG
	not_square:
	    CPFSLT 0x001 ; if [0x001] < WREG skip next line
		GOTO routine
	    SETF WREG ; WREG = 0xFF
	    RETURN ; return WREG
	routine:    
	    SUBWF 0x001 ; [0x001] = [0x001] - WREG
	    INCF 0x010 ; [0x010]++
	    INCF 0x010 ; [0x010]++
    GOTO loop
