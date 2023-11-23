#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x00 ;PC = 0x00

    ;Variables
    num1 EQU 0x03
    num2 EQU 0x08

    ;macros

    ; store num to [pos]
    ; WREG == num at the end
    MOVLF macro num, pos
	    MOVLB 0
        MOVLW num ; WREG = num
        MOVWF pos ; [pos] = WREG
        endm

    ; store num in [pos] with bank select
    ; BSR = bank, WREG = num at the end
    MOVLFB macro num, pos, bank
        MOVLW num ; WREG = num
        MOVLB bank ; BSR = bank
        MOVWF pos, 1 ; use BSR select bank
        endm

    main:
        MOVLFB num1, 0x00, 1
        MOVLFB num2, 0x01, 1

        LFSR 0, 0x100 ; FSR0 point to [0x100]
	
	    MOVLF 0x04, 0xF0
        loop:
            ; adding part
            MOVF POSTINC0, W ; WREG = [FSR0] ; FSR0 = FSR0 + 1
            ADDWF POSTINC0, W ; WREG = WREG + [FSR0] ; FSR0 = FSR0 + 1
            MOVWF POSTDEC0 ; [FSR0] = WREG

            ; subtracting part
            MOVF POSTINC0, W ; WREG = [FSR0] ; FSR0 = FSR0 + 1
            SUBWF POSTINC0, W ; WREG = [FSR0] - WREG ; FSR0 = FSR0 + 1
            MOVWF POSTDEC0 ; [FSR0] = WREG

        DECFSZ 0xF0, F ; [0xF0] = [0xF0] - 1
            GOTO loop

    end