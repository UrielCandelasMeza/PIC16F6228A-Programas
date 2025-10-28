#include <xc.h>

#pragma config FOSC = INTOSCIO  // Oscilador interno
#pragma config WDTE = OFF       // Watchdog Timer deshabilitado
#pragma config PWRTE = ON       // Power-up Timer habilitado
#pragma config MCLRE = OFF      // MCLR como I/O
#pragma config BOREN = OFF      // Brown-out Reset deshabilitado
#pragma config LVP = OFF        // Low Voltage Programming deshabilitado
#pragma config CPD = OFF        // Data EEPROM Code Protection deshabilitado
#pragma config CP = OFF         // Flash Program Memory Code Protection deshabilitado             

#define _XTAL_FREQ 4000000

void main(void) {
    
    CMCON = 0x07;
    TRISB = 0b00000000;  // Todos los pines como salidas
    PORTB = 0;

    while(1) {
        // LUZ VERDE
        PORTB = 0b00000001;   
        __delay_ms(10000);  

        // LUZ AMARILLA
        PORTB = 0b00000010;
        __delay_ms(3000);   

        //LUZ ROJA
        PORTB = 0b00000100;
        __delay_ms(10000);  
    }
}