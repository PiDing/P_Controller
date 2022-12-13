#include <XC.INC>

    global  PULSE, DELAY, BIG_DELAY, DELAY_1, DELAY_2, DELAY_3, Ultrasonic_Init, ADC, ADC_Setup
    

psect udata_acs

TIMEREAD: ds  1
ultrasonic_H: ds   1
ultrasonic_L: ds   1
  
PSECT  ultrasonic_code, ABS
  
PULSE:  
   CLRF  LATE, A
   CLRF  TRISE, A
   CLRF  PORTE, A
   bsf	 PORTE, 0
   MOVWF  PORTE,F
   CALL DELAY
;     BRA INIT
      
DELAY:
   DECFSZ 0X3C, A
   BRA DELAY
   RETURN
   
Ultrasonic_ADC_Setup:
    CLRF LATE
    CLRF TRISE
    CLRF PORTE
    BSF TRISE, 0 ; use pin A0(==AN0) for input
    clrf ANCON0
    movlw 00111101B
    movwf ADCON0   ; set A15 to analog
           	   ; select AN0 for measurement
                       	    ; and turn ADC on
                            ; Select 4.096V positive reference
    movwf   ADCON1	    ; 0V for -ve reference and -ve input
    return

ADC_Read:
    bsf	    GO	    ; Start conversion
adc_loop:
    btfsc   GO	    ; check to see if finished
    bra	    adc_loop
    return


Ultrasonic_Init:
   CLRF TRISE
   CLRF LATE
   CLRF PORTE
   BSF TRISE, 0
   CLRF TMR1
   MOVLW 01110001B
   MOVWF T1CON
   return
   
ADC:
   CALL ADC_Read
   MOVFF ADREFH, ADC_H
   MOVFF ADREFH, ADC_L
   BRA READ

READ:
MOVLW 0XFE
CPFSLT TMR1
BRA BIG_DELAY
MOVLW 0X00
CPFSGT ADC_H
BRA ADC
MOVFF TMR1, TIMEREAD
BRA INTERRUPT

INTERRUPT:
   MOVLW 0X93
   CPFSLT TIMEREAD
   BRA STOP
   BRA BIG_DELAY
BIG_DELAY:
   DECFSZ 0XF0, A
   BRA BIG_DEALY
   CALL DELAY_1
   RETURN
DELAY_1:
   DECFSZ 0XF0
   BRA DELY_1
   CALL DELAY_2
   RETURN
DELAY_2:
   DECFSZ 0XF0, A
   BRA DEALY_2
   CALL DELAY_3
   RETURN
DELAY_3:
   DECFSZ 0X18, A
   BRA DELAY_3
   BRA PULSE
   

    end


