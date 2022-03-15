#include <xc.inc>

extrn	UART_Setup, UART_Transmit_Message  ; external uart subroutines
extrn	LCD_Setup, LCD_Write_Message, LCD_Write_Hex, LCD_Clear, LCD_delay_ms ; external LCD subroutines
extrn	ADC_Setup, ADC_Read		   ; external ADC subroutines
extrn	ADC_Interrupt_Service, Enable_Interrupt	
extrn	Keypad_Setup, Keypad_Num_Decode, Keypad_A_Decode
    
    
psect	udata_acs   ; reserve data space in access ram

decoded_value:	ds 1
test:		ds 1
num1:		ds 1
num2:		ds 1
Q2_LO:		ds 1
Q1_LO:		ds 1
Q2_HI:		ds 1
Q1_HI:		ds 1
R_LO:		ds 1
R_HI:		ds 1
temp_HI:	ds 1
temp_LO:	ds 1
    
psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
;myArray:    ds 0x80 ; reserve 128 bytes for message data

psect	data    
	; ******* myTable, data in programme memory, and its length *****
myTable:
	db	'H','e','l','l','o',' ','W','o','r','l','d','!',0x0a
					; message, plus carriage return
	myTable_l   EQU	13	; length of data
	align	2
    
psect	code, abs	
rst: 	org 0x0
 	goto	setup
	
int_hi:	org	0x0008	; high vector, no low vector
	goto	ADC_Interrupt_Service
	
	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	LCD_Setup	
	call	ADC_Setup	; setup ADC
	call	Keypad_Setup
	call	Values_Loading
	movlw	0x00
	movwf	TRISF, A
	movlw	0x00
	movwf	TRISJ, A
	movlw	0x00
	movwf	TRISC, A
	goto	targetInput
		
	
Values_Loading:
	
    
	return 
	
inputDigitsLoop:
	call	Keypad_Num_Decode
	
	subwf	0xFF, 0, 0 
	bz	inputDigitsLoop	; if null, loop again
	
	; if not zero, user made input
	
	movwf	decoded_value,A
	

	; if input D, finsihed entering, branch back 
	subwf	0xB7, 0, 0 
	bz	combineInput
	
	; else a numerical digit has been entered
	movlw	1
	addwf	inputDigitsLoop, 1, 0
	;movff	decoded_value,			; TODO: second f is INCREMENTING IN RAM
	movf	decoded_value, 0, 0
	call	LCD_Write_Hex
	
	bra	inputDigitsLoop
	
targetInput:	
	;call	inputDigitsLoop			; TODO: uncomment
		
combineInput:	
    	
	; TO DO
	; TODO: CONVERT TO ADC 
	
	
	; EXPERIMENTING WITH =VE AND +VE NUMBERS
;	movlw	20
;	movwf	test, A
;	
;	movlw	5
;	subwf	test,0,0	    ; 20 -5 stored back in W
;	
;	movlw	5
;	movwf	test, A
;	
;	movlw	20
;	subwf	test,0,0	    ; 5-15 stored back in W
;	movwf	PORTC, A

	
	movlw	0x09
	movwf	Q2_LO, A
	
	movlw	0x05
	movwf	Q2_HI, A
	
	movlw	0x0F
	movwf	Q1_LO, A
	
	movlw	0x07
	movwf	Q1_HI, A
    
	movff Q1_HI, PORTD
	movff Q1_LO, PORTJ
    
	call sixteen_SUB
	
	movff Q1_HI, PORTD ; temp/check	    
	movff Q1_LO, PORTJ ; temp/check
	
	
	; check if negative
	
	movlw	0xFF
	xorwf	Q1_HI, 0, 0
	movwf	temp_HI, A
	
	
	movlw	0xFF
	xorwf	Q1_LO, 0, 0
	movwf	temp_LO, A
	
	
	
	movff temp_HI, PORTD ; temp/check  
	movff temp_LO, PORTJ ; temp/check
	
	
	movlw	1
	addwfc	temp_LO, 1, 0
	
	
	btfsc STATUS, C, 0
	incfsz temp_HI, W, A
	
	
	
	
	movff temp_HI, PORTD ; temp/check
	movff temp_LO, PORTJ ; temp/check
	
	
	; hardcoding in target for now 
	
	
	
	movlw	0x00
    	movwf	PORTD, A	; lower 
	
	movlw	0xFF
	movwf	PORTJ, A	; upper
		
	call	Enable_Interrupt
	goto	feedbackloop
	
sixteen_SUB:	;  http://www.piclist.com/techref/microchip/math/sub/16bb.htm
	movf Q2_LO, W, A
	subwf Q1_LO, A
	movf Q2_HI, W, A
	btfss STATUS, C, 0
	incfsz Q2_HI, W, A
	subwf Q1_HI, A
	
	RETURN

	
feedbackloop:
	
	; check LED change flag
	    ;YES - call LED light change
	call	changeLEDs
	; is A pressed on keyboard?
	    ; disbale interrupts, branch back to targetInput
    
	bra feedbackloop
   
	return
	
	
changeLEDs:
	movlw	0x1
	movwf	PORTC, A
	
	return

end	rst