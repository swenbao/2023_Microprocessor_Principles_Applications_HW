#include"xc.inc"
GLOBAL _lcm
    
PSECT mytext, local, class=CODE, reloc=2

_lcm:
    ; unsigned int lcm(unsigned int a, unsigned int b)
    ; [0x002]|[0x001] == a
    ; [0x004]|[0x003] == b

    ; copy to next line
    MOVFF 0x001, 0x011
    MOVFF 0x002, 0x012
    MOVFF 0x003, 0x013
    MOVFF 0x004, 0x014

    loop:

        MOVF 0x004, W ; WREG = [0x004] == bHigh
        CPFSEQ 0x002 ; if([0x002] == WREG) -> if(aHigh == bHigh), then skip nextLine
            GOTO high_tell
        MOVF 0x003, W ; WREG = [0x003] == bLow
        CPFSEQ 0x001 ; if([0x001] == WREG) -> if(aLow == bLow), then skip nextLine
            GOTO low_tell
        RETURN
        
        high_tell:
            ; currently WREG == [0x004] == bHigh
            CPFSGT 0x002 ; if([0x002] > WREG) -> if(aHigh > bHigh), then skip nextLine
                GOTO a_small
            GOTO b_small

        low_tell:
            ; currently WREG == [0x003] == bLow
            CPFSGT 0x001 ; if([0x001] > WREG) -> if(aLow > bLow), then skip nextLine
                GOTO a_small
            GOTO b_small

        b_small:
            MOVF 0x013, W ; WREG = [0x003] == bLow
            ADDWF 0x003 ; [0x003] += WREG ; bLow *= 2
            MOVF 0x014, W ; WREG = [0x004] == bHigh
            ADDWFC 0x004 ; [0x003] += WREG ; bHigh *= 2
            GOTO loop
        
        a_small:
            MOVF 0x011, W ; WREG = [0x001] == aLow
            ADDWF 0x001 ; [0x001] += WREG ; aLow *= 2
            MOVF 0x012, W ; WREG = [0x002] == aHigh
            ADDWFC 0x002 ; [0x002] += WREG ; aHigh *= 2
            GOTO loop