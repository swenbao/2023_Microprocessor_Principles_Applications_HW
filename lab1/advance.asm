List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00

    ; initialize 
    ;num1
	MOVLW 0x10 ; WREG = num1
	MOVWF 0x02 ; [0x001] = WREG
    ;num2
	MOVLW b'00001010' ; WREG = num2
	MOVWF 0x00 ; [0x000] = WREG

    ; memorize the initial [0x000] value for comparison
    MOVWF 0x01 ; [0x000] = WREG

    loop:
        BTFSC 0x00, 0 ; even then skip next line
            GOTO odd
        ;even:
            INCF 0x02
            GOTO done
        odd:ww
            DECF 0x02
            ;GOTO done
        done:

        RRNCF 0x00
        MOVF 0x00, W
        CPFSEQ 0x01 ; if [0x001] == WREG, then skip next line
            GOTO loop 
    end

;    do: 
;        if([0x000] % 2 == 0):
;            [0x002] = [0x002] + 1
;        else 
;            [0x002] = [0x002] - 1
;
;        [0x000] >> 1
;
;        if([0x000] == init) break;
;    while