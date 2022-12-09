;This file contains the following math routines:

;24-bit addittion		
;24-bit subtraction
;16*16 	Unsigned Multiply	
		
			
#include <xc.inc>

GLOBAL	AARGB0,AARGB1,AARGB2,AARGB3		
GLOBAL	BARGB0,BARGB1,BARGB2,BARGB3
GLOBAL	TEMP,TEMPB0,TEMPB1,TEMPB2,TEMPB3
GLOBAL	_24_BitAdd, _24_bit_sub, FXM1616U, Math_Init
psect udata_acs	
 	#define	Z		STATUS, 2
	#define	C		STATUS, 0	

AARGB0:	ds 1		
AARGB1:	ds 1
AARGB2:	ds 1
AARGB3:	ds 1
BARGB0:	ds 1	
BARGB1:	ds 1
BARGB2:	ds 1
BARGB3:	ds 1
TEMP:		ds 1
TEMPB0:	ds 1
TEMPB1:	ds 1
TEMPB2:	ds 1
TEMPB3:	ds 1

psect mathCode, class = CODE

;---------------------------------------------------------------------
;		24-BIT ADDITION				
Math_Init:
	clrf	AARGB0, A
	clrf	AARGB1, A
	clrf	AARGB2, A
	clrf	BARGB0, A
	clrf	BARGB1, A
	clrf	BARGB2, A

_24_BitAdd:
	movf		BARGB2,A,W
	addwf	AARGB2,A, F
	movf		BARGB1,A, W
	btfsc	C
	incfsz		BARGB1, W
	addwf	AARGB1, A, F
	movf		BARGB0, A, W
	btfsc	C
	incfsz		BARGB0, W
	addwf	AARGB0, A, F
	return
;---------------------------------------------------------------------
;		24-BIT SUBTRACTION			
_24_bit_sub:

	movf		BARGB2, A, W
	subwf		AARGB2, F	
	movf		BARGB1, A, W
	btfss		STATUS, 0
	incfsz		BARGB1, A, W
	subwf		AARGB1, A, F
	movf		BARGB0, A, W
	btfss		STATUS, 0
	incfsz		BARGB0, A, W
	subwf		AARGB0, A, F
	return
;-------------------------------------------------------------------------
;       16x16 Bit Unsigned Fixed Point Multiply 16 x 16 -> 32

FXM1616U:
	MOVFF	AARGB1,TEMPB1	
	MOVF		AARGB1, A, W
	MULWF	BARGB1, A
	MOVFF	PRODH,AARGB2
	MOVFF	PRODL,AARGB3	
	MOVF		AARGB0,A, W
	MULWF	BARGB0, A
	MOVFF	PRODH,AARGB0
	MOVFF	PRODL,AARGB1
	MULWF	BARGB1, A
	MOVF		PRODL, A, W
	ADDWF	AARGB2, A, F
	MOVF		PRODH, A, W
	ADDWFC	AARGB1, A, F
	CLRF	WREG
	ADDWFC	AARGB0,A, F
	MOVF		TEMPB1,A, W
	MULWF	BARGB0, A
	MOVF	PRODL, A, W
	ADDWF	AARGB2, A, F
	MOVF		PRODH, A, W
	ADDWFC	AARGB1, A, F
	CLRF	WREG
	ADDWFC	AARGB0, A, F
	RETURN


