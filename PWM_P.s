#include <xc.inc>
GLOBAL	PWM_Init  

psect pwmCode, class = CODE

PWM_Init:
    movlw   01110100B
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
    
    bsf	    PORTD, 3 ; standy for motor click 17
    bcf	    PORTB, 3

    movlw	0xFF
    movwf	PR2
    
    movlw	0xF0
    movwf	CCPR4L
    
    movlw	00000110B
    movwf	T2CON
    
    movlw	00001100B
    movwf	CCP4CON
    return

END



