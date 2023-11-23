List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
 
	; initialize 
	;x1
	MOVLW 0x04 ; WREG = x1 = 0x04
	MOVWF 0x00 ; [0x000] = WREG	
    ;x2
	MOVLW 0x02 ; WREG = x2 = 0x02
	MOVWF 0x01 ; [0x001] = WREG
	;y1
	MOVLW 0x0A ; WREG = y1 = 0x0A
	MOVWF 0x02 ; [0x002] = WREG
	;y2
	MOVLW 0x04 ; WREG = y2 = 0x04
	MOVWF 0x03 ; [0x003] = WREG
	
	;y1-y2 -> subtract y2 from y1 (now WREG == y2) -> subtract WREG from y1
	MOVFF 0x02, 0x11 ; [0x011] = y1 = [0x002]
	SUBWF 0x11, F	
	
	;x1+x2 (now WREG == y2)
	MOVFF 0x00, 0x10 ; [0x010] = x1 = [0x000]
	MOVF 0x01, W ; WREG = x2 = [0x001]
	ADDWF 0x10, F ; [0x010] = [0x010] + WREG = x1 + x2
	
	; tell if equal
	MOVF 0x10, W ; WREG = [0x010]
	CPFSEQ 0x11 ; if [0x011] == WREG, then skip next line
	    GOTO unequal
	GOTO equal

	unequal:
	    CLRF 0x20 ; WREG = 0x01
	    INCF 0x20
	    GOTO done
	equal:
	    SETF 0x20
	done:
	end