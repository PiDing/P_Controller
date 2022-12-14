#include <xc.inc>

EXTRN	AARGB0, AARGB1, AARGB2, AARGB3		
EXTRN	BARGB0, BARGB1, BARGB2, BARGB3
EXTRN	FXM1616U,  _24_BitAdd, _24_bit_sub, Math_Init
EXTRN  	IR_ADC_Init, IR_Left_H, IR_Left_L, IR_Right_H, IR_Right_L, IR_2Sensor_Read
EXTRN	error_H, error_L, IR2Error, errorSign 
EXTRN	PWM_Default, PWM_L, PWM_R, Error2PWM_Init, Error2PWM, PWM_Init, temp_pwm
EXTRN	Datalog_Init, Data_record
    
global	Waiting

; PIC18F87J50 Configuration Bit Settings
; CONFIG1L
  CONFIG  XINST = OFF 


psect code, abs
rst: org 0x0
goto Start

;int_hi: org 0x0008
	;goto	B2_Interrupts
	
 
Start:
    	bsf	TRISD, 7
	bsf	TRISH, 3
	bcf	TRISJ, 7
	clrf	LATD
	clrf	LATH
	goto	Waiting
	
Waiting:
	bsf	LATD,  7
	bcf	LATJ,  7
	bcf	LATG,  3
	movlw	0x00
	movwf	CCPR4L
	btfss	PORTD, 7
	goto	Initialization
	bra	Waiting
    
 
Initialization:
	bsf	LATJ,  7
	bsf	PORTJ,  7
	call	Datalog_Init
	call	IR_ADC_Init
	call	Error2PWM_Init
	call	PWM_Init
	call	Math_Init
	goto	LineFollowing

	
LineFollowing:
    	btfss	PORTH, 3
	bra	Waiting
	call	IR_2Sensor_Read
	call	IR2Error
	call	Error2PWM
	movff	PWM_L, CCPR4L;
	;movff	PWM_R, CCPR5L;
	call	Data_record
	bra	LineFollowing    

end rst    


