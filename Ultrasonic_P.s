#include <XC.INC>

    global  PULSE, DELAY, BIG_DELAY, DELAY_1, DELAY_2, DELAY_3, Ultrasonic_Init, ADC, ADC_Setup
    

psect udata_acs

TIMEREAD: ds  1
ultrasonic_H: ds   1
ultrasonic_L: ds   1
  
PSECT  ultrasonic_code, ABS
  
PULSE:  
   CLRF  LATC, A
   CLRF  TRISC, A
   CLRF  PORTC, A
   bsf	 PORTC, 2
   CALL DELAY
;     BRA INIT
      
DELAY:
   DECFSZ 0X3C, A
   BRA DELAY
   RETURN
   
Ultrasonic_ADC_Setup:
    CLRF LATC
    CLRF TRISC
    CLRF PORTC
    bcf PORTC, 2
    BSF TRISC, 2 ; use pin A0(==AN0) for input
   


Ultrasonic_Init:
   CLRF TMR1
   MOVLW 01000001B
   MOVWF T1CON, A
   movlw 00000100B
   movwf ECCP1
   return
   


READ:
MOVLW 0X44
CPFSLT TMR1_H
BRA BIG_DELAY
movlw
MOVFF TMR1_L, ultrasonic_L
movff TMR_H, ultrasonic_H
BRA INTERRUPT

INTERRUPT:
   MOVLW 0X02
   CPFSLT TIMEREAD_H
   BRA STOP
   BRA BIG_DELAY
BIG_DELAY:
   movlw 0X00
   movwf T1CON
   movwf ECCP1
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


