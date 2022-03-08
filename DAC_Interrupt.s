#include <xc.inc>
	
global	ADC_Interrupt_Service, Enable_Interrupt
    
extrn	LCD_Write_Hex, LCD_Clear ; external LCD subroutines
extrn	ADC_Read		   ; external ADC subroutines    
psect	dac_code, class=CODE
	
ADC_Interrupt_Service:	
	; TO REMOVE BELOW
	btfss	TMR0IF		; check that this is timer0 interrupt
	retfie	f		; if not then return
	incf	LATJ, F, A	; increment PORTD
	
	call	LCD_Clear
	call	ADC_Read
	movf	ADRESH, W, A
	call	LCD_Write_Hex
	movf	ADRESL, W, A
	call	LCD_Write_Hex
	

	bcf	TMR0IF		; clear interrupt flag
	retfie	f		; fast return from interrupt
	
Enable_Interrupt:
	movlw	10000111B	; Set timer0 to 16-bit, Fosc/4/256
	movwf	T0CON, A	; = 62.5KHz clock rate, approx 1sec rollover
	bsf	TMR0IE		; Enable timer0 interrupt
	bsf	GIE		; Enable all interrupts
	return
	
	end

