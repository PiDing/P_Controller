#include <xc.inc>

EXTRN	AARGB0, AARGB1, AARGB2, AARGB3	
EXTRN	BARGB0, BARGB1, BARGB2, BARGB3
EXTRN	FXM1616U, _24_BitAdd, _24_bit_sub
GLOBAL  IR_ADC_Setup, IR_Left_H, IR_Left_L, IR_Right_H, IR_Right_L, IR_2Sensor_Read
GLOBAL	error_H, error_L, IR2Error, errorSign 

;for error sign, bit 0: 1= Pos, 0 = Neg
psect udata_acs

IR_Left_H:    		ds 1
IR_Left_L:    		ds 1
IR_Right_H:   	ds 1
IR_Right_L:  		ds 1
error_H:		ds 1
error_L:		ds 1
errorSign:		ds 1

psect	adc_code, class=CODE
IR_ADC_Setup:
	bsf	TRISH,	4, A
	bsf	TRISH,	5, A
	bsf	TRISH,	6, A
	bsf	TRISH,	7, A
	clrf	ANCON0
	clrf	ANCON1
	movlw   00111001B
	movwf   ADCON0, A   
	movlw   10000100B	   
	movwf   ADCON1,	A   
	return

IR_Read:
	bsf	GO	    ; Start conversion by setting GO bit in ADCON0
adc_loop:
	btfsc   GO	    ; check to see if finished
	bra	adc_loop
	return

IR_2Sensor_Read:
    movlw   00110001B	    ; select AN12 for measurement
    movwf   ADCON0, A  
    call    IR_Read
    movff   ADRESH, IR_Left_H
    movff   ADRESL, IR_Left_L
   
    clrf    ADRESH
    clrf    ADRESL

    movlw   00111101B	    ; select AN14 for measurement
    movwf   ADCON0, A  
    call    IR_Read
    movff   ADRESH, IR_Right_H
    movff   ADRESL, IR_Right_L
    return


IR2Error:  ;convert two IR results to error
    movf   	IR_Left_H, W
    cpfseq  	IR_Right_H
    bra	    	H_LR_ueq
    bra	    	H_LR_eq
 
H_LR_eq:
    movf    	IR_Left_L, W
    cpfseq  	IR_Right_L
    bra	    	L_LR_ueq
    bra	    	L_LR_eq
    
H_LR_ueq:
    movf   	IR_Left_H, W
    cpfsgt  	IR_Right_H
    bra 	left_big
    bra 	right_big
   
L_LR_ueq:
    movf   	IR_Left_L, W
    cpfsgt  	IR_Right_L
    bra 	left_big
    bra 	right_big

L_LR_eq:
    movlw   	0x00
    movwf   	error_H
    movlw   	0x00
    movwf   	error_L
    bsf	   	errorSign, 0
    bsf	   	0x07, 0
    return
    
    
left_big:
    movff  	IR_Left_H, AARGB1
    movff  	IR_Left_H, 0x00
    movff  	IR_Left_L, AARGB2
    movff  	IR_Left_L, 0x01
    movff  	IR_Right_H, BARGB1
    movff  	IR_Right_H, 0x02
    movff  	IR_Right_L, BARGB2
    movff  	IR_Right_L, 0x03
    call   	_24_bit_sub
    movff  	AARGB1, error_H
    movff  	AARGB1, 0x04
    movff  	AARGB2, error_L
    movff  	AARGB2, 0x05
    bsf	   	errorSign, 0
    bsf	   	0x06, 0
    clrf  	AARGB0
    clrf   	AARGB1
    clrf   	AARGB2
    clrf   	BARGB0
    clrf   	BARGB1
    clrf   	BARGB2
    return
    
right_big:
    movff 	 IR_Left_H, BARGB1
    movff  	IR_Left_H, 0x00
    movff  	IR_Left_L, BARGB2
    movff  	IR_Left_L, 0x01
    movff  	IR_Right_H, AARGB1
    movff  	IR_Right_H, 0x02
    movff 	IR_Right_L, AARGB2
    movff	IR_Right_L, 0x03
    call   	_24_bit_sub
    movff  	AARGB1, error_H
    movff 	AARGB1, 0x04
    movff  	AARGB2, error_L
    movff  	AARGB2, 0x05
    clrf   	AARGB0
    clrf   	AARGB1
    clrf   	AARGB2
    clrf   	BARGB0
    clrf   	BARGB1
    clrf   	BARGB2
    bcf	   	errorSign, 0
    bcf	   	0x06, 0
    return

END

	


