        one:
        BTFSS 0x00, 0
            BRA two
        ; state1 
        INCF LATA      
        BRA endTimerISR 
        
        two:
            BTFSS 0x00, 1
                BRA three
            ; state2
            DECF LATA
            BRA endTimerISR

        three:
            BTFSS 0x00, 2
                BRA four
            ; state3
            INCF LATA
            BRA endTimerISR

        four:
            BTFSS 0x00, 3
                BRA endTimerISR 
            ; state4
            DECF LATA
            BRA endTimerISR