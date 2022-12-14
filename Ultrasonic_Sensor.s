
    #include <XC.INC>

    global  PULSE, DELAY, ISR, BIG_DELAY, DELAY_1, DELAY_2, DELAY_3, Ultrasonic_Init, Waiting
    

psect udata_acs

ultrasonic_H: ds   1
ultrasonic_L: ds   1
  
PSECT  ultrasonic_code, ABS
    
  
PULSE:  
   CLRF  LATC, A
   CLRF  TRISC, A
   CLRF  PORTC, A
   bsf	 PORTC, 2
   CALL DELAY
   BRA Ultrasonic_Init
      
DELAY:
   DECFSZ 0X3C, A
   BRA DELAY
   RETURN
   
Ultrasonic_Init:
   CLRF LATC, A
   CLRF TRISC, A
   CLRF PORTC, A
   BSF TRISC, 2 
   CLRF TMR1, A
   MOVLW 01000001B
   MOVWF T1CON, A
   ;movlw 00000100B
   ;movwf CCP1CON
 
Wait:
    movlw 0x44
    cpfslt TMR1H, A
    bra BIG_DELAY

Compare:
   MOVLW 0X02
   CPFSLT ultrasonic_H, A
   BRA BIG_DELAY
   bra Waiting
   return
;BRA INTERRUPT

;INTERRUPT:
;   MOVLW 0X02
 ;  CPFSLT Ultrasonic_H
  ; BRA STOP
   ;BRA BIG_DELAY
BIG_DELAY:
   DECFSZ 0XF0, A
   BRA BIG_DELAY
   CALL DELAY_1
   RETURN
DELAY_1:
   DECFSZ 0XF0
   BRA DELAY_1
   CALL DELAY_2
   RETURN
DELAY_2:
   DECFSZ 0XF0, A
   BRA DELAY_2
   CALL DELAY_3
   RETURN
DELAY_3:
   DECFSZ 0X18, A
   BRA DELAY_3
   BRA PULSE
   

    end


