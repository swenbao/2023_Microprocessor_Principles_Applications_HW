#include <xc.h>

void CCP1_Initialize() {
    TRISCbits.TRISC2=0;	// RC2 pin is output.
    CCP1CON=28; //ccp mode		// Compare mode(9), initialize CCP1 pin high, clear output on compare match
    PIR1bits.CCP1IF=0;
    IPR1bits.CCP1IP = 1;
    T2CONbits.TMR2ON = 0b1; //Timer2 on
    T2CONbits.T2CKPS = 0b11; // timer2 prescalar = 16
    // for motor
    CCPR1L = 0x5A; //8bit = 0x5A -> 0 degree
    CCP1CONbits.DC1B = 0b10; //2bit = 10
}
    // Timer2 -> On, prescaler -> 1
//    T2CONbits.TMR2ON = 0b1;
//    T2CONbits.T2OUTPS = 0b0000;
//    T2CONbits.T2CKPS = 0b01;
//
//    // Internal Oscillator Frequency, Fosc =  MHz, Tosc =  탎
//    OSCCONbits.IRCF = 0b011;
//    
//    // PWM mode, P1A, P1C active-high; P1B, P1D active-high
//    CCP1CONbits.CCP1M = 0b1100;
    // Set up PR2, CCP to decide PWM period and Duty Cycle
    /** 
     * PWM period
     * = (PR2 + 1) [4 * Tosc] * (TMR2 prescaler)
     * = (0x9b + 1)  * [1탎] * 16
     * = 0.019968s ~= 20ms
     */
//    PR2 = 0;
////    
//    CCPR1L = 0x11;
//    CCP1CONbits.DC1B = 0b01;
/**
     * Duty cycle
     * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
     * = (0x0b*4 + 0b01) * 1탎 * 16
     * = 0.00144s ~= 1450탎  0 degree
     */
