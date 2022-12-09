        #include <xc.inc> 
EXTRN	AARGB0, AARGB1, AARGB2, AARGB3, FXM1616U, FXD2416U, _24_BitAdd, _24_bit_sub		
EXTRN	BARGB0, BARGB1, BARGB2, BARGB3
EXTRN	pidStat1,pidOut0, pidOut1, pidOut2
GLOBAL	PWM_Default, PWM_L, PWM_R, PID2PWM_Init, PID2PWM

; PIC18F87J50 Configuration Bit Settings
; CONFIG1L
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))
;psect udata_acs
psect udata_acs
PWM_Default:    ds 1
PWM_L:		  ds 1
PWM_R:		  ds 1
temp_pid1:	  ds 1
temp_pid2:	  ds 1
temp_pwm:	  ds 1

psect pid2pwm_code, class = CODE

 PID2PWM_Init:
    movlw   0x50
    movwf   PWM_Default
    clrf    PWM_L
    clrf    PWM_R
    clrf    temp_pid1
    clrf    temp_pid2
    return
 
 PID2PWM:
    movff   pidOut1, temp_pid1
    movff   pidOut2, temp_pid2
    movlw   0x10
    mulwf   temp_pid1
    movff   PRODL, temp_pwm
    rrncf   temp_pid2
    rrncf   temp_pid2
    rrncf   temp_pid2
    rrncf   temp_pid2
    movlw   00001111B
    andwf   temp_pid2
    movf    temp_pid2, W
    addwf   temp_pwm
    movlw   10000000B
    cpfslt  pidStat1
    bra	    turn_right
    bra	    turn_left

turn_right:
    movf    temp_pwm, W
    addwf   PWM_Default, 0, 0
    movwf   PWM_L
    movf    temp_pwm, W
    subwf   PWM_Default, 0
    movwf   PWM_R
    return
    
turn_left:
    movf    temp_pwm, W
    addwf   PWM_Default, 0, 0
    movwf   PWM_R
    movf    temp_pwm, W
    subwf   PWM_Default, 0
    movwf   PWM_L
    return 
    
 
 




