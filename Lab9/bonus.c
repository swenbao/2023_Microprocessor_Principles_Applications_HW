#include <xc.h>
#include<stdio.h>
#include<stdlib.h>
#include <time.h>

#pragma config OSC = INTIO67  //OSCILLATOR SELECTION BITS (INTERNAL OSCILLATOR BLOCK, PORT FUNCTION ON RA6 AND RA7)
#pragma config WDT = OFF      //Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PWRT = OFF     //Power-up Timer Enable bit (PWRT disabled)
#pragma config BOREN = ON     //Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
#pragma config PBADEN = OFF   //PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF      //Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
#pragma config CPD = OFF      //Data EEPROM Code Protection bit (Data EEPROM not code-protected)

void __interrupt(high_priority)H_ISR(){
    
    //step4
    int value = ADRESH;
    
    //do things
    CCPR1L = value;

    //clear flag bit
    PIR1bits.ADIF = 0;
    
    //step5 & go back step3
    //delay at least 2tad
    ADCON0bits.GO = 1;
    
    return;
}

void main(void) 
{
    //configure OSC and port
    OSCCONbits.IRCF = 0b110; // 4MHz
    // TRISAbits.RA0 = 1;       // analog input port
    TRISA = 0b00000001;
    
    //step1
    ADCON1bits.VCFG0 = 0;
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110; //AN0 為analog input,其他則是 digital
    ADCON0bits.CHS = 0b0000;  //AN0 當作 analog input

    ADCON2bits.ADCS = 0b100;  // 查表後設100(2.86Mhz < 4Mhz < 5.71MHz)
    ADCON2bits.ACQT = 0b010;  // Tad = 1 us acquisition time設4Tad = 4 > 2.4
    ADCON0bits.ADON = 1;    // Enable ADC module
    ADCON2bits.ADFM = 0;    //left justified 
    
    
    //step2
    PIE1bits.ADIE = 1; // Enable ADC interrupt
    PIR1bits.ADIF = 0; // Clear ADC interrupt flag
    INTCONbits.PEIE = 1; // Enable peripheral interrupt
    INTCONbits.GIE = 1; // Enable global interrupt

    // Output Part
    // button input initialize
    TRISC = 0x00;  // set RC0~PC8 to output
    LATC = 0x00;  // set RC0~RC8 pins to low
    RCONbits.IPEN = 0; // disable priority levels on interrupts

    // PWM initialize
    T2CONbits.TMR2ON = 0b1; // activate Timer2
    T2CONbits.T2CKPS = 0b01; // prescaler = 4

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

    //step3
    ADCON0bits.GO = 1; // Start ADC
    
    while(1);
    
    return;
}