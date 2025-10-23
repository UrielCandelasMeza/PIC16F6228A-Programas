#include <xc.h>
#pragma config FOSC = INTRC_NOCLKOUT 

#pragma config WDTE = OFF            

#pragma config PWRTE = ON             

#pragma config MCLRE = OFF            

#pragma config BOREN = ON           

#pragma config LVP = OFF             

#pragma config CPD = OFF              

#pragma config CP = OFF              

#define _XTAL_FREQ 4000000

void main(void) {
    TRISB = 0x00;   
    PORTB = 0x00;   

    while(1) {
        // LUZ VERDE
        PORTBbits.RB0 = 1;  
        PORTBbits.RB1 = 0; 
        PORTBbits.RB2 = 0; 
        __delay_ms(15000);  

        // LUZ AMARILLA
        PORTBbits.RB0 = 0;  
        PORTBbits.RB1 = 1;  
        PORTBbits.RB2 = 0;  
        __delay_ms(5000);   

        //LUZ ROJA
        PORTBbits.RB0 = 0;  
        PORTBbits.RB1 = 0; 
        PORTBbits.RB2 = 1;  
        __delay_ms(15000);  
    }
}
