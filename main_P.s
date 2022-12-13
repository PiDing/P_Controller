#include <xc.inc>

EXTRN	AARGB0, AARGB1, AARGB2, AARGB3		
EXTRN	BARGB0, BARGB1, BARGB2, BARGB3
EXTRN	FXM1616U,  _24_BitAdd, _24_bit_sub, Math_Init
EXTRN  	IR_ADC_Setup, IR_Left_H, IR_Left_L, IR_Right_H, IR_Right_L, IR_2Sensor_Read
EXTRN	error_H, error_L, IR2Error, errorSign 
EXTRN	PWM_Default, PWM_L, PWM_R, Error2PWM_Init, Error2PWM, PWM_Init, temp_pwm
EXTRN	B2_Interrupts
    
global	Waiting

; PIC18F87J50 Configuration Bit Settings
; CONFIG1L
  CONFIG  XINST = OFF 

psect code, abs
rst: org 0x0
goto Start

int_hi: org 0x0008
	goto	B2_Interrupts
	
 
Start:
    	bsf	TRISD, 7
	bsf	TRISH, 3
	clrf	LATD
	clrf	LATH
	;movlw	00010000B
	;movwf	INTCON
	goto	Waiting
	
Waiting:
	btfss	PORTD, 7
	goto	Initialization
	bra	Waiting
    
 
Initialization:	
	call	IR_ADC_Setup
	call	Error2PWM_Init
	call	PWM_Init
	call	Math_Init
	goto	LineFollowing

	
LineFollowing:
	call		IR_2Sensor_Read
	call		IR2Error
	call		Error2PWM
	movff		PWM_L, CCPR4L;
	movff		PWM_R, CCPR5L;
	bra		LineFollowing    
	
end rst    


