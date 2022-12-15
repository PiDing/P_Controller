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
	;bcf	TRISC, 2	
	;btfss	LATC, 2
	;bra	setc2
	;bcf	LATC, 2
	;bra	donec2
;setc2:	
	;bsf	LATC, 2
;donec2:
    	btfss	TMR0IF
	retfie	f
	movlw	0x0A
	cpfseq	data_count_H
	call	write_data
	bcf	TMR0IF
	retfie	f
	
	



