#include <XC.INC>

  global  Ultrasonic_Init, Cycle, PULSE
    

psect udata_acs

ultrasonic_H: ds   1
ultrasonic_L: ds   1
Cycle: ds    1
    
PSECT  ultrasonic_code, class = CODE
    
  
PULSE:  
   CLRF  LATC, A
   CLRF  TRISC, A
   CLRF  PORTC, A
   bsf	 PORTC, 2 
   CLRF LATC, A
   CLRF TRISC, A
   CLRF PORTC, A
   NOP
   NOP
   BSF TRISC, 2 
   return
      

Ultrasonic_Init:
  
   CLRF TMR1, A
   clrf Cycle, A
   MOVLW 01111001B
   MOVWF T1CON, A
   movlw 00000001B
   movwf PIR1
   return
   
   



