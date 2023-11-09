; store num in [pos] with bank select
; BSR = bank, WREG = num at the end
MOVLFB macro num, pos, bank
    MOVLW num ; WREG = num
	MOVLB bank ; BSR = bank
	MOVWF pos, 1 ; use BSR select bank
    endm