#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x00 ;PC = 0x00

	; [0x000] = 0x05
	MOVLW 0x05 ; WREG = 0x05
	MOVWF 0x00 ; [0x00] = WREG

	; [0x018] = 0x02
	MOVLW 0x02 ; WREG = 0x02
	MOVWF 0x18 ; [0x00] = WREG

	LFSR 0, 0x000 ; FSR0 point to [0x000]
	LFSR 1, 0x017 ; FSR1 point to [0x017]
	
	CLRF 0x0F
	MOVLW 0x08
	MOVWF 0x0F

	loop:
	    MOVF INDF0, W ; WREG = [0x000] ; LFSR0 == [0x000]
	    MOVWF PREINC0 ; LFSR0 == [0x001] ; [0x001] = WREG 
	    MOVWF POSTINC1 ; [0x017] = WREG ; LFSR1 == [0x018]
	    MOVF POSTDEC1, W ; WREG = [0x018] ; LSFR1 == [0x017]
	    ADDWF INDF0 ; [0x001] += WREG
	    SUBWF POSTDEC1 ; [0x017] -= WREG 
	    
	    DECFSZ 0x0F
	    GOTO loop
	end