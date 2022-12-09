#include <xc.inc>
GLOBAL	PWM_Init  
psect pwmCode, class = CODE
 
PWM_Init:
    movlw   0x66
    movwf   OSCCON

    
    clrf    PORTA
    clrf    LATA
    clrf    TRISA
    
    clrf    PORTB
    clrf    LATB
    clrf    TRISB

    clrf    PORTG
    clrf    LATG
    clrf    TRISG

    clrf    PORTD
    clrf    LATD
    clrf    TRISD
    
    bsf	    PORTD, 3
    
    movlw   0xFF
    movwf   PR2
    
    movlw   0xA0
    movwf   CCPR4L
    
    movlw   00000100B
    movwf   T2CON
    
    movlw   00001100B
    movwf   CCP4CON
    



    return