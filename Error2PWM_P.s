#include <xc.inc> 

EXTRN	AARGB0, AARGB1, AARGB2, AARGB3	
EXTRN	BARGB0, BARGB1, BARGB2, BARGB3
EXTRN	FXM1616U, _24_BitAdd, _24_bit_sub	
EXTRN	errorSign, error_H, error_L
GLOBAL	PWM_Default, PWM_L, PWM_R, Error2PWM_Init, Error2PWM, temp_pwm, error_threshold_cnt_H, error_threshold_cnt_M, error_threshold_cnt_L

psect udata_acs
PWM_Default:    	  ds 1
PWM_L:		  ds 1
PWM_R:		  ds 1
temp_error_H:	  ds 1
temp_error_L:	  ds 1
temp_pwm:	  ds 1
error_threshold_cnt_L:  ds 1
error_threshold_cnt_M: ds 1
error_threshold_cnt_H:  ds 1   

psect error2pwm_code, class = CODE

 Error2PWM_Init:
    movlw   	0x7F
    movwf   	PWM_Default
    clrf    	PWM_L
    clrf    	PWM_R
    clrf    	temp_error_H
    clrf    	temp_error_L
    movlw	0x00
    movwf	error_threshold_cnt_L
    movwf	error_threshold_cnt_M
    movwf	error_threshold_cnt_H
    return
 
 Error2PWM:
    movff   	error_H, temp_error_H
    movff   	error_L, temp_error_L
    movlw   	0x10
    mulwf   	temp_error_H
    movff   	PRODL, temp_pwm
    rrncf   	temp_error_L
    rrncf   	temp_error_L
    rrncf   	temp_error_L
    rrncf   	temp_error_L
    movlw  	00001111B
    andwf   	temp_error_L
    movf    	temp_error_L, W
    addwf   	temp_pwm
    movlw	0x10
    cpfslt	temp_pwm
    call	threshold_cnt
    movlw	0x09;;0x05 is optimal for curved line
    mulwf	temp_pwm	
    movff	PRODL, temp_pwm
    movlw	0x79
    cpfslt	temp_pwm
    movwf	temp_pwm
    btfsc	errorSign, 0
    bra	    	turn_right
    bra	    	turn_left

turn_right:
    movf    	temp_pwm, W
    addwf   	PWM_Default, 0, 0
    movwf   	PWM_L
    ;movf    	temp_pwm, W
    ;subwf   	PWM_Default, 0
    ;movwf   	PWM_R
    return
    
turn_left:
    ;movf    temp_pwm, W
    ;addwf   PWM_Default, 0, 0
    ;movwf   PWM_R
    movf    temp_pwm, W
    subwf   PWM_Default, 0
    movwf   PWM_L
    return
    
threshold_cnt:
    movlw   0xFF
    cpfseq  error_threshold_cnt_L
    bra	    inc_error_threshold_cnt_L
    cpfseq  error_threshold_cnt_M
    bra	    inc_error_threshold_cnt_M
    clrf    error_threshold_cnt_M
    clrf    error_threshold_cnt_L
    incf    error_threshold_cnt_H
    return
    
inc_error_threshold_cnt_L:
    incf    error_threshold_cnt_L
    return

inc_error_threshold_cnt_M:
    clrf    error_threshold_cnt_L
    incf    error_threshold_cnt_M
    return

