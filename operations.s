#include <xc.inc>


global sixteen_sub, twobyte_negative

global Q2_LO, Q1_LO, Q2_HI, Q1_HI, invert_HI, invert_LO

psect udata_acs ; reserve data space in access ram



invert_HI: ds 1
invert_LO: ds 1
Q2_LO: ds 1
Q1_LO: ds 1
Q2_HI: ds 1
Q1_HI: ds 1



ARG1H: ds 1
ARG1L: ds 1
ARG2H: ds 1
ARG2L: ds 1
RES0: ds 1
RES1: ds 1
RES2: ds 1
RES3: ds 1

psect operations_code, class=CODE



sixteen_sub: ; http://www.piclist.com/techref/microchip/math/sub/16bb.htm
	; Q1_HI;Q1_LO - Q2_HI;Q2_LO = Q1_HI;Q1_LO
	movf Q2_LO, W, A
	subwf Q1_LO, A
	movf Q2_HI, W, A

	btfss STATUS, C, 0
	incfsz Q2_HI, W, A
	subwf Q1_HI, A
	twobyte_negative:
	; makes Q1_HI;Q1_LO negative and stores in invert_HI;invert_LO

	; check if negative
	movlw 0xFF
	xorwf Q1_HI, 0, 0
	movwf invert_HI, A

	movlw 0xFF
	xorwf Q1_LO, 0, 0
	movwf invert_LO, A

	; movff invert_HI, PORTD ; temp/check
	; movff invert_LO, PORTJ ; temp/check

	movlw 0xFF
	subwf invert_LO, 0, 0
	bz carry

	return

carry:	movlw 0xFE
	movwf invert_LO, A

	movlw 1
	addwf invert_HI, 1, 0

	return



sixteen_multiply:
	banksel ARG1L
	MOVF ARG1L, W, A
	MULWF ARG2L, A ; ARG1L * ARG2L->
	; PRODH:PRODL
	MOVFF PRODH, RES1 ;
	MOVFF PRODL, RES0 ;
	;
	MOVF ARG1H, W, A
	MULWF ARG2H, A ; ARG1H * ARG2H->
	; PRODH:PRODL
	MOVFF PRODH, RES3 ;
	MOVFF PRODL, RES2 ;
	;
	MOVF ARG1L, W, A
	MULWF ARG2H, A ; ARG1L * ARG2H->
	; PRODH:PRODL
	MOVF PRODL, W, A ;
	banksel RES1
	ADDWF RES1, F, A ; Add cross
	MOVF PRODH, W, A ; products
	ADDWFC RES2, F, A ;
	CLRF WREG, A ;
	ADDWFC RES3, F, A ;
	;
	MOVF ARG1H, W, A ;
	MULWF ARG2L, A ; ARG1H * ARG2L->
	; PRODH:PRODL
	MOVF PRODL, W, A ;
	ADDWF RES1, F, A ; Add cross
	MOVF PRODH, W, A ; products
	ADDWFC RES2, F, A ;
	CLRF WREG, A ;
	ADDWFC RES3, F, A ;
	banksel 0
	return





end