#include"xc.inc"
GLOBAL _multi_signed
    
PSECT mytext, local, class=CODE, reloc=2

_multi_signed: 
    ; parameter (unsigned char a, unsigned char b)
    ; WREG = unsigned char a
    ; [0x001] = unsigned char b
    
    ; copy a to 0x020 for following use
    ; copy b to 0x021 for following use
    MOVWF 0x020
    MOVFF 0x001, 0x021

    ; 8 bits a * 8 bits b
    ; signed extension of 4 bits b is done by C
    ; optimized multiplier

    loop_init:
        MOVLW 0x08 ; 8 round of loop
        MOVWF 0x010 ;
    loop:
        BTFSC 0x001, 0 ; if LSB of [0x001] is 0, skip next line
            ADDWF 0x000 ; add a to [0x000]
        BCF 0x001, 0 ; clear LSB of [0x001]
        RRNCF 0x001 ; shift [0x001] right by 1 bit
        BTFSC 0x000, 0 ; if LSB of [0x000] is 0, skip next line
            BSF 0x001, 0 ; set LSB of [0x001]
        BCF 0x000, 0 ; clear LSB of [0x000]
        RRCF 0x000 ; shift [0x000] right by 1 bit
    DECFSZ 0x010 ; decrement 0x010 and skip next line if 0
    GOTO loop ; jump to loop

    step1: 
        MOVF 0x021, W    ; WREG = b
        BTFSC 0x020, 7   ; if(a < 0)
            SUBWF 0x000  ; 0x000 -= b
    
    step2:
        MOVF 0x020, W    ; WREG = a
        BTFSC 0x021, 7   ; if(b < 0)
            SUBWF 0x000  ; 0x000 -= a

    MOVFF 0x000, 0x002 
    RETURN