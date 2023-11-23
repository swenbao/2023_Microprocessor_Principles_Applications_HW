#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x00 ;PC = 0x00

    ; variables
    leftHigh equ 0x74
	leftLow equ 0x08
	rightHigh equ 0x40
	rightLow equ 0x46

    ; macros
    ; 16 bits adder
    ; operate on registers
    ; You have to store the corresponding values in the registers
    ADD macro reg_leftHigh, reg_leftLow, reg_rightHigh, reg_rightLow, reg_resultHigh, reg_resultLow
        ; add low bytes
        MOVF reg_leftLow, W
        ADDWF reg_rightLow, W
        MOVWF reg_resultLow
        
        ; test carry
        BTFSC STATUS, C
            INCF reg_leftHigh, F

        MOVF reg_leftHigh, W
        ADDWF reg_rightHigh, W
        MOVWF reg_resultHigh
        endm
    
    ; store num to [pos]
    ; BSR == 0, WREG == num at the end
    MOVLF macro num, pos
	    MOVLB 0
        MOVLW num ; WREG = num
        MOVWF pos ; [pos] = WREG
        endm

    main:
        MOVLF leftHigh, 0x00;
        MOVLF leftLow, 0x01;
        MOVLF rightHigh, 0x10;
        MOVLF rightLow, 0x11;
        ADD 0x00, 0x01, 0x10, 0x11, 0x20, 0x21
        end