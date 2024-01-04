#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include "stdio.h"
#include "string.h"
// using namespace std;
#define _XTAL_FREQ 1000000

char str[20];
void Mode1(){   // Todo : Mode1 
    return ;
}
void Mode2(){   // Todo : Mode2 
    return ;
}
void main(void) 
{
    
    SYSTEM_Initialize() ;
    TRISD = 0x00;
    LATD = 0;
    INTCONbits.PEIE = 1;
    INTCONbits.INT0IF = 0;
    INTCONbits.INT0IE = 1;
    INTCONbits.GIE = 1;
    

////    
////    // CCP1/RC2 -> Output
    TRISC = 0;
    LATC = 0;
    ADC_Read(7);

//    
    //setting portB
//    ADCON1 = 0x0f;
//    PORTB = 0;
//    TRISBbits.RB0 = 1;
    UART_Write_Text("\033c");
    char *input;
    while(1) {
//             strcpy(input, GetString());
//            for(int i=0;i<strlen(input)-5;i++){
//                if(strncmp(input[i],'motor',5)==0){
//                    UART_Write_Text("\033c");
//                    UART_Write_Text('motor mode');
//                    break;
//                }
//             }
//        strcpy(str, GetString()); // TODO : GetString() in uart.c
//        if(str[0]=='m' && str[1]=='1'){ // Mode1
//            Mode1();
//            ClearBuffer();
//        }
//        else if(str[0]=='m' && str[1]=='2'){ // Mode2
//            Mode2();
//            ClearBuffer();  
//        }
    }
    return;
}
//int num =0;
void __interrupt(high_priority) Hi_ISR(void)
{
    int value = ADRESH;
    value = value << 8;
    value += ADRESL;
    if(value<85){
        CCPR1L = 0x23;//(40)(0x23=35)
    }
    else if(85<=value&&value<170){
        CCPR1L = 0x32;//(50)
    }
    else if(170<=value&&value<255){
        CCPR1L = 0x3C;//(60)
    }
    else if(255<=value&&value<340){
        CCPR1L = 0x46;//(70)
    }
    else if(340<=value&&value<425){
        CCPR1L = 0x50;//(80)
    }
    else if(425<=value&&value<510){
        CCPR1L = 0x5A;//(90)
    }
    else if(510<=value&&value<595){
        CCPR1L = 0x64;//(100)
    }
    else if(595<=value&&value<680){
        CCPR1L = 0x6E;//(110)
    }
    else if(680<=value&&value<765){
        CCPR1L = 0x78;//(120)
    }
    else if(765<=value&&value<850){
        CCPR1L = 0x82;//(130)
    }
    else if(850<=value&&value<935){
        CCPR1L = 0x8C;//(140)
    }
    else{
        CCPR1L = 0x9B;//(155)
    }
//    else if(935<=value&&value<1024){
//        CCPR1L = 0x96;//(150)
//    }
   // CCPR1L = value*145/1024;
//    char num[4];
//    sprintf(num,"%d",value);
//    UART_Write_Text("\033c");
//    UART_Write_Text(num);
    //UART_Write(ADRESL);
//    value = value >>6;
//    switch(value){
//        case 0: {LATC = 0x00; break;}
//        case 1: {LATC = 0x10; break;}
//        case 2: {LATC = 0x20; break;}
//        case 3: {LATC = 0x30; break;}
//        case 4: {LATC = 0x40; break;}
//        case 5: {LATC = 0x50; break;}
//        case 6: {LATC = 0x60; break;}
//        case 7: {LATC = 0x70; break;}
//        case 8: {LATC = 0x80; break;}
//        case 9: {LATC = 0x90; break;}
//        case 10: {LATC = 0xA0; break;}
//        case 11: {LATC = 0xB0; break;}
//        case 12: {LATC = 0xC0; break;}
//        case 13: {LATC = 0xD0; break;}
//        case 14: {LATC = 0xE0; break;}
//        case 15: {LATC = 0xF0; break;}      
//       // default :{LATC = 0xFF;break;}
//    }
    
    //do things
    
    
    //clear flag bit
    PIR1bits.ADIF = 0;
    
    
    //step5 & go back step3
     __delay_ms(500);
    /*
    delay at least 2tad
    
    */
    ADCON0bits.GO = 1;
    return;
//    __delay_ms(500);
//    
//    if(INTCONbits.INT0IF == 1){
//        num++;
//        num=num%16;
//        char str[2];
//        sprintf(str,"%d",num);
//        UART_Write_Text("\033c");
//        UART_Write_Text(str);
//        switch(num){
//        case 0: {LATD = 0x00; break;}
//        case 1: {LATD = 0x10; break;}
//        case 2: {LATD = 0x20; break;}
//        case 3: {LATD = 0x30; break;}
//        case 4: {LATD = 0x40; break;}
//        case 5: {LATD = 0x50; break;}
//        case 6: {LATD = 0x60; break;}
//        case 7: {LATD = 0x70; break;}
//        case 8: {LATD = 0x80; break;}
//        case 9: {LATD = 0x90; break;}
//        case 10: {LATD = 0xA0; break;}
//        case 11: {LATD = 0xB0; break;}
//        case 12: {LATD = 0xC0; break;}
//        case 13: {LATD = 0xD0; break;}
//        case 14: {LATD = 0xE0; break;}
//        case 15: {LATD = 0xF0; break;}      
//       // default :{LATC = 0xFF;break;}
//        }
//        __delay_ms(500);
//    }
//      INTCONbits.INT0IF = 0;
//    return;
}