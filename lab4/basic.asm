#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x00 ;PC = 0x00

    MOVLF macro num, pos
        MOVLW num ; WREG = num
        MOVWF pos ; pos = WREG
    endm
	 
	Add_Mul macro xh, xl, yh, yl 
        ; Addition Part
        MOVLF xh, 0x00 ; WREG = xh ; 0x00 = xh
        MOVLF xl, 0x01 ; WREG = xl ; 0x01 = xl

        MOVLW yl ; WREG = yl
        ADDWF 0x01, F ; 0x01 + WREG ; 0x01 = xl + yl
        
        BNC FUCK ; if not carry
            INCF 0x00 ; then don't increament 0x00
        FUCK: 
        MOVLW yh ; WREG = yh
        ADDWF 0x00 ; 0x00 + WREG ; 0x00 = xh + yh

        ; Multiply Part
        MOVF 0x00, W ; WREG = 0x00
        MULWF 0x01, W ; WREG = 0x00 * 0x01

        step1: 
            MOVF 0x01, W    ; WREG = op2
            BTFSC 0x00, 7   ; if(op1 < 0)
                SUBWF PRODH ; PRODH -= op2
        
        step2:
            MOVF 0x00, W    ; WREG = op1
            BTFSC 0x01, 7   ; if(op2 < 0)
                SUBWF PRODH ; PRODH -= op1

        MOVFF PRODH, 0x10 ; 
        MOVFF PRODL, 0x11 ;
	endm

    Add_Mul 0x04, 0x02, 0x0A, 0x04
    end