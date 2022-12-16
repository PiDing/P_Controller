#include <xc.inc>

psect udata_acs
data_count_L:	    ds 1
data_count_H:	    ds 1
;record_tmr_count:   ds 1
;temp_cnt:	    ds 1
    
GLOBAL	Datalog_Init, data_count_H, write_data
EXTRN	error_to_record		

psect datalog_Code, class = CODE
 
Datalog_Init:
    lfsr    1, 0x1FF
    movlw   0xFF
    movwf   INDF0
    movlw   0x00
    movwf   data_count_L
    movwf   data_count_H
    ;movwf   record_tmr_count
    ;movwf   temp_cnt
    lfsr    0, 0x100
    return
    
;Data_record:
 ;   incf    temp_cnt
 ;   movlw   0xFF
 ;   cpfseq  temp_cnt
 ;   return
 ;   call    inc_record_tmr_count
    
;inc_record_tmr_count:
;    incf    record_tmr_count
;    movlw   0x06
;    cpfseq  record_tmr_count
;    return
;    call write_data
    
; write_data_pre:
;    movlw   0x00
;    movwf   record_tmr_count
;    movlw   0xFF
;    cpfseq  data_count
;    call    write_data
;    return
 
 write_data:
    movff   error_to_record, POSTINC0
    movlw   0xFF
    cpfseq  data_count_L
    bra    inc_data_count_L
    clrf    data_count_L
    incf    data_count_H
    return
    
inc_data_count_L:
    incf    data_count_L
    return
    

