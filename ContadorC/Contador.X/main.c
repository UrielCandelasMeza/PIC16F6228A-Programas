/*
 * Contador de 0 a 9 con display de 7 segmentos
 * PIC16F628A
 * Botón en RA0, Display en PORTB
 */

// Bits de configuración
#pragma config FOSC = INTOSCIO  // Oscilador interno
#pragma config WDTE = OFF       // Watchdog Timer deshabilitado
#pragma config PWRTE = ON       // Power-up Timer habilitado
#pragma config MCLRE = OFF      // MCLR como I/O
#pragma config BOREN = OFF      // Brown-out Reset deshabilitado
#pragma config LVP = OFF        // Low Voltage Programming deshabilitado
#pragma config CPD = OFF        // Data EEPROM Code Protection deshabilitado
#pragma config CP = OFF         // Flash Program Memory Code Protection deshabilitado

#include <xc.h>

// Definición del reloj (4MHz por defecto en oscilador interno)
#define _XTAL_FREQ 4000000

// Tabla de decodificación para display de 7 segmentos (cátodo común)
const unsigned char display_7seg[10] = {
    0b00111111,  // 0
    0b00000110,  // 1
    0b01011011,  // 2
    0b01001111,  // 3
    0b01100110,  // 4
    0b01101101,  // 5
    0b01111101,  // 6
    0b00000111,  // 7
    0b01111111,  // 8
    0b01101111   // 9
};

// Variables globales
unsigned char contador = 0;

// Prototipos de funciones
void config_ports(void);
void retardo_antirebote(void);

void main(void) {
    // Configurar puertos
    config_ports();
    
    // Inicializar contador
    contador = 0;
    
    while(1) {
        // Mostrar el valor actual en el display
        PORTB = display_7seg[contador];
        
        // Esperar a que se presione el botón (RA0 = 0)
        while(RA0 == 1);  // Esperar mientras el botón no esté presionado
        
        // Anti-rebote al presionar
        retardo_antirebote();
        
        // Esperar a que se suelte el botón (RA0 = 1)
        while(RA0 == 0);  // Esperar mientras el botón esté presionado
        
        // Anti-rebote al soltar
        retardo_antirebote();
        
        // Incrementar el contador
        contador++;
        
        // Si llega a 10, reiniciar a 0
        if(contador >= 10) {
            contador = 0;
        }
    }
}

void config_ports(void) {
    // Deshabilitar comparadores analógicos
    CMCON = 0x07;
    
    // Configurar PORTA
    TRISA = 0b00000001;  // RA0 como entrada, resto como salidas
    
    // Configurar PORTB
    TRISB = 0b00000000;  // Todos los pines como salidas
    
    // Habilitar pull-ups internos
    nRBPU = 0;  // OPTION_REG bit 7 = 0 (pull-ups habilitados)
    
    // Limpiar puertos
    PORTA = 0;
    PORTB = 0;
}

void retardo_antirebote(void) {
    // Retardo de aproximadamente 20ms para anti-rebote
    __delay_ms(20);
}