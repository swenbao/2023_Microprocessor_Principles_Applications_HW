#include <xc.h>

void ADC_Initialize(void) {
    //TRISAbits.RA0 = 1;       //analog input port
    TRISA = 0xff;		// Set as input port
    ADCON1 = 0x0e;  	// Ref vtg is VDD & Configure pin as analog pin 
    // ADCON2 = 0x92;  	
    ADFM = 1 ;          // Right Justifie
    ADON = 1;
    ADCON2bits.ADCS = 4; // (7)  set Tad = 1 mu s
    ADCON2bits.ACQT = 2; //4 Tad = 4 mu s
    ADRESH=0;  			// Flush ADC output Register
    ADRESL=0;  
    
    PIE1bits.ADIE = 1;
    PIR1bits.ADIF = 0;
    INTCONbits.PEIE = 1;
    INTCONbits.GIE = 1;
    
    ADCON0bits.GO = 1;
}

int ADC_Read(int channel)
{
    int digital;
    
    ADCON0bits.CHS =  0x07; // Select Channe7
    ADCON0bits.GO = 1;
    ADCON0bits.ADON = 1;
    
    while(ADCON0bits.GO_nDONE==1);

    digital = (ADRESH*256) | (ADRESL);
    return(digital);
}