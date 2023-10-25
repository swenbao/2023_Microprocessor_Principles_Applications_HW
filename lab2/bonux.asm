#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x00 ;PC = 0x00
	
	x equ 0xB5
	y equ 0xF8
	z equ 0x64
	a equ 0x7F
	b equ 0xA8
	c equ 0x15

	MOVLB 1 ; BSR = 1
	MOVLW x
	MOVWF 0x00, 1;
	MOVLW y
	MOVWF 0x01, 1;
	MOVLW z
	MOVWF 0x02, 1;
	MOVLW a
	MOVWF 0x03, 1;
	MOVLW b 
	MOVWF 0x04, 1;
	MOVLW c
	MOVWF 0x05, 1;
	
	LFSR 0, 0x100
	LFSR 1, 0x101

	CLRF 0x0A, 1 ; [0x0A] = 0 ; left
	MOVLW 5 ; WREG = 5
	MOVWF 0x0B, 1 ; [0x0B] = 5 right
	
	OUTER_LOOP:
	    
        ; first loop
        MOVF 0x0A, W, 1 ; WREG = [0x10A] = left
        ; this is  how many time the loop will run
        SUBWF 0x0B, W, 1 ; WREG = right - left = [0x10B] - [0x10A] 
        MOVWF 0x0C, 1 ; [0x10C] = WREG

        FIRST_LOOP:
            MOVF INDF1, W ; WREG = FSR1
            CPFSGT INDF0 ; if (FSR0 > FSR1) skip next line
            GOTO FIRST_DONE
                MOVFF INDF0, INDF1 ; 
                MOVWF INDF0 ;
            FIRST_DONE:
            MOVF PREINC0 ; FSR0++
            MOVF PREINC1 ; FSR1++
	    DECFSZ 0x0C, F, 1
	        GOTO FIRST_LOOP
        DECF 0x0B, F, 1 ; right-- ; [0x10B]--
	
	MOVF POSTDEC0 ; FSR0--
	MOVF POSTDEC1 ; FSR1--
	MOVF POSTDEC0 ; FSR0--
	MOVF POSTDEC1 ; FSR1--
	    
        ; second loop
        MOVF 0x0A, W, 1 ; WREG = [0x10A] = left
        ; this is  how many time the loop will run
        SUBWF 0x0B, W, 1 ; WREG = right - left = [0x10B] - [0x10A] 
        MOVWF 0x0C, 1 ; [0x10C] = WREG

        SECOND_LOOP:
            MOVF INDF1, W ; WREG = FSR1
            CPFSGT INDF0 ; if (FSR0 > FSR1) skip next line
            GOTO SECOND_DONE
                MOVFF INDF0, INDF1 ; 
                MOVWF INDF0 ;
            SECOND_DONE:
            MOVF POSTDEC0 ; FSR0--
            MOVF POSTDEC1 ; FSR1--
	    DECFSZ 0x0C, F, 1
	        GOTO SECOND_LOOP
        INCF 0x0A, F, 1 ; left++ ; [0x10A]++
	
	MOVF POSTINC0 ; FSR0++
	MOVF POSTINC1 ; FSR1++
	MOVF POSTINC0 ; FSR0++
	MOVF POSTINC1 ; FSR1++

    MOVF 0x0B, W, 1 ; WREG = right
    SUBWF 0x0A, W, 1 ; WREG = left - right
    BN OUTER_LOOP ; if(left - right < 0) GOTO OUTER_LOOP
end