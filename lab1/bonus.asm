List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00

    ; initialize 
    ; [0x000] = binary code
	MOVLW b'01100010' ; WREG = binary code
	MOVWF 0x00 ; [0x000] = WREG = binary code

    ; binary : b7 b6 b5 b4 b3 b2 b1 b0
    ; gray   : g7 g6 g5 g4 g3 g2 g1 g0
    
    ; g6 = b7 XOR b6
    ; g5 = b6 XOR b5
    ; g4 = b5 XOR b4
    ; g3 = b4 XOR b3
    ; g2 = b3 XOR b2
    ; g1 = b2 XOR b1
    ; g0 = b1 XOR b0

    ; we put gray code result in [0x001]
    ; First, we put right shift binary code in [0x001]
    ; [0x001] = b0 b7 b6 b5 b4 b3 b2 b1

    MOVWF 0x01 ; [0x001] = WREG = binary code
    RRNCF 0x01 ; right shift [0x001]

    ; then we [0x01] XOR WREG (now WREG == binary code)
    ; XORWF 0x01
    ; but we can't use XOR 
    ; [0x01] ⊕ WREG = (¬[0x01] ∧ WREG) ∨ ([0x01] ∧ ¬WREG)

    ; collect element put them in diff file register
    ; [0x02] = ¬[0x01]
    MOVFF 0x01 0x02
    COMF 0x02
    ; [0x03] = WREG
    ; MOVWF 0x03
    ; [0x04] = [0x01]
    ; MOVFF 0x01 0x04
    ; [0x05] = ¬WREG
    MOVWF 0x05
    COMF 0x05

    ; [0x02] = ¬[0x01] ∧ WREG
    ANDWF 0x02 

    ; WREG = [0x01] ∧ ¬WREG
    MOVF 0x05, W 
    ANDWF 0x01, W

    ; 0x02 v WREG
    IORWF 0x02
    MOVFF 0x02 0x01

    ; then set g7 = b7
    BTFSC 0x00, 7 ; if b7 is 0, then skip next line
        GOTO set
    
    ; clear g7 (to 0)
    BCF 0x01,7
    GOTO done

    ; set g7 (to 1)
    set:
        BSF 0x01, 7 
    done:
    
    end