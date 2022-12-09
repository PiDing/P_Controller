#include <xc.inc>
    
EXTRN	AARGB0, AARGB1, AARGB2, AARGB3, FXM1616U, FXD2416U, _24_BitAdd, _24_bit_sub		
EXTRN	BARGB0, BARGB1, BARGB2, BARGB3, pidStat1
GLOBAL  ADC_Setup, ADC_Read, IR_Left_H, IR_Left_L, IR_Mid_H, IR_Mid_L, IR_Right_H, IR_Right_L, IR_3Sensor_Read
GLOBAL	M_Value_H, M_Value_L    
psect udata_acs
IR_Left_H:    ds 1
IR_Left_L:    ds 1
IR_Mid_H:     ds 1
IR_Mid_L:     ds 1
IR_Right_H:   ds 1
IR_Right_L:   ds 1

M_Value_H:		ds  1
M_Value_L:		ds  1
    
psect	adc_code, class=CODE
ADC_Setup:
	bsf	TRISH,	4, A
	bsf	TRISH,	5, A
	bsf	TRISH,	6, A
	bsf	TRISH,	7, A
	clrf	ANCON0
	clrf	ANCON1
	movlw   00111001B	    ; select AN0 for measurement
	movwf   ADCON0, A   ; and turn ADC on
	movlw   10000100B	    ; Select 4.096V positive reference
	movwf   ADCON1,	A   ; 0V for -ve reference and -ve input
	return

ADC_Read:
	bsf	GO	    ; Start conversion by setting GO bit in ADCON0
adc_loop:
	btfsc   GO	    ; check to see if finished
	bra	adc_loop
	return
	
IR_3Sensor_Read:
    movlw   00110001B	    ; select AN0 for measurement
    movwf   ADCON0, A  
    call    ADC_Read
    movff   ADRESH, IR_Left_H
    movff   ADRESL, IR_Left_L

    clrf    ADRESH
    clrf    ADRESL
    movlw   00111101B	    ; select AN0 for measurement
    movwf   ADCON0, A  
    call    ADC_Read
    movff   ADRESH, IR_Right_H
    movff   ADRESL, IR_Right_L
    return

    
IR2V:  ;convert two IR results to a pid input error
    movf   IR_Left_H, W
    cpfseq  IR_Right_H
    bra	    H_LR_ueq
    bra	    H_LR_eq
 
H_LR_eq:
    movf    IR_Left_L, W
    cpfseq  IR_Right_L
    bra	    L_LR_ueq
    bra	    L_LR_eq
    
H_LR_ueq:
    movf   IR_Left_H, W
    cpfsgt  IR_Right_H
    bra left_big
    bra right_big
   
L_LR_ueq:
    movf   IR_Left_L, W
    cpfsgt  IR_Right_L
    bra left_big
    bra right_big

L_LR_eq:
    movlw   0x00
    movwf   M_Value_H
    movlw   0x00
    movwf   M_Value_L
    bsf	   pidStat1, 0
    bsf	   0x07, 0
    return
    
    
left_big:
    movff  IR_Left_H, AARGB1
    movff  IR_Left_H, 0x00
    movff  IR_Left_L, AARGB2
    movff  IR_Left_L, 0x01
    movff  IR_Right_H, BARGB1
    movff  IR_Right_H, 0x02
    movff  IR_Right_L, BARGB2
    movff  IR_Right_L, 0x03
    call   _24_bit_sub
    movff  AARGB1, M_Value_H
    movff  AARGB1, 0x04
    movff  AARGB2, M_Value_L
    movff  AARGB2, 0x05
    bsf	   pidStat1, 2
    bsf	   0x06, 0
    clrf   AARGB0
    clrf   AARGB1
    clrf   AARGB2
    clrf   BARGB0
    clrf   BARGB1
    clrf   BARGB2
    return
    
right_big:
    movff  IR_Left_H, BARGB1
    movff  IR_Left_H, 0x00
    movff  IR_Left_L, BARGB2
    movff  IR_Left_L, 0x01
    movff  IR_Right_H, AARGB1
    movff  IR_Right_H, 0x02
    movff  IR_Right_L, AARGB2
    movff  IR_Right_L, 0x03
    call   _24_bit_sub
    movff  AARGB1, M_Value_H
    movff  AARGB1, 0x04
    movff  AARGB2, M_Value_L
    movff  AARGB2, 0x05
    clrf   AARGB0
    clrf   AARGB1
    clrf   AARGB2
    clrf   BARGB0
    clrf   BARGB1
    clrf   BARGB2
    bcf	   pidStat1, 2
    bcf	   0x06, 0
    return
    
end

