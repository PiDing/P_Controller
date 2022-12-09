        #include <xc.inc> 

EXTRN	 ADC_Setup, ADC_Read
GLOBAL	 Proximity_Read, Proximity_H, Proximity_L
psect udata_acs
Proximity_H:    ds 1
Proximity_L:    ds 1
    
psect Proxy_code, class = CODE
Proximity_Read:
    movlw   00111101B	    ; select AN0 for measurement
    movwf   ADCON0, A  
    call    ADC_Read
    movff   ADRESH, Proximity_H
    movff   ADRESL, Proximity_L
    return