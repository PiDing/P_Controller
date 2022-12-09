        #include <xc.inc> 
EXTRN	AARGB0, AARGB1, AARGB2, AARGB3, FXM1616U, FXD2416U, _24_BitAdd, _24_bit_sub		
EXTRN	BARGB0, BARGB1, BARGB2, BARGB3
;EXTRN	SetPoint, IR2V, SetPoint_IR_Left_H, SetPoint_IR_Left_L, SetPoint_IR_Mid_H, SetPoint_IR_Mid_L, SetPoint_IR_Right_H, SetPoint_Value_H, SetPoint_Value_L
EXTRN	ADC_Setup, ADC_Read, IR_3Sensor_Read, IR_Left_H, IR_Left_L, IR_Mid_H, IR_Mid_L, IR_Right_H, IR_Right_L, M_Value_H, M_Value_L
EXTRN	Proximity_Read, Proximity_H, Proximity_L
EXTRN	error0, error1, pidStat1, PidInitalize, PidMain, PidInterrupt, pidOut0, pidOut1, pidOut2
EXTRN	PWM_Init
EXTRN	PWM_Default, PWM_L, PWM_R, PID2PWM_Init, PID2PWM


; PIC18F87J50 Configuration Bit Settings
; CONFIG1L
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))
;psect udata_acs

psect code, abs
rst: org 0x0
goto Initialization
 
Initialization:
    call    ADC_Setup
    call    PidInitalize
    call    PWM_Init
    call    PID2PWM_Init

    
LineFollowing:
    call    IR_3Sensor_Read
    movff   IR_Left_H, 0x100
    movff   IR_Left_L, 0x101
    movff   IR_Right_H, 0x110
    movff   IR_Right_L, 0x111
    ;call    IR2V
    movff   M_Value_H, error0
    movff   M_Value_L, error1
    call    PidInterrupt
    call    PidMain
    movff   pidOut0, 0x10
    movff   pidOut1, 0x11
    movff   pidOut2, 0x12
    movff   pidStat1, 0x13
    call    PID2PWM
    bra	LineFollowing
    end rst
    