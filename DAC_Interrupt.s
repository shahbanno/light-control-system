#include <xc.inc>
	
global	ADC_Interrupt_Service, Enable_Interrupt, Disable_Interrupt
global	ADCchange_HI, ADCchange_LO

    
extrn	LCD_Write_Hex, LCD_Clear ; external LCD subroutines
extrn	ADC_Read		   ; external ADC subroutines    
    
extrn	sixteen_sub
extrn	Q2_LO, Q1_LO, Q2_HI, Q1_HI, invert_HI, invert_LO
    
    
extrn	targ_HI, targ_LO
    
    
psect	udata_acs   ; reserve data space in access ram
ADCchange_HI:	ds 1
ADCchange_LO:	ds 1  

    
psect	dac_code, class=CODE
    
	
ADC_Interrupt_Service:	
	
	btfss	TMR0IF		; check that this is timer0 interrupt
	retfie	f		; if not then return
	incf	LATF, F, A	
	
	call	LCD_Clear
	call	ADC_Read
	movf	ADRESH, W, A
	call	LCD_Write_Hex
	movf	ADRESL, W, A
	call	LCD_Write_Hex
	
	movff	ADRESH, Q2_HI 
	movff	ADRESL, Q2_LO
	
	movff	targ_HI, Q1_HI
	movff	targ_LO, Q1_LO
	
	movf	Q1_HI, W, A	; to remove
	movf	Q1_LO, W, A ; to remove
	movf	Q2_HI, W, A ; to remove
	movf	Q2_LO, W, A ; to remove
	
	call	sixteen_sub
	
	movf	Q1_HI, W, A ; to remove
	movf	Q1_LO, W, A ; to remove
	
	movff	Q1_HI, ADCchange_HI 	    
	movff	Q1_LO, ADCchange_LO 
	
	movf	ADCchange_HI, W, A  ; to remove
	movf	ADCchange_LO, W, A  ; to remove
	

	bcf	TMR0IF		; clear interrupt flag
	retfie	f		; fast return from interrupt
	
Enable_Interrupt:

	movlw	10000111B	; Set timer0 to 16-bit, Fosc/4/256
	movwf	T0CON, A	; = 62.5KHz clock rate, approx 1sec rollover
	bsf	TMR0IE		; Enable timer0 interrupt
	bsf	GIE		; Enable all interrupts
	return

Disable_Interrupt:
	movlw	0	
	movwf	T0CON, A
	
	bcf	TMR0IE
	bcf	GIE
	return
	end

