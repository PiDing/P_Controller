;********************************************************
;This file contains the following math routines:

;24-bit addittion		
;24-bit subtraction
	
;16*16 	Unsigned Multiply	
							
;24/16 	Unsigned Divide			
			
        #include <xc.inc>
GLOBAL	FXM1616U, FXD2416U, _24_BitAdd, _24_bit_sub	
GLOBAL	AARGB0,AARGB1,AARGB2,AARGB3		
GLOBAL	BARGB0,BARGB1,BARGB2,BARGB3
GLOBAL	ZARGB0,ZARGB1,ZARGB2
GLOBAL	REMB0,REMB1
GLOBAL	TEMP,TEMPB0,TEMPB1,TEMPB2,TEMPB3
GLOBAL	LOOPCOUNT,AEXP,CARGB2
psect udata_acs	
 	#define	Z		STATUS, 2
	#define	C		STATUS, 0	
LSB			equ	0
MSB			equ	7
AARGB0:	ds 1		
AARGB1:	ds 1
AARGB2:	ds 1
AARGB3:	ds 1
BARGB0:	ds 1	
BARGB1:	ds 1
BARGB2:	ds 1
BARGB3:	ds 1
REMB0:		ds 1	
REMB1:		ds 1
REMB2:		ds 1
REMB3:		ds 1	
TEMP:		ds 1
TEMPB0:	ds 1
TEMPB1:	ds 1
TEMPB2:	ds 1
TEMPB3:	ds 1
ZARGB0:	ds 1
ZARGB1:	ds 1
ZARGB2:	ds 1
CARGB2:	ds 1
AEXP:	    	ds 1
LOOPCOUNT:	ds 1

psect mathCode, class = CODE
;---------------------------------------------------------------------
;		24-BIT ADDITION				
_24_BitAdd:
	GLOBAL	_24_BitAdd
	movf	BARGB2,A,W
	addwf	AARGB2,A, F
	movf	BARGB1,A, W
	btfsc	C
	incfsz	BARGB1, W
	addwf	AARGB1, A, F
	movf	BARGB0, A, W
	btfsc	C
	incfsz	BARGB0, W
	addwf	AARGB0, A, F
	return
;---------------------------------------------------------------------
;		24-BIT SUBTRACTION			
_24_bit_sub:
	GLOBAL	_24_bit_sub
	movf	BARGB2,w
	subwf	AARGB2,f	
	movf	BARGB1,w
	btfss	STATUS,0
	incfsz	BARGB1,w
	subwf	AARGB1,f
	movf	BARGB0, W
	btfss	STATUS,0
	incfsz	BARGB0, W
	subwf	AARGB0, F
	return
;-------------------------------------------------------------------------
;       16x16 Bit Unsigned Fixed Point Multiply 16 x 16 -> 32

FXM1616U:
		GLOBAL	FXM1616U
		MOVFF	AARGB1,TEMPB1	
		MOVF	AARGB1, A, W
		MULWF	BARGB1, A
		MOVFF	PRODH,AARGB2
		MOVFF	PRODL,AARGB3	
		MOVF	AARGB0,A, W
		MULWF	BARGB0, A
		MOVFF	PRODH,AARGB0
		MOVFF	PRODL,AARGB1
		MULWF	BARGB1, A
		MOVF	PRODL, A, W
		ADDWF	AARGB2, A, F
		MOVF	PRODH, A, W
		ADDWFC	AARGB1, A, F
		CLRF	WREG
		ADDWFC	AARGB0,A, F
		MOVF	TEMPB1,A, W
		MULWF	BARGB0, A
		MOVF	PRODL, A, W
		ADDWF	AARGB2, A, F
		MOVF	PRODH, A, W
		ADDWFC	AARGB1, A, F
		CLRF	WREG
		ADDWFC	AARGB0, A, F
		RETURN
;-------------------------------------------------------------------
FXD2416U:		
		GLOBAL		FXD2416U
		CLRF		REMB0, A
		CLRF		REMB1, A
		CLRF		WREG
		TSTFSZ		BARGB0, A
		GOTO		D2416BGT1
		MOVFF		BARGB1,BARGB0
		CALL		FXD2408U
		MOVFF		REMB0,REMB1
		CLRF		REMB0
		RETLW		0x00

D2416BGT1:
		CPFSEQ		AARGB0, A
		GOTO		D2416AGTB
		MOVFF		AARGB1,AARGB0
		MOVFF		AARGB2,AARGB1
		CALL		FXD1616U
		MOVFF		AARGB1,AARGB2
		MOVFF		AARGB0,AARGB1
		CLRF		AARGB0, A
		RETLW		0x00
D2416AGTB:
		MOVFF		AARGB2,AARGB3
		MOVFF		AARGB1,AARGB2
		MOVFF		AARGB0,AARGB1
		CLRF		AARGB0, A
		MOVFF		AARGB0,TEMPB0
		MOVFF		AARGB1,TEMPB1
		MOVFF		AARGB2,TEMPB2
		MOVFF		AARGB3,TEMPB3
		MOVLW		0x02			; set loop count
		MOVWF		AEXP, A
		MOVLW		0x01
		MOVWF		ZARGB0, A
		BTFSC		BARGB0,MSB, A
		GOTO		D2416UNRMOK
		CALL		DGETNRMD		; get normalization factor
		MOVWF		ZARGB0
		MULWF		BARGB1
		MOVF		BARGB0,W
		MOVFF		PRODL,BARGB1
		MOVFF		PRODH,BARGB0
		MULWF		ZARGB0
		MOVF		PRODL,W
		ADDWF		BARGB0,F
		MOVF		ZARGB0,W
		MULWF		AARGB3
		MOVFF		PRODL,TEMPB3
		MOVFF		PRODH,TEMPB2
		MULWF		AARGB1
		MOVFF		PRODL,TEMPB1
		MOVFF		PRODH,TEMPB0
		MULWF		AARGB2
		MOVF		PRODL,W
		ADDWF		TEMPB2,F
		MOVF		PRODH,W
		ADDWF		TEMPB1,F
D2416UNRMOK:
		BCF		C
		CLRF		TBLPTRH
		RLCF		BARGB0,W
		RLCF		TBLPTRH,F
		ADDLW		LOW (IBXTBL256+1)	; access reciprocal table
		MOVWF		TBLPTRL
		MOVLW		HIGH (IBXTBL256)
		ADDWFC		TBLPTRH,F
		TBLRD		*-
D2416ULOOP:
		MOVFF		TEMPB0,AARGB0
		MOVFF		TEMPB1,AARGB1
		CALL		FXD1608U2		; estimate quotient digit
		BTFSS		AARGB0,LSB
		GOTO		D2416UQTEST
		SETF		AARGB1
		MOVFF		TEMPB1,REMB0
		MOVF		BARGB0,W
		ADDWF		REMB0,F
		BTFSC		C
		GOTO		D2416UQOK
D2416UQTEST:
		MOVF		AARGB1,W		; test
		MULWF		BARGB1
		MOVF		PRODL,W
		SUBWF		TEMPB2,W
		MOVF		PRODH,W
		SUBWFB		REMB0,W
		BTFSC		C
		GOTO		D2416UQOK
		DECF		AARGB1,F
		MOVF		BARGB0,W
		ADDWF		REMB0,F
		BTFSC		C
		GOTO		D2416UQOK
		MOVF		AARGB1,W
		MULWF		BARGB1
		MOVF		PRODL,W
		SUBWF		TEMPB2,W
		MOVF		PRODH,W
		SUBWFB		REMB0,W
		BTFSS		C
		DECF		AARGB1,F
D2416UQOK:
		MOVFF		AARGB1,ZARGB1
		MOVF		AARGB1,W
		MULWF		BARGB1
		MOVF		PRODL,W
		SUBWF		TEMPB2,F
		MOVF		PRODH,W
		SUBWFB		TEMPB1,F
		MOVF		AARGB1,W
		MULWF		BARGB0
		MOVF		PRODL,W
		SUBWF		TEMPB1,F
		MOVF		PRODH,W
		SUBWFB		TEMPB0,F
		BTFSS		TEMPB0,MSB		; test
		GOTO		D2416QOK
		DECF		ZARGB1,F
		MOVF		BARGB1,W
		ADDWF		TEMPB2,F
		MOVF		BARGB0,W
		ADDWFC		TEMPB1,F
D2416QOK:
		DCFSNZ		AEXP,F			; is loop done?
		GOTO		D2416FIXREM
		MOVFF		ZARGB1,ZARGB2
		MOVFF		TEMPB1,TEMPB0
		MOVFF		TEMPB2,TEMPB1
		MOVFF		TEMPB3,TEMPB2
		GOTO		D2416ULOOP		

D2416FIXREM:
		MOVFF		TEMPB1,REMB0
		MOVFF		TEMPB2,REMB1
		MOVLW		0x01
		CPFSGT		ZARGB0
		GOTO		D2416REMOK
		RRNCF		ZARGB0,W
		MOVWF		BARGB0
		CALL		DGETNRMD
		MULWF		TEMPB2
		MOVFF		PRODH,REMB1
		MULWF		TEMPB1
		MOVF		PRODL,W
		ADDWF		REMB1,F
		MOVFF		PRODH,REMB0

D2416REMOK:
		CLRF		AARGB0
		MOVFF		ZARGB1,AARGB2
		MOVFF		ZARGB2,AARGB1
		RETLW		0x00
;----------------------------------------------------		
FXD2408U:
		MOVFF		AARGB0,TEMPB0
		MOVFF		AARGB1,TEMPB1
		MOVFF		AARGB2,TEMPB2
		CALL		FXD1608U
		MOVFF		AARGB0,TEMPB0
		MOVFF		AARGB1,TEMPB1
		MOVFF		TEMPB2,AARGB1
		MOVFF		REMB0,AARGB0
		CALL		FXD1608U
		MOVFF		AARGB1,AARGB2
		MOVFF		TEMPB1,AARGB1
		MOVFF		TEMPB0,AARGB0
		RETLW		0x00
		
;--------------------------------------------------------
FXD1608U:
		GLOBAL		FXD1608U
		MOVLW		0x01
		CPFSGT		BARGB0
		GOTO		DREMZERO8
FXD1608U1:
		GLOBAL		FXD1608U1
		BCF		C
		CLRF		TBLPTRH
		RLCF		BARGB0,W
		RLCF		TBLPTRH,F
		ADDLW		LOW (IBXTBL256+1)	; access reciprocal table
		MOVWF		TBLPTRL
		MOVLW		HIGH (IBXTBL256)
		ADDWFC		TBLPTRH,F
		TBLRD		*-
FXD1608U2:
		GLOBAL		FXD1608U2
		MOVFF		AARGB0,REMB1
		MOVFF		AARGB1,REMB0
		MOVF		TABLAT,W		; estimate quotient
		MULWF		REMB1
		MOVFF		PRODH,AARGB0
		MOVFF		PRODL,AARGB1
		TBLRD		*+
		MOVF		TABLAT,W
		MULWF		REMB0
		MOVFF		PRODH,AARGB2
		MULWF		REMB1
		MOVF		PRODL,W
		ADDWF		AARGB2,F
		MOVF		PRODH,W
		ADDWFC		AARGB1,F
		CLRF		WREG
		ADDWFC		AARGB0,F
		TBLRD		*-
		MOVF		TABLAT,W
		MULWF		REMB0
		MOVF		PRODL,W
		ADDWF		AARGB2,F
		MOVF		PRODH,W
		ADDWFC		AARGB1,F
		CLRF		WREG
		ADDWFC		AARGB0,F
		MOVF		BARGB0,W
		MULWF		AARGB1
		MOVFF		PRODL,AARGB3
		MOVFF		PRODH,AARGB2
		MULWF		AARGB0
		MOVF		PRODL,W
		ADDWF		AARGB2,F
		MOVF		AARGB3,W		; estimate remainder
		SUBWF		REMB0,F
		MOVF		AARGB2,W
		SUBWFB		REMB1,F
		BTFSS		REMB1,MSB		; test remainder
		RETLW		0x00
		DECF		AARGB1,F
		CLRF		WREG
		SUBWFB		AARGB0,F
		MOVF		BARGB0,W
		ADDWF		REMB0,F
		RETLW       0x00
        
        
;----------------------------------------------------------
FXD1616U:
		TSTFSZ		BARGB0
		GOTO		D1616B0GT0
		MOVFF		BARGB1,BARGB0
		CALL		FXD1608U
		MOVFF		REMB0,REMB1
		CLRF		REMB0
		RETLW		0x00

D1616B0GT0:
		MOVF		BARGB0,W
		SUBWF		AARGB0,W
		BTFSS		C
		GOTO		D1616QZERO
		BTFSS		Z
		GOTO		D1616AGEB
		MOVF		BARGB1,W
		SUBWF		AARGB1,W
		BTFSS		C
		GOTO		D1616QZERO
D1616AGEB:
		MOVFF		AARGB0,TEMPB0
		MOVFF		AARGB1,TEMPB1
		MOVFF		AARGB1,CARGB2
		MOVFF		AARGB0,AARGB1
		CLRF		AARGB0
		MOVFF		BARGB0,BARGB2
		MOVFF		BARGB1,BARGB3
		BTFSC		BARGB0,MSB
		GOTO		D1616UNRMOK
		MOVF		BARGB0,W
		RLNCF		WREG,F
		ADDLW		LOW (IBXTBL256+3)	; access reciprocal table
		MOVWF		TBLPTRL
		MOVLW		HIGH (IBXTBL256)
		CLRF		TBLPTRH
		ADDWFC		TBLPTRH,F
		TBLRD		*
		MOVF		TABLAT,W		; normalize
		MULWF		BARGB3
		MOVFF		PRODL,BARGB1
		MOVFF		PRODH,BARGB0
		MULWF		BARGB2
		MOVF		PRODL,W
		ADDWF		BARGB0,F
		MOVF		TABLAT,W
		MULWF		TEMPB1
		MOVFF		PRODL,CARGB2
		MOVFF		PRODH,AARGB1
		MULWF		TEMPB0
		MOVF		PRODL,W
		ADDWF		AARGB1,F
		CLRF		AARGB0
		MOVF		PRODH,W
		ADDWFC		AARGB0,F
D1616UNRMOK:
		CALL		FXD1608U1		; estimate quotient digit
		MOVF		AARGB1,W
		MULWF		BARGB1
		MOVF		PRODL,W
		SUBWF		CARGB2,W
		MOVF		PRODH,W
		SUBWFB		REMB0,W
		BTFSS		C			; test
		DECF		AARGB1,F

D1616UQOK:
		MOVF		AARGB1,W		; calculate remainder
		MULWF		BARGB3
		MOVF		PRODL,W
		SUBWF		TEMPB1,F
		MOVF		PRODH,W
		SUBWFB		TEMPB0,F
		MOVF		AARGB1,W
		MULWF		BARGB2
		MOVF		PRODL,W
		SUBWF		TEMPB0,F

;	This test does not appear to be necessary in the 16 bit case, but
;	is included here in the event that a case appears after testing.

;		BTFSS		TEMPB0,MSB		; test
;		GOTO		D1616QOK
;		DECF		AARGB1

;		MOVF		BARGB3,W
;		ADDWF		TEMPB1
;		MOVF		BARGB2,W
;		ADDWFC		TEMPB0

D1616QOK:
		MOVFF		TEMPB0,REMB0
		MOVFF		TEMPB1,REMB1
		RETLW       0x00	
;---------------------------------------------------------
DGETNRMD:
		MOVLW		0x10
		CPFSLT		BARGB0
		GOTO		DGETNRMDH
DGETNRMDL:
		BTFSC		BARGB0,3
		RETLW		0x10		
		BTFSC		BARGB0,2
		RETLW		0x20		
		BTFSC		BARGB0,1
		RETLW		0x40
		BTFSC		BARGB0,0
		RETLW		0x80
DGETNRMDH:
		BTFSC		BARGB0,6
		RETLW		0x02		
		BTFSC		BARGB0,5
		RETLW		0x04		
		BTFSC		BARGB0,4
		RETLW		0x08

;----------------------------------------------------------------------------------------------
;	Routines for the trivial cases when the quotient is zero.
;	Timing:	9,7,5	clks
;   PM: 9,7,5               DM: 8,6,4

;D3232QZERO
;		MOVFF		AARGB3,REMB3
;		CLRF		AARGB3
		
;D2424QZERO
;		MOVFF		AARGB2,REMB2
;		CLRF		AARGB2
		
D1616QZERO:
		MOVFF		AARGB1,REMB1
		CLRF		AARGB1
		MOVFF		AARGB0,REMB0
		CLRF		AARGB0
		RETLW		0x00
DREMZERO8:
		CLRF		REMB0
		RETLW		0x00

;----------------------------------------------------------------------------------------------
;	The table IBXTBL256 is used by all routines and consists of 16-bit
;	upper bound approximations to the reciprocal of BARGB0.
psect data
 org 0x500
IBXTBL256:
		GLOBAL	IBXTBL256
		db	0x0000
		db      0x0001
		db      0x8001
		db	0x5556
		db	0x4001
		db	0x3334
		db	0x2AAB
		db	0x2493
		db	0x2001
		db	0x1C72
		db	0x199A
		db	0x1746
		db	0x1556
		db	0x13B2
		db	0x124A
		db	0x1112
		db	0x1001
		db	0x0F10
		db	0x0E39
		db	0x0D7A
		db	0x0CCD
		db	0x0C31
		db	0x0BA3
		db	0x0B22
		db	0x0AAB
		db	0x0A3E
		db	0x09D9
		db	0x097C
		db	0x0925
		db	0x08D4
		db	0x0889
		db	0x0843
		db	0x0801
		db	0x07C2
		db	0x0788
		db	0x0751
		db	0x071D
		db	0x06EC
		db	0x06BD
		db	0x0691
		db	0x0667
		db	0x063F
		db	0x0619
		db	0x05F5
		db	0x05D2
		db	0x05B1
		db	0x0591
		db	0x0573
		db	0x0556
		db	0x053A
		db	0x051F
		db	0x0506
		db	0x04ED
		db	0x04D5
		db	0x04BE
		db	0x04A8
		db	0x0493
		db	0x047E
		db	0x046A
		db	0x0457
		db	0x0445
		db	0x0433
		db	0x0422
		db	0x0411
		db	0x0401
		db	0x03F1
		db	0x03E1
		db	0x03D3
		db	0x03C4
		db	0x03B6
		db	0x03A9
		db	0x039C
		db	0x038F
		db	0x0382
		db	0x0376
		db	0x036A
		db	0x035F
		db	0x0354
		db	0x0349
		db	0x033E
		db	0x0334
		db	0x032A
		db	0x0320
		db	0x0316
		db	0x030D
		db	0x0304
		db	0x02FB
		db	0x02F2
		db	0x02E9
		db	0x02E1
		db	0x02D9
		db	0x02D1
		db	0x02C9
		db	0x02C1
		db	0x02BA
		db	0x02B2
		db	0x02AB
		db	0x02A4
		db	0x029D
		db	0x0296
		db	0x0290
		db	0x0289
		db	0x0283
		db	0x027D
		db	0x0277
		db	0x0271
		db	0x026B
		db	0x0265
		db	0x025F
		db	0x025A
		db	0x0254
		db	0x024F
		db	0x024A
		db	0x0244
		db	0x023F
		db	0x023A
		db	0x0235
		db	0x0231
		db	0x022C
		db	0x0227
		db	0x0223
		db	0x021E
		db	0x021A
		db	0x0215
		db	0x0211
		db	0x020D
		db	0x0209
		db	0x0205
		db	0x0201
		db	0x01FD
		db	0x01F9
		db	0x01F5
		db	0x01F1
		db	0x01ED
		db	0x01EA
		db	0x01E6
		db	0x01E2
		db	0x01DF
		db	0x01DB
		db	0x01D8
		db	0x01D5
		db	0x01D1
		db	0x01CE
		db	0x01CB
		db	0x01C8
		db	0x01C4
		db	0x01C1
		db	0x01BE
		db	0x01BB
		db	0x01B8
		db	0x01B5
		db	0x01B3
		db	0x01B0
		db	0x01AD
		db	0x01AA
		db	0x01A7
		db	0x01A5
		db	0x01A2
		db	0x019F
		db	0x019D
		db	0x019A
		db	0x0198
		db	0x0195
		db	0x0193
		db	0x0190
		db	0x018E
		db	0x018B
		db	0x0189
		db	0x0187
		db	0x0184
		db	0x0182
		db	0x0180
		db	0x017E
		db	0x017B
		db	0x0179
		db	0x0177
		db	0x0175
		db	0x0173
		db	0x0171
		db	0x016F
		db	0x016D
		db	0x016B
		db	0x0169
		db	0x0167
		db	0x0165
		db	0x0163
		db	0x0161
		db	0x015F
		db	0x015D
		db	0x015B
		db	0x0159
		db	0x0158
		db	0x0156
		db	0x0154
		db	0x0152
		db	0x0151
		db	0x014F
		db	0x014D
		db	0x014B
		db	0x014A
		db	0x0148
		db	0x0147
		db	0x0145
		db	0x0143
		db	0x0142
		db	0x0140
		db	0x013F
		db	0x013D
		db	0x013C
		db	0x013A
		db	0x0139
		db	0x0137
		db	0x0136
		db	0x0134
		db	0x0133
		db	0x0131
		db	0x0130
		db	0x012F
		db	0x012D
		db	0x012C
		db	0x012A
		db	0x0129
		db	0x0128
		db	0x0126
		db	0x0125
		db	0x0124
		db	0x0122
		db	0x0121
		db	0x0120
		db	0x011F
		db	0x011D
		db	0x011C
		db	0x011B
		db	0x011A
		db	0x0119
		db	0x0117
		db	0x0116
		db	0x0115
		db	0x0114
		db	0x0113
		db	0x0112
		db	0x0110
		db	0x010F
		db	0x010E
		db	0x010D
		db	0x010C
		db	0x010B
		db	0x010A
		db	0x0109
		db	0x0108
		db	0x0107
		db	0x0106
		db	0x0105
		db	0x0104
		db	0x0103
		db	0x0102
		db	0x0101	
end

