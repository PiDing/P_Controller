
    #include <XC.INC>

    global  PULSE, DELAY, ISR, BIG_DELAY, DELAY_1, DELAY_2, DELAY_3, Ultrasonic_Init, Compare
    extrn   ISR, ultrasonic_H, ultrasonic_L




  
PSECT  ultrasonic_code, ABS
    

 
PULSE:  
   CLRF  LATC, A
   CLRF  TRISC, A
   CLRF  PORTC, A
   bsf	 PORTC, 2
   ;CALL DELAY
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
   movlw 00000100B
   movwf ECCP1CON, A
 
Wait:
    movlw 0x44
    cpfslt TMR1H, A
    bra Wait
    bra BIG_DELAY

Compare:
   MOVLW 0X02
   CPFSLT ultrasonic_H, A
   call BIG_DELAY
   ;call Waiting
   return

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
   bra PULSE
   

    end


