#include <xc.inc>
GLOBAL	PWM_Init  

psect pwmCode, class = CODE

PWM_Init:
    ;movlw   0x66
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
    bcf	    PORTA, 0                                                      ; standy for motor click 17
    bcf	    PORTD, 2
    
    
    ;set timer 3 to control timer2 and timer 4    
    movlw	01000001B
    movwf	T3CON, A
    
    ;TMR2 and CCP4CON for PWM 1
    movlw	0xFF
    movwf	PR2
    
    movlw	0xF0
    movwf	CCPR4L
    
    movlw	00000110B
    movwf	T2CON
    
    movlw	00001100B
    movwf	CCP4CON
    


    ;TMR4 and CCP5CON for PWM 2
    movlw	0xFF
    movwf	PR4

    movlw	00000110B
    movwf	T4CON
    
    movlw	0xF0
    movwf	CCPR5L

    movlw	00001100B
    movwf	CCP5CON

    return

END



