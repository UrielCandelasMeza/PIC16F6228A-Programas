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
; Variables
;*******************************************************************************

psect udata_shr
CONTADOR:   DS 1    ; Parámetro de tiempo para retardo
TEMP:	    DS 1
d1:         DS 1    ; Variables temporales para retardo
d2:         DS 1

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
    CLRF    PORTA
    CLRF    PORTB
    CLRF    CONTADOR
    CLRF    TEMP
    
main_loop:
    BTFSS   PORTA, 1
    GOTO    NEXT
    CLRF    CONTADOR

NEXT:
    BTFSS   PORTA, 0
    GOTO    SIG
    INCF    CONTADOR, F
ANTIREBOTE:
    BTFSC   PORTA, 0
    GOTO    ANTIREBOTE

SIG:
    MOVF    CONTADOR, W
    SUBLW   10
    BTFSC   STATUS, 2
    CLRF    CONTADOR
    MOVF    CONTADOR, W
    CALL    DECODIFICADOR
    MOVWF   PORTB
    GOTO    main_loop
    

;*******************************************************************************
; SUBRUTINA: Configuración de puertos
;*******************************************************************************

CONFIG_PORTS:
    movlw   0x07             ; Deshabilitar comparadores
    movwf   CMCON
    
    banksel TRISA
    movlw   0b00000011
    movwf   TRISA
    banksel PORTA
    clrf    PORTA
    
    banksel TRISB            ; Banco 1 para TRISB
    movlw   0x00             ; Todo PORTB como salida
    movwf   TRISB
    banksel PORTB            ; Regresar al banco 0
    clrf    PORTB            ; Apagar todos los LEDs
    return

;*******************************************************************************
; SUBRUTINA: Decodificador para el display de 7 segmentos
;*******************************************************************************


DECODIFICADOR:
    MOVWF   TEMP        ; guarda el número en TEMP

    MOVF    TEMP, W
    SUBLW   0
    BTFSC   STATUS, 2
    GOTO    DIG0
    MOVF    TEMP, W
    SUBLW   1
    BTFSC   STATUS, 2
    GOTO    DIG1
    MOVF    TEMP, W
    SUBLW   2
    BTFSC   STATUS, 2
    GOTO    DIG2
    MOVF    TEMP, W
    SUBLW   3
    BTFSC   STATUS, 2
    GOTO    DIG3
    MOVF    TEMP, W
    SUBLW   4
    BTFSC   STATUS, 2
    GOTO    DIG4
    MOVF    TEMP, W
    SUBLW   5
    BTFSC   STATUS, 2
    GOTO    DIG5
    MOVF    TEMP, W
    SUBLW   6
    BTFSC   STATUS, 2
    GOTO    DIG6
    MOVF    TEMP, W
    SUBLW   7
    BTFSC   STATUS, 2
    GOTO    DIG7
    MOVF    TEMP, W
    SUBLW   8
    BTFSC   STATUS, 2
    GOTO    DIG8
    MOVF    TEMP, W
    SUBLW   9
    BTFSC   STATUS, 2
    GOTO    DIG9
    GOTO    DIG0          ; valor fuera de rango

DIG0:   MOVLW   0b00111111  ; 0
        RETURN
DIG1:   MOVLW   0b00000110  ; 1
        RETURN
DIG2:   MOVLW   0b01011011  ; 2
        RETURN
DIG3:   MOVLW   0b01001111  ; 3
        RETURN
DIG4:   MOVLW   0b01100110  ; 4
        RETURN
DIG5:   MOVLW   0b01101101  ; 5
        RETURN
DIG6:   MOVLW   0b01111101  ; 6
        RETURN
DIG7:   MOVLW   0b00000111  ; 7
        RETURN
DIG8:   MOVLW   0b01111111  ; 8
        RETURN
DIG9:   MOVLW   0b01101111  ; 9
        RETURN




;*******************************************************************************
; Fin del programa
;*******************************************************************************

    end resetVec