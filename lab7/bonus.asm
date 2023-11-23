#include "p18f4520.inc"

; CONFIG1H
  CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown Out Reset Voltage bits (Minimum setting)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)

org 0x00
    
goto Initial			    
ISR:				
    org 0x08                ; 大致效果: 每0.5秒會進入一次interrupt

    BTFSS INTCON, INT0IF     ; 檢查INT0是否有觸發interrupt
        BRA timerISR         ; 若沒有觸發，則跳到timerISR，處理timer的interrupt
    BRA buttonISR           ; 若有觸發，則跳到buttonISR，處理button的interrupt

    timerISR:
        BTFSC 0x00, 1
            BRA endTimerISR

        BTFSS 0x00, 0
            BRA count_down
        BRA count_up

        count_up:
            INCF LATA
            BRA endTimerISR
        count_down:
            DECF LATA
            BRA endTimerISR

    buttonISR:
        BTFSC 0x00, 1
            BTG 0x00, 1

        time_interval_shift:
            MOVLW D'244'
            CPFSEQ PR2 ; if PR2 == 244, skip next instruction
                BRA doubletimer
            BRA resetTimer

            resetTimer:
                RRNCF PR2
                RRNCF PR2
                BRA inc_dec_shift
            doubletimer:
                RLNCF PR2;
                
        inc_dec_shift:
            BTG 0x00, 0

    endButtonISR:
        BCF INTCON, INT0IF
        RETFIE                    ; 離開ISR，回到原本程式執行的位址，同時會將GIE設為1，允許之後的interrupt能夠觸發

    endTimerISR:
        BCF PIR1, TMR2IF        ; 離開前記得把TMR2IF清空 (清空flag bit)
        RETFIE
    
Initial:
    CLRF 0x00
    BTG 0x00, 1 ;[0x00] = 00000010
    MOVLW 0x0F
    MOVWF ADCON1
    CLRF TRISA
    CLRF LATA
    BSF RCON, IPEN
    BSF INTCON, GIE
    BCF PIR1, TMR2IF		; 為了使用TIMER2，所以要設定好相關的TMR2IF、TMR2IE、TMR2IP。
    BSF IPR1, TMR2IP
    BSF PIE1 , TMR2IE
    MOVLW b'11111111'	        ; 將Prescale與Postscale都設為1:16，意思是之後每256個週期才會將TIMER2+1
    MOVWF T2CON		; 而由於TIMER本身會是以系統時脈/4所得到的時脈為主
    MOVLW D'122'		; 因此每256 * 4 = 1024個cycles才會將TIMER2 + 1
    MOVWF PR2			; 若目前時脈為250khz，想要Delay 0.5秒的話，代表每經過125000cycles需要觸發一次Interrupt
				; 因此PR2應設為 125000 / 1024 = 122.0703125， 約等於122。
    MOVLW D'00100000'
    MOVWF OSCCON	        ; 記得將系統時脈調整成250kHz
    
main:		
    bra main	    
    
end