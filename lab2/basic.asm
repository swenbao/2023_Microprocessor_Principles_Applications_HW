#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x00 ;PC = 0x00
	
	MOVLW 0x03 ; WREG = 0x03
	MOVLB 1 ; BSR = 1
	MOVWF 0x00, 1 ; use BSR select bank ; [0x100] = WREG
	
	MOVLW 0x08 ; WREG = 0x08
	MOVWF 0x01, 1 ; use BSR select bank ; [0x101] = WREG
	
	LFSR 0, 0x100 ; FSR0 point to [0x100]
	LFSR 1, 0x101 ; FSR1 point to [0x101]
	LFSR 2, 0x102 ; FSR2 point to [0x102]
	
	CLRF 0x00
	MOVLB 0
	MOVLW 0x04
	MOVWF 0x00

	loop:
	    ; [0x102] = [0x101] + [0x100]
	    MOVFF POSTINC1, INDF2 ; [0x102] = [0x101] ; FSR1++
	    MOVF POSTINC0, W ; WREG = [0x100] ; FSR0++
	    ADDWF POSTINC2 ; [0x102] = [0x102] + WREG ; FSR2++

	    ; [0x103] = [0x102] - [0x101]
	    MOVFF POSTINC1, INDF2 ; [0x103] = [0x102] ; FSR1++
	    MOVF POSTINC0, W ; WREG = [0x101] ; FSR0++
	    SUBWF POSTINC2 ; [0x103] = [0x103] - [0x101] ; FSR2++
	    
	    DECFSZ 0x00
	    GOTO loop
 	end
    