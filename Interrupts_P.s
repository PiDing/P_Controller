#include <xc.inc>
    
global Data_Interrupts, TMR0_Init, Determine_Interrupts
    
EXTRN	data_count_H, write_data, Cycle
    
psect	intrpt_code, class=CODE

    
TMR0_Init:
	movlw	11000111B
	movwf	T0CON
	bsf	TMR0IE
	bsf	GIE
	return
Determine_Interrupts:
	goto	Data_Interrupts
Data_Interrupts:
	;bcf	TRISC, 2	
	;btfss	LATC, 2
	;bra	setc2
	;bcf	LATC, 2
	;bra	donec2
;setc2:	
	;bsf	LATC, 2
;donec2:
    	btfss	TMR0IF
	goto	Ultrasonic_Interrupts
	movlw	0x0A
	cpfseq	data_count_H
	call	write_data
	bcf	TMR0IF
	retfie	f
	
Ultrasonic_Interrupts:
;btfss TMR1IF
   ;retfie f
   bcf	TMR1IF
   incf Cycle, F
   movlw 0xA0 
   cpfseq Cycle
   retfie f
   clrf Cycle
   btfss PORTC, 2
   bra PULSE_1
   goto	Waiting_2
   

Waiting_2:
   bsf	LATD,  7
   bcf	LATJ,  7
   bcf	LATG,  3
   movlw	0x00
   movwf	CCPR4L
   btfss	PORTD, 7
   retfie f
   bra	Waiting_2

PULSE_1:
   CLRF  LATC, A
   CLRF  TRISC, A
   CLRF  PORTC, A
   bcf TRISC, 2
   bsf	 PORTC, 2 
   NOP
   NOP
   CLRF LATC, A
   CLRF TRISC, A
   CLRF PORTC, A
   BSF TRISC, 2 
   retfie f

	



