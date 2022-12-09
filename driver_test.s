
#include <xc.inc>
GLOBAL	motor_1_Forward,   motor_2_Forward, driver_setup
psect driverCode, class = CODE    
    
standby equ 3
IN1A equ 0
IN1B equ 3
IN2A equ 2
IN2B equ 3

driver_setup:
    movlw 0x00	; set portB to outputs 
    movwf TRISB, A

    movlw 0x00	; set portB states to low
    movwf LATB, A

    movlw 0x00	; set portB to outputs 
    movwf TRISD, A

    movlw 0x00	; set portB states to low
    movwf LATD, A

    movlw 0x00	; set portB to outputs 
    movwf TRISA, A

    movlw 0x00	; set portB states to low
    movwf LATA, A

    movlw 0x00	; set portB to outputs 
    movwf TRISG, A

    movlw 0x00	; set portB states to low
    movwf LATG, A
 
 
    bsf	LATD, standby	; set standby bit to 1
    return

motor_1_Forward:
	bsf	PORTA, IN1A
	bcf	PORTG, IN1B
	return




motor_2_Forward:
	bsf	PORTD, IN2A
	bcf	PORTB, IN2B
	return

