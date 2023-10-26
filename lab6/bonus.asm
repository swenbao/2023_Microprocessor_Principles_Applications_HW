LIST p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67 ; 1 MHZ
    CONFIG WDT = OFF
    CONFIG LVP = OFF

    L1	EQU 0x14
    L2	EQU 0x15
    org 0x00
	
; Total_cycles = 2 + (2 + 7 * num1 + 2) * num2 cycles
; num1 = 200, num2 = 180, Total_cycles = 252360
; Total_delay ~= Total_cycles/1M = 0.25s
DELAY macro num1, num2 
    local LOOP1         ; innerloop
    local LOOP2         ; outerloop
    MOVLW num2          ; 2 cycles
    MOVWF L2
    LOOP2:
	MOVLW num1          ; 2 cycles
	MOVWF L1
    LOOP1:
	NOP                 ; 7 cycles
	NOP
	NOP
	NOP
	NOP
	NOP
	DECFSZ L1, 1
	BRA LOOP1
	DECFSZ L2, 1        ; 2 cycles
	BRA LOOP2
endm

initialize:
    ; [0x000] record the state
    CLRF 0x000
    ; let pin can receive digital signal 
    MOVLW 0x0f
    MOVWF ADCON1          ;set digital IO

    CLRF PORTB
    BSF TRISB, 0         ;set RB0 as input TRISB = 0000 0001
    CLRF LATA
    CLRF TRISA           ;set RA0~RA7 as output TRISA = 0000 0000

; ckeck button
check_process:        
    BTFSC PORTB, 0
        GOTO check_process
    BTG LATA, 0
    GOTO state_one

state_one:
    MOVLW b'00000001'
    BTFSC LATA, 4
        MOVWF LATA
    DELAY d'200', d'100' ;delay 0.5s
    RLNCF LATA
    BTFSS PORTB, 0
        GOTO state_two
GOTO state_one

state_two:
    MOVLW b'00001000'
    BTFSC LATA, 7
        MOVWF LATA
    DELAY d'200', d'100' ;delay 0.5s
    RRNCF LATA
    BTFSS PORTB, 0
        GOTO wait_for_a_sec
GOTO state_two
    
wait_for_a_sec:
    DELAY d'200', d'180'
    GOTO check_process
end