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