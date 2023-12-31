// CONFIG
// PIC18F4520 Configuration Bit Settings

// 'C' source line config statements

// CONFIG1H
#pragma config OSC = INTIO67    // Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
#pragma config FCMEN = OFF      // Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
#pragma config IESO = OFF       // Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

// CONFIG2L
#pragma config PWRT = OFF       // Power-up Timer Enable bit (PWRT disabled)
#pragma config BOREN = SBORDIS  // Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
#pragma config BORV = 3         // Brown Out Reset Voltage bits (Minimum setting)

// CONFIG2H
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config WDTPS = 32768    // Watchdog Timer Postscale Select bits (1:32768)

// CONFIG3H
#pragma config CCP2MX = PORTC   // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = ON      // PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
#pragma config LPT1OSC = OFF    // Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

// CONFIG4L
#pragma config STVREN = ON      // Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
#pragma config XINST = OFF      // Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

// CONFIG5L
#pragma config CP0 = OFF        // Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
#pragma config CP1 = OFF        // Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
#pragma config CP2 = OFF        // Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
#pragma config CP3 = OFF        // Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

// CONFIG5H
#pragma config CPB = OFF        // Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
#pragma config CPD = OFF        // Data EEPROM Code Protection bit (Data EEPROM not code-protected)

// CONFIG6L
#pragma config WRT0 = OFF       // Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
#pragma config WRT1 = OFF       // Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
#pragma config WRT2 = OFF       // Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
#pragma config WRT3 = OFF       // Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

// CONFIG6H
#pragma config WRTC = OFF       // Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
#pragma config WRTB = OFF       // Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
#pragma config WRTD = OFF       // Data EEPROM Write Protection bit (Data EEPROM not write-protected)

// CONFIG7L
#pragma config EBTR0 = OFF      // Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
#pragma config EBTR1 = OFF      // Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
#pragma config EBTR2 = OFF      // Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
#pragma config EBTR3 = OFF      // Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

// CONFIG7H
#pragma config EBTRB = OFF      // Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)

// #pragma config statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.

#include <xc.h>
#define _XTAL_FREQ 125000
#include <pic18f4520.h>

int state = 0;

void __interrupt(high_priority) H_ISR(){
    state += 1;
    if(state == 0){
        CCPR1L = 0x07; // CCPR1L is a file register
        CCP1CONbits.DC1B = 0b10;
    } else if(state == 1){
        CCPR1L = 0x0b; // CCPR1L is a file register
        CCP1CONbits.DC1B = 0b01;
    } else if(state == 2){
        CCPR1L = 0x0F; // CCPR1L is a file register
        CCP1CONbits.DC1B = 0b00;
    } else if(state == 3){
        CCPR1L = 0x0b; // CCPR1L is a file register
        CCP1CONbits.DC1B = 0b01;
    } else if(state == 4){
        CCPR1L = 0x07; // CCPR1L is a file register
        CCP1CONbits.DC1B = 0b10;
        state = 0;
    }
    INTCONbits.INT0IF = 0;
}

void main(void)
{
    // set all pins to digital
    ADCON1 = 0x0f;

    // set up & initialize ports input output
    // output ports
    TRISC = 0x00;  // set RC0~PC8 to output
    LATC = 0x00;  // set RC0~RC8 pins to low
    // input ports
    TRISBbits.RB0 = 1; // set INT0(RB0) to input

    // set up interrupts
    // global
    RCONbits.IPEN = 1; // disable priority levels on interrupts
    INTCONbits.GIE = 1; // enable all unmasked interrupts
    // button interrupt (INT0 / RB0)
    INTCONbits.INT0IE = 1; // enable INT0 external interrupt
    INTCONbits.INT0IF = 0; // clear INT0F interrupt flag
    // No timer2 interrupt here
    //PIR1bits.TMR2IF = 0; // clear TMR2IF interrupt flag
    //IPR1bits.TMR2IP = 1; // set TMR2IP to high priority
    //PIE1bits.TMR2IE = 1; // enable TMR2IE interrupt

    // PWM initialize
    T2CONbits.TMR2ON = 0b1; // activate Timer2
    T2CONbits.T2CKPS = 0b01; // prescaler = 4
    // T2CONbits.T2OUTPS = 0b0000; // postscaler = 1

    // Internal Oscillator Frequency, Fosc = 125 kHz, Tosc = 8 µs
    OSCCONbits.IRCF = 0b001;
    
    // PWM mode, P1A, P1C active-high; P1B, P1D active-high
    CCP1CONbits.CCP1M = 0b1100;
    
    // button already initialize
    // TRISC = 0; // CCP1(RC2) is output
    // TRISB = 1; // RB0 is input
    // LATC = 0; // output low
    
    // Set up PR2, CCP to decide PWM period and Duty Cycle
    /** 
     * PWM period
     * = (PR2 + 1) * 4 * Tosc * (TMR2 prescaler)
     * = (0x9b + 1) * 4 * 8µs * 4
     * = 0.019968s ~= 20ms
     */
    PR2 = 0x9b; // PR2 is a file register
    
    /** 
     * Duty cycle
     * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
     * = (0x07*4 + b'10') * 8µs * 4
     * = 960µs ~= 975µs
     */
    CCPR1L = 0x07; // CCPR1L is a file register
    CCP1CONbits.DC1B = 0b10;
    
    while(1);
    return;
}