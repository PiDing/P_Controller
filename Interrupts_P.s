#include <xc.inc>
    
global B2_Interrupts
    
EXTRN	Waiting
    
psect	intrpt_code, class=CODE

B2_Interrupts:
;    	btfss	PORTH, 3
;	bra	B2_trigger
;	bra	B2_Interrupts
	
B2_trigger:
;	bcf	INTCON	INT0IF
;	call Waiting
	


