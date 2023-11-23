#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x00 ;PC = 0x00
	
	x equ b'11010111' ;
	MOVLW x ;
	MOVWF TRISA ;
	
	; numerical right shift
	RRCF TRISA ;
	BTFSC TRISA, 6 ;
	    BSF TRISA, 7;
	
	; logical right shift
	RRNCF TRISA ;
	BCF TRISA, 7 ;
	
	end



