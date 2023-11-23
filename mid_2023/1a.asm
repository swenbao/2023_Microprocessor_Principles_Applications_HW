List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00

        ;varibales
        num EQU 0x03

        ; store num to [pos]
        ; BSR == 0, WREG == num at the end
        MOVLF macro num, pos
            MOVLB 0
            MOVLW num ; WREG = num
            MOVWF pos ; [pos] = WREG
            endm


        fib:
            MOVLF 0x01, 0x01
            MOVLF 0x02, 0x02
            
            LFSR 0, 0x01

            MOVLF 0x0C, 0xF0
            loop:
                MOVF POSTINC0, W
                ADDWF POSTINC0, W
                MOVWF POSTDEC0
            DECFSZ 0xF0, F ; [0xF0] = [0xF0] - 1
                GOTO loop

        gay:
            MOVF num, W
            RRNCF WREG
            BCF WREG, 7
            XORWF num, W
            MOVWF 0x00

            end
        

