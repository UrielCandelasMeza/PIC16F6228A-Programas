PROCESSOR 16F628A
#include <xc.inc>

; CONFIG
CONFIG FOSC = INTOSCIO
CONFIG WDTE = OFF
CONFIG PWRTE = ON
CONFIG MCLRE = OFF
CONFIG BOREN = OFF
CONFIG LVP = OFF

;*******************************************************************************
; Variables
;*******************************************************************************

psect udata_shr
N:      DS  1   ; Parámetro de tiempo para retardo
M:      DS  1   ; Variables temporales para retardo
Nx:     DS  1
Mx:     DS  1
P:      DS  1

;*******************************************************************************
; Vector de reset
;*******************************************************************************

psect resetVec, class=CODE, delta=2
resetVec:
    goto    main

;*******************************************************************************
; Programa principal - Ciclo del semáforo
;*******************************************************************************

psect code, delta=2
main:
    call    CONFIG_PORTS
    
main_loop:
    
    
INICIO:
    BSF     STATUS, 5
    CLRF    TRISA           ; PORTA como salida (para RS y E)
    CLRF    TRISB           ; PORTB como salida 
    BCF     STATUS, 5
    
LCD_INICIAR:
    CALL    LCD_IN          ; Inicializa el LCD
    CALL    LCD_CREAR_N
    CALL    I               
    CALL    NEXT            
    CALL    I2              
    GOTO    LCD_INICIAR

I:
    MOVLW   'D'
    MOVWF   PORTB
    CALL    MANDAR
    MOVLW   'E'
    MOVWF   PORTB
    CALL    MANDAR
    MOVLW   'S'
    MOVWF   PORTB
    CALL    MANDAR
    MOVLW   'P'
    MOVWF   PORTB
    CALL    MANDAR
    MOVLW   'I'
    MOVWF   PORTB
    CALL    MANDAR
    MOVLW   'E'
    MOVWF   PORTB
    CALL    MANDAR
    MOVLW   'R'
    MOVWF   PORTB
    CALL    MANDAR
    MOVLW   'T'
    MOVWF   PORTB
    CALL    MANDAR
    MOVLW   'A'
    MOVWF   PORTB
    CALL    MANDAR
    MOVLW   ' '
    MOVWF   PORTB
    CALL    MANDAR
    MOVLW   'S'
    MOVWF   PORTB
    CALL    MANDAR
    MOVLW   'E'
    MOVWF   PORTB
    CALL    MANDAR
    MOVLW   0x00            
    MOVWF   PORTB
    CALL    MANDAR
    MOVLW   'O'
    MOVWF   PORTB
    CALL    MANDAR
    MOVLW   'R'
    MOVWF   PORTB
    CALL    MANDAR
    RETURN

I2:
    MOVLW   'A'
    MOVWF   PORTB
    CALL    MANDAR
    MOVLW   'L'
    MOVWF   PORTB
    CALL    MANDAR
    MOVLW   'E'
    MOVWF   PORTB
    CALL    MANDAR
    MOVLW   'X'
    MOVWF   PORTB
    CALL    MANDAR
    MOVLW   '!'             
    MOVWF   PORTB
    CALL    MANDAR
    RETURN

LCD_IN:
    BCF     PORTA, 0        ; RS=0 (Modo Comando)
    
    MOVLW   0x01            
    MOVWF   PORTB
    CALL    EJECUTA
    CALL    PAUSA           
    
    MOVLW   0x38            
    MOVWF   PORTB
    CALL    EJECUTA
    
    MOVLW   0x0C            
    MOVWF   PORTB
    CALL    EJECUTA
    
    RETURN

EJECUTA:
    BSF     PORTA,1         ; E = 1
    CALL    DELAY
    CALL    DELAY
    BCF     PORTA,1         ; E = 0
    CALL    DELAY
    RETURN

MANDAR:
    BSF     PORTA,0         ; RS = 1 (Modo Dato)
    CALL    EJECUTA
    RETURN

NEXT:
    BCF     PORTA,0         ; RS = 0 (Modo Comando)
    MOVLW   0xC0            
    MOVWF   PORTB
    CALL    EJECUTA
    RETURN

DELAY:
    MOVLW   48
    MOVWF   M
DOS:
    MOVLW   255
    MOVWF   N
UNO:
    NOP
    NOP
    DECFSZ  N, 1
    GOTO    UNO
    DECFSZ  M, 1
    GOTO DOS
    RETURN

PAUSA:
    MOVLW   5
    MOVWF   P
TRESx:
    MOVLW   8
    MOVWF   Mx
DOSx:
    MOVLW   250
    MOVWF   Nx
UNOx:
    NOP
    NOP
    DECFSZ  Nx, 1
    GOTO UNOx
    DECFSZ  Mx, 1
    GOTO DOSx
    DECFSZ  P, 1
    GOTO TRESx
    RETURN
    
    

;*******************************************************************************
; SUBRUTINA: Configuración de puertos
;*******************************************************************************

CONFIG_PORTS:
    movlw   0x07            ; Deshabilitar comparadores
    movwf   CMCON
    banksel TRISB           ; Banco 1 para TRISB
    movlw   0x00            ; Todo PORTB como salida
    movwf   TRISB
    movlw   0x00
    movwf   TRISA
    banksel PORTB           ; Regresar al banco 0
    clrf    PORTB           ; Apagar todos los LEDs
    clrf    PORTA           ; Limpiar puerto A
    return
;*******************************************************************************
; SUBRUTINA: Crear caracter 'Ñ' en CG-RAM (en la posicion 0)
;*******************************************************************************
LCD_CREAR_N:
    BCF     PORTA, 0        ; RS=0 (Modo Comando)
    MOVLW   0x40            ; Comando: Apuntar a la direccion 0 de CG-RAM
    MOVWF   PORTB
    CALL    EJECUTA         ; Ejecuta el comando

    ; Ahora enviamos los 8 bytes que definen el caracter
    ; La subrutina 'MANDAR' ya pone RS=1 (Modo Dato)
    
    ; Patron de pixeles 5x8 para la 'Ñ':
    MOVLW   0b01010        ; Fila 1 (la tilde ~)
    MOVWF   PORTB
    CALL    MANDAR
    
    MOVLW   0b00000        ; Fila 2 (espacio)
    MOVWF   PORTB
    CALL    MANDAR
    
    MOVLW   0b10001        ; Fila 3 (N)
    MOVWF   PORTB
    CALL    MANDAR
    
    MOVLW   0b11001        ; Fila 4 (N)
    MOVWF   PORTB
    CALL    MANDAR
    
    MOVLW   0b10101        ; Fila 5 (N)
    MOVWF   PORTB
    CALL    MANDAR
    
    MOVLW   0b10011        ; Fila 6 (N)
    MOVWF   PORTB
    CALL    MANDAR
    
    MOVLW   0b10001        ; Fila 7 (N)
    MOVWF   PORTB
    CALL    MANDAR
    
    MOVLW   0b00000        ; Fila 8 (espacio)
    MOVWF   PORTB
    CALL    MANDAR

    ; Regresar a modo comando y poner cursor en home
    BCF     PORTA, 0        ; RS=0
    MOVLW   0x80            ; Comando: Mover cursor a inicio
    MOVWF   PORTB
    CALL    EJECUTA
    RETURN  


;*******************************************************************************
; Fin del programa
;*******************************************************************************

    end resetVec