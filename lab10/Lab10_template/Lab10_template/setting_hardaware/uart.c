#include <xc.h>
    //setting TX/RX

char mystring[20];
int lenStr = 0;

void UART_Initialize() {
           
    /*       TODObasic   
           Serial Setting      
        1.   Setting Baud rate
        2.   choose sync/async mode 
        3.   enable Serial port (configures RX/DT and TX/CK pins as serial port pins)
        3.5  enable Tx, Rx Interrupt(optional)
        4.   Enable Tx & RX
    */
    TRISCbits.TRISC6 = 1; // RC6 = TX = output         
    TRISCbits.TRISC7 = 1; // RC7 = RX = input
    
    //  Setting baud rate
    OSCCONbits.IRCF = 110; // 4MHz
    TXSTAbits.SYNC = 0; // Async mode
    BAUDCONbits.BRG16 = 0; 
    TXSTAbits.BRGH = 0;
    SPBRG = 51;      
    
   //   Serial enable
    RCSTAbits.SPEN = 1; // Serial port enable      
    PIR1bits.TXIF = 0; // Clear TX interrupt flag
    PIR1bits.RCIF = 0; // Clear RX interrupt flag
    TXSTAbits.TXEN = 1; // Enable TX
    RCSTAbits.CREN = 1;  // Enable RX
    //PIE1bits.TXIE = 1; // Enable TX interrupt   
    //IPR1bits.TXIP = 0; // Set TX interrupt as high priority interrupt
    PIE1bits.RCIE = 1; // Enable RX interrupt 
    IPR1bits.RCIP = 0; // Set RX interrupt as high priority interrupt
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

void MyusartRead()
{
    /* TODObasic: try to use UART_Write to finish this function */
    UART_Write(RCREG); // echo
    if(RCREG=='\r')
        UART_Write('\n');
    return ;
}

char *GetString(){
    return mystring;
}


// void interrupt low_priority Lo_ISR(void)
void __interrupt(low_priority)  Lo_ISR(void)
{
    if(RCIF)
    {
        if(RCSTAbits.OERR) // Overrun Error bit 這次不會用到
        {
            CREN = 0;
            Nop();
            CREN = 1;
        }
        
        MyusartRead(); 
    }
    
   // process other interrupt sources here, if required
    return;
}