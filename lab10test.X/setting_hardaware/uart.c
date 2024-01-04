#include <xc.h>
    //setting TX/RX
#include<string.h>
char mystring[20];
int lenStr = 0;
//defind the objects in a score
//enum note{
//    B3 = 0, 
//    C4, C4_SHARP, D4, D4_SHARP, E4, F4, F4_SHARP, G4, G4_SHARP, A4, A4_SHARP, B4, 
//    C5, C5_SHARP, D5, D5_SHARP, E5, F5, F5_SHARP, G5, G5_SHARP, A5, A5_SHARP, B5, 
//    C6, C6_SHARP, D6, D6_SHARP, E6, F6, F6_SHARP, G6, G6_SHARP, A6, A6_SHARP, B6, 
//    C7, C7_SHARP, D7, D7_SHARP, E7, F7, F7_SHARP, G7, G7_SHARP, A7, A7_SHARP, B7, 
//    C8, C8_SHARP, D8, 
//    PAUSE, END_OF_SCORE, 
//    NUMBER_OF_NOTES
//};

//parameter
//const unsigned char PR2_parameter[NUMBER_OF_NOTES] = {
//    252, 
//    238, 224, 212, 200, 189, 178, 168, 158, 149, 141, 133, 126, 
//    118, 112, 105, 99, 94, 88, 83, 79, 74, 70, 66, 62, 
//    59, 55, 52, 49, 46, 44, 41, 39, 37, 35, 33, 31, 
//    29, 27, 26, 24, 23, 21, 20, 19, 18, 17, 16, 15, 
//    14, 13, 12, 
//    0, 0
//};

void UART_Initialize() {
           
    /*       TODObasic   
           Serial Setting      
        1.   Setting Baud rate
        2.   choose sync/async mode 
        3.   enable Serial port (configures RX/DT and TX/CK pins as serial port pins)
        3.5  enable Tx, Rx Interrupt(optional)
        4.   Enable Tx & RX
   */        
    TRISCbits.TRISC6 = 1;            
    TRISCbits.TRISC7 = 1;            
    
    //  Setting baud rate
    TXSTAbits.SYNC = 0;           
    BAUDCONbits.BRG16 = 0;          
    TXSTAbits.BRGH = 0;
    SPBRG = 51;      
    
   //   Serial enable
    RCSTAbits.SPEN = 1;      //Enable asynchronous serial port.   (for receive)     
    PIR1bits.TXIF = 0; //Set when TXREG is empty (for transmit)
    PIR1bits.RCIF = 0; //will set when reception is complete(for receive)
    TXSTAbits.TXEN = 1;  //enable transmission        (for transmit)
    RCSTAbits.CREN = 1; //continuous receive enable bit, will be cleared when error occurred  (for receive)        
    PIE1bits.TXIE = 0;       //If interrupt is desired, set TXIE (PIE<4>)(for transmit)
    IPR1bits.TXIP = 0; //set interrup priority(for transmit)            
    PIE1bits.RCIE = 1;//If interrupt is desired, set RCIE (for reciever)              
    IPR1bits.RCIP = 0;    //set interrup priority (for recieve)
            
    }

void UART_Write(unsigned char data)  // Output on Terminal
{
    while(!TXSTAbits.TRMT);
    TXREG = data;              //write to TXREG will send data 
}


void UART_Write_Text(char* text) { // Output on Terminal, limit:10 chars
    for(int i=0;text[i]!='\0';i++)
        UART_Write(text[i]);
}

void ClearBuffer(){
    for(int i = 0; i < 10 ; i++)
        mystring[i] = '\0';
    lenStr = 0;
}

//void play_note(unsigned char keyboard){
//    switch(keyboard){
//        case 'q': PR2 = PR2_parameter[C4];break;
//        case 'w': PR2 = PR2_parameter[C4_SHARP];break;
//        case 'e': PR2 = PR2_parameter[D4];break;
//        case 'r': PR2 = PR2_parameter[D4_SHARP];break;
//        case 't': PR2 = PR2_parameter[E4];break;
//        case 'y': PR2 = PR2_parameter[F4];break;
//        case 'u': PR2 = PR2_parameter[F4_SHARP];break;
//        case 'i': PR2 = PR2_parameter[G4];break;
//        case 'o': PR2 = PR2_parameter[G4_SHARP];break;
//        case 'p': PR2 = PR2_parameter[A4];break;
//        case '[': PR2 = PR2_parameter[A4_SHARP];break;
//        case ']': PR2 = PR2_parameter[B4];break;
//        //move left case 37:
//        //move right case 39:    
//    }
//}
char *input;
char before;
int num=0;
void MyusartRead()
{
    /* TODObasic: try to use UART_Write to finish this function */
    char text = RCREG;
    //strcat(input,text);

    if(text =='\r'){
        UART_Write(text);
        text = '\n';
    }
    
    //play_note(text);
    UART_Write(text);
    return ;
}

char *GetString(){
    //return mystring;
    return input;
}


// void interrupt low_priority Lo_ISR(void)
void __interrupt(low_priority)  Lo_ISR(void)
{
    if(RCIF)
    {
        if(RCSTAbits.OERR)
        {
            CREN = 0;
            Nop();
            CREN = 1;
        }
        
        MyusartRead();
    }
    RCIF = 0;
   // process other interrupt sources here, if required
    return;
}