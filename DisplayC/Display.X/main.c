#include <xc.h>
#define _XTAL_FREQ 4000000  // Frecuencia del oscilador

// CONFIGURACIÓN PARA PIC16F628A
#pragma config FOSC = HS
#pragma config WDTE = OFF
#pragma config PWRTE = ON
#pragma config MCLRE = OFF
#pragma config BOREN = ON
#pragma config LVP = OFF
#pragma config CPD = OFF
#pragma config CP = OFF

// Pines del LCD
#define RS RA0
#define E  RA1
#define LCD_DATA PORTB

// Prototipos
void LCD_Command(unsigned char cmd);
void LCD_Char(unsigned char data);
void LCD_Init(void);
void LCD_Clear(void);
void LCD_Set_Cursor(unsigned char row, unsigned char col);
void LCD_String(const char *text);

const unsigned char N_tilde[8] = {
    0b01110, // tilde arriba
    0b00000,
    0b10001,
    0b11001,
    0b10101,
    0b10011,
    0b10001,
    0b00000
};

// Enviar comando al LCD
void LCD_Command(unsigned char cmd) {
    RS = 0;
    LCD_DATA = cmd;
    E = 1;
    __delay_ms(2);
    E = 0;
}

// Enviar carácter al LCD
void LCD_Char(unsigned char data) {
    RS = 1;
    LCD_DATA = data;
    E = 1;
    __delay_ms(2);
    E = 0;
}

// Inicializar LCD en modo 8 bits
void LCD_Init(void) {
    TRISA = 0x00;
    TRISB = 0x00;
    PORTA = 0x00;
    PORTB = 0x00;

    __delay_ms(20);
    LCD_Command(0x38); // 8 bits, 2 líneas, 5x8
    LCD_Command(0x0C); // Display ON, cursor OFF
    LCD_Command(0x06); // Incrementar cursor
    LCD_Command(0x01); // Limpiar pantalla
    __delay_ms(2);
}

// Posicionar cursor
void LCD_Set_Cursor(unsigned char row, unsigned char col) {
    unsigned char pos;
    if (row == 1) pos = 0x80 + (col - 1);
    else pos = 0xC0 + (col - 1);
    LCD_Command(pos);
}

// Limpiar pantalla
void LCD_Clear(void) {
    LCD_Command(0x01);
    __delay_ms(2);
}

// Mostrar texto carácter por carácter
void LCD_String(const char *text) {
    while (*text) {
        LCD_Char(*text++);
        __delay_ms(500); // Velocidad del efecto de escritura
    }
}

void LCD_CreateChar(unsigned char location, const unsigned char *pattern) {
    unsigned char i;
    if (location < 8) {
        LCD_Command(0x40 + (location * 8)); // Dirección base en CGRAM
        for (i = 0; i < 8; i++) {
            LCD_Char(pattern[i]);
        }
    }
    LCD_Command(0x80); // Volver a DDRAM
}


// Programa principal
void main(void) {
    LCD_Init();
    LCD_CreateChar(0, N_tilde); // Guarda la Ñ en la posición 0 de CGRAM

    while (1) {
        LCD_Set_Cursor(1, 1);
        LCD_String("DESPIERTA SE");
        LCD_Char(0);  // Muestra la Ñ personalizada
        LCD_String("OR");

        LCD_Set_Cursor(2, 1);
        LCD_String("ALEX!");
        __delay_ms(3000);
        LCD_Clear();
    };
}
