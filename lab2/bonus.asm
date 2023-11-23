#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x00 ;PC = 0x00
	
	num0 equ 0xB5
	num1 equ 0xF8
	num2 equ 0x64
	num3 equ 0x74
	num4 equ 0xA8
	num5 equ 0x15
	MOVLB 1 ; BSR = 1
	
	MOVLW num0
	MOVWF 0x00, 1;
	MOVLW num1
	MOVWF 0x01, 1;
	MOVLW num2
	MOVWF 0x02, 1;
	MOVLW num3
	MOVWF 0x03, 1;
	MOVLW num4
	MOVWF 0x04, 1;
	MOVLW num5
	MOVWF 0x05, 1;
	
	LFSR 0, 0x100
	LFSR 1, 0x104
	
	
	

    靈光閃線
    測試 BN / BNN 之類的
    看 Negative flag 是什麼情況下會被 set 

    理想狀況是可以拿來用
    while(left < right)
    -> if left-right is negative GOTO OUTER_LOOP

    GOTO DONE
	OUTER_LOOP


    DONE:

	end



; Define constants for data memory addresses
DATA_ADDRESS_START  EQU 0x100
RESULT_ADDRESS_START  EQU 0x110

; Define constants for the array size
ARRAY_SIZE EQU 6

; Define the indirect addressing register
INDIRECT_REGISTER FSR

; Define temporary variables
TEMP_VAR1 EQU 0x30
TEMP_VAR2 EQU 0x31

ORG 0x00
GOTO MAIN ; Jump to the main program

; Interrupt service routine (if needed)
; ...

MAIN:
    ; Initialize the FSR to point to the start of the data array
    MOVLW DATA_ADDRESS_START
    MOVWF INDIRECT_REGISTER

    ; Load values into an array in data memory
    MOVLW 0xB5
    MOVWF INDIRECT_REGISTER
    INCF INDIRECT_REGISTER, F
    
    MOVLW 0xF8
    MOVWF INDIRECT_REGISTER
    INCF INDIRECT_REGISTER, F
    
    MOVLW 0x64
    MOVWF INDIRECT_REGISTER
    INCF INDIRECT_REGISTER, F
    
    MOVLW 0x7F
    MOVWF INDIRECT_REGISTER
    INCF INDIRECT_REGISTER, F
    
    MOVLW 0xA8
    MOVWF INDIRECT_REGISTER
    INCF INDIRECT_REGISTER, F
    
    MOVLW 0x15
    MOVWF INDIRECT_REGISTER

    ; Sort the array using cocktail sort
    MOVLW ARRAY_SIZE - 1 ; Outer loop counter
    MOVWF TEMP_VAR1
OUTER_LOOP:
    MOVLW ARRAY_SIZE - 1 ; Inner loop counter
    MOVWF TEMP_VAR2
INNER_LOOP:
    ; Load elements for comparison
    MOVLW 0x01
    SUBWF TEMP_VAR2, F
    ADDWF INDIRECT_REGISTER, W
    MOVF INDF, W
    MOVWF TEMP_VAR1
    
    MOVLW 0x01
    ADDWF TEMP_VAR2, F
    ADDWF INDIRECT_REGISTER, W
    MOVF INDF, W
    
    ; Compare and swap if necessary
    SUBWF TEMP_VAR1, W
    BTFSC STATUS, C
    GOTO SKIP_SWAP
    
    ; Swap elements
    MOVLW 0x01
    ADDWF TEMP_VAR2, F
    ADDWF INDIRECT_REGISTER, W
    MOVF INDF, W
    MOVWF TEMP_VAR1
    
    MOVLW 0x01
    SUBWF TEMP_VAR2, F
    ADDWF INDIRECT_REGISTER, W
    MOVF TEMP_VAR1, W
    MOVWF INDF
    
SKIP_SWAP:
    ; Continue inner loop
    DECF TEMP_VAR2, F
    BTFSS STATUS, Z
    GOTO INNER_LOOP
    
    ; Continue outer loop
    DECF TEMP_VAR1, F
    BTFSS STATUS, Z
    GOTO OUTER_LOOP

    ; Store the sorted array in result memory
    MOVLW ARRAY_SIZE
    MOVWF TEMP_VAR1 ; Reset the outer loop counter
    MOVLW DATA_ADDRESS_START ; Reset the FSR to the beginning of the array
    MOVWF INDIRECT_REGISTER

STORE_RESULT:
    ; Load an element from the sorted array
    MOVF INDF, W
    
    ; Store it in the result memory
    MOVLW RESULT_ADDRESS_START
    ADDWF TEMP_VAR1, F
    MOVWF INDIRECT_REGISTER
    MOVWF INDF

    ; Increment the outer loop counter
    DECF TEMP_VAR1, F
    BTFSS STATUS, Z
    GOTO STORE_RESULT

    ; End of program
    NOP

; End of program
