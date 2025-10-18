;*******************************************************************************
; SEMAFORO COMPLETO - PIC-AS
; RB0: Verde
; RB1: Amarillo  
; RB2: Rojo
;*******************************************************************************

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
; Definición de pines del semáforo
;*******************************************************************************

#define VERDE  0
#define AMARILLO 1
#define ROJO  2

;*******************************************************************************
; Variables
;*******************************************************************************

psect udata_shr
P:          DS 1    ; Parámetro de tiempo para retardo
d1:         DS 1    ; Variables temporales para retardo
d2:         DS 1
d3:         DS 1

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
    ; Verde
    movlw   (1 << VERDE)     ; Encender solo verde
    movwf   PORTB
    movlw   15               ; Tiempo verde largo
    movwf   P
    call    delay
    
    ; Amarillo
    movlw   (1 << AMARILLO)  ; Encender solo amarillo
    movwf   PORTB
    movlw   5                ; Tiempo amarillo
    movwf   P
    call    delay
    
    ; Rojo
    movlw   (1 << ROJO)      ; Encender solo rojo
    movwf   PORTB
    movlw   15               ; Tiempo rojo largo
    movwf   P
    call    delay
    
    movlw   (1 << VERDE)
    movwf   PORTB
    movwf   P
    call    delay
    
    goto    main_loop        ; Repetir ciclo

;*******************************************************************************
; SUBRUTINA: Configuración de puertos
;*******************************************************************************

CONFIG_PORTS:
    movlw   0x07             ; Deshabilitar comparadores
    movwf   CMCON
    banksel TRISB            ; Banco 1 para TRISB
    movlw   0x00             ; Todo PORTB como salida
    movwf   TRISB
    banksel PORTB            ; Regresar al banco 0
    clrf    PORTB            ; Apagar todos los LEDs
    return

;*******************************************************************************
; SUBRUTINA: DELAY - Retardo variable basado en P
;*******************************************************************************

delay:
    movf    P, W             ; Cargar parámetro P
    movwf   d1               ; Contador externo
delay_loop1:
    movlw   0xFF
    movwf   d2               ; Contador medio
delay_loop2:
    movlw   0xFF
    movwf   d3               ; Contador interno
delay_loop3:
    decfsz  d3, F            ; Decrementar d3, saltar si es cero
    goto    delay_loop3      ; Continuar loop interno
    
    decfsz  d2, F            ; Decrementar d2, saltar si es cero
    goto    delay_loop2      ; Continuar loop medio
    
    decfsz  d1, F            ; Decrementar d1, saltar si es cero
    goto    delay_loop1      ; Continuar loop externo
    
    return                   ; Retornar

;*******************************************************************************
; Fin del programa
;*******************************************************************************

    end resetVec