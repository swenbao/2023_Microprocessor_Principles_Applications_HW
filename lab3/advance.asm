#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x00 ;PC = 0x00
	
	leftHigh equ 0x74
	leftLow equ 0x08
	rightHigh equ 0x40
	rightLow equ 0x46
	
	MOVLW leftHigh
	MOVWF 0x00;
	MOVWF 0x20
	MOVLW leftLow
	MOVWF 0x01
	MOVWF 0x21
	MOVLW rightHigh
	MOVWF 0x10
	MOVLW rightLow
	MOVWF 0x11
	
	ADDWF 0x21, F
	
	BNC FUCK
	    INCF 0x20
	FUCK: 
	MOVF 0x10, W
	ADDWF 0x20
	
	end
	
