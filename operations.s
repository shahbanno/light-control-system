#include <xc.inc>
	
    
global	sixteen_SUB
    
    
extrn	Q2_LO, Q1_LO, Q2_HI, Q1_HI, R_LO, R_HI, invert_HI, invert_LO
    
psect	udata_acs   ; reserve data space in access ram
memTest: ds 1  
    
psect	operations_code, class=CODE
    
sixteen_SUB:	;  http://www.piclist.com/techref/microchip/math/sub/16bb.htm
	movf Q2_LO, W, A
	subwf Q1_LO, A
	movf Q2_HI, W, A
	btfss STATUS, C, 0
	incfsz Q2_HI, W, A
	subwf Q1_HI, A
	
	RETURN	
	
	
	end




