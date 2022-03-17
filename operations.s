#include <xc.inc>
	
    
global	sixteen_SUB, twobyte_negative
    
    
global	invert_HI, invert_LO
    
extrn	Q2_LO, Q1_LO, Q2_HI, Q1_HI
psect	udata_acs   ; reserve data space in access ram

invert_HI:	ds 1
invert_LO:	ds 1
    
psect	operations_code, class=CODE
    
sixteen_SUB:	;  http://www.piclist.com/techref/microchip/math/sub/16bb.htm
	movf Q2_LO, W, A
	subwf Q1_LO, A
	movf Q2_HI, W, A
	btfss STATUS, C, 0
	incfsz Q2_HI, W, A
	subwf Q1_HI, A
	
	RETURN	
	
	
twobyte_negative:
	; makes Q1_HI;Q1_LO negative and stores in invert_HI;invert_LO
	
	; check if negative
	movlw	0xFF
	xorwf	Q1_HI, 0, 0
	movwf	invert_HI, A
	
	movlw	0xFF
	xorwf	Q1_LO, 0, 0
	movwf	invert_LO, A
	
;	movff invert_HI, PORTD ; temp/check  
;	movff invert_LO, PORTJ ; temp/check
	
	movlw	0xFF
	subwf	invert_LO, 0, 0
	bz	carry
	
	return 
	
carry:	movlw	0xFE
	movwf	invert_LO, A
	
	movlw	1
	addwf	invert_HI, 1, 0
	
	return 
	
	
	end




