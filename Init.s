    #include <xc.inc> 
EXTRN	AARGB0, AARGB1, AARGB2, AARGB3, FXM1616U, FXD2416U, _24_BitAdd, _24_bit_sub		
EXTRN	BARGB0, BARGB1, BARGB2, BARGB3
EXTRN	PidInitalize
EXTRN	ADC_Setup, ADC_Read, IR_3Sensor_Read, IR_Left_H, IR_Left_L, IR_Mid_H, IR_Mid_L, IR_Right_H, IR_Right_L
EXTRN	Proximity_Read, Proximity_H, Proximity_L
Global	Init, SetPoint_IR_Left_H, SetPoint_IR_Left_L, SetPoint_IR_Mid_H, SetPoint_IR_Mid_L, SetPoint_IR_Right_H, SetPoint_Value_H, SetPoint_Value_L

; PIC18F87J50 Configuration Bit Settings
; CONFIG1L
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))
psect udata_acs
SetPoint_IR_Left_H:	ds  1
SetPoint_IR_Left_L:	ds  1
SetPoint_IR_Mid_H:	ds  1
SetPoint_IR_Mid_L:	ds  1
SetPoint_IR_Right_H:	ds  1
SetPoint_IR_Right_L:	ds  1
SetPoint_Value_H:	ds  1
SetPoint_Value_L:	ds  1
    
psect main_code, class = CODE
org 0x500
Init:
    call ADC_Setup
    call PidInitalize

SetPoint:
    call IR_3Sensor_Read
    movff IR_Left_H, SetPoint_IR_Left_H
    movff IR_Left_L, SetPoint_IR_Left_L
    movff IR_Mid_H, SetPoint_IR_Mid_H
    movff IR_Mid_L, SetPoint_IR_Mid_L
    movff IR_Right_H, SetPoint_IR_Right_H
    movff IR_Right_L, SetPoint_IR_Right_L
    movff  SetPoint_IR_Left_H, AARGB1
    movff  SetPoint_IR_Left_H, 0x00
    movff  SetPoint_IR_Left_L, AARGB2
    movff  SetPoint_IR_Left_L, 0x01
    movff  SetPoint_IR_Right_H, BARGB1
    movff  SetPoint_IR_Right_H, 0x02
    movff  SetPoint_IR_Right_L, BARGB2
    movff  SetPoint_IR_Right_L, 0x03
    call   _24_bit_sub
    movff  AARGB1, 0x04
    movff  AARGB1, SetPoint_Value_H
    movff  AARGB2, 0x05
    movff  AARGB2, SetPoint_Value_L
    clrf   AARGB0
    clrf   AARGB1
    clrf   AARGB2
    clrf   BARGB0
    clrf   BARGB1
    clrf   BARGB2
    return
