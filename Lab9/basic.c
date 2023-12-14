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
    value >>= 4;
    LATAbits.RA1 = value & 0b0001;
    LATAbits.RA2 = value & 0b0010;
    LATAbits.RA3 = value & 0b0100;
    LATAbits.RA4 = value & 0b1000;
    
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

    //step3
    ADCON0bits.GO = 1; // Start ADC
    
    while(1);
    
    return;
}