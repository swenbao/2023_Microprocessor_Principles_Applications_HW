#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x00 ;PC = 0x00

    ; store num to [pos]
    ; BSR == 0, WREG == num at the end
    MOVLF macro num, pos
	    MOVLB 0
        MOVLW num ; WREG = num
        MOVWF pos ; [pos] = WREG
        endm
	
    ; variables
	num1 EQU 0x05
	num2 EQU 0x02
	
    main:
        LFSR 0, 0x000 ; FSR0 = 0x000
        LFSR 1, 0x018 ; FSR1 = 0x018
	
	    MOVLF num1, INDF0
	    MOVLF num2, INDF1

        MOVLF 0x08, 0xF0
        loop:
            ; adding part
            MOVF POSTINC0, W ; 
            ADDWF INDF1, W ;
            MOVWF POSTDEC0 ;

            ; substracting part
            MOVF POSTDEC1, W ;
            SUBWF POSTINC0, W ;
            MOVWF INDF1 ;
        DECFSZ 0xF0, F
            goto loop

    end