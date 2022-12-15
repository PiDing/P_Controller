#include <xc.inc>
    
global Data_Interrupts, TMR0_Init
    
EXTRN	data_count_H, write_data
    
psect	intrpt_code, class=CODE

    
TMR0_Init:
	movlw	11000111B
	movwf	T0CON
	bsf	TMR0IE
	bsf	GIE
	return
Data_Interrupts:
    	btfss	TMR0IF
	retfie	f
	movlw	0x04
	cpfseq	data_count_H
	call	write_data
	bcf	TMR0IF
	retfie	f
	
	



