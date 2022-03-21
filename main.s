#include <xc.inc>
  
;global	targ_HI, targ_LO
    
extrn	UART_Setup, UART_Transmit_Message  ; external uart subroutines
extrn	LCD_Setup, LCD_Write_Message, LCD_Write_Hex, LCD_Clear, LCD_delay_ms ; external LCD subroutines
extrn	ADC_Setup, ADC_Read		   ; external ADC subroutines
extrn	ADC_Interrupt_Service, Enable_Interrupt	
extrn	Keypad_Setup, Keypad_Num_Decode, Keypad_A_Decode
    
   
extrn sixteen_sub, twobyte_negative
extrn Q2_LO, Q1_LO, Q2_HI, Q1_HI, invert_HI, invert_LO
    

    
psect	udata_acs   ; reserve data space in access ram

decoded_value:	ds 1
test:		ds 1
temp:		ds 1
temp_HI:	ds 1
temp_LO:	ds 1
counter:	ds 1  
    
first_loc:	ds 4	; this MUST be the last memory location to be defined
    
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
;	call	Values_Loading
	movlw	0x00
	movwf	TRISD, A
	movlw	0x00
	movwf	TRISJ, A
	movlw	0x00
	movwf	TRISC, A
	goto	targetInput
		
	
    
	return 
	
inputDigitsLoop:
	call	Keypad_Num_Decode
	movwf	decoded_value, A
	movlw	0xFF
	subwf	decoded_value, 0, 0
	bz	inputDigitsLoop	; if null, loop again
	
	; if not zero, user made input
		
	; if input D, finsihed entering, branch back 
	movlw	0xD
	subwf	decoded_value, 0, 0 
	bz	combineInput 
	
	; else a numerical digit has been entered
	movff	decoded_value, POSTINC0 ;store, increment
	movf	counter, W, A
	incf	counter, A ; increment the counter 
	movf	counter, W, A
	movf	decoded_value, 0, 0 ; move decoded val to W to write it
	call	LCD_Write_Hex ; write to LCD 
	movlw	0xFFFF
	call	LCD_delay_ms
	
	bra	inputDigitsLoop
	
targetInput:	
	lfsr	0, first_loc ; set up inrecementation
	movlw	0
	movwf	counter, A
	call	inputDigitsLoop		
		
combineInput:	
    	; To remove
	call LCD_Clear
	lfsr 0, first_loc
combineInput_loop:
	movf POSTINC0, W, A
	call LCD_Write_Hex
	movf	counter, W, A
	decfsz counter, A
	
	bra combineInput_loop
    
	; TO DO
	; TODO: CONVERT TO ADC 
	
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
    
	;call sixteen_SUB
	
	
	movlw	0000B		; TO REMOVE    
	movwf	Q1_LO, A	; TO REMOVE
	
	
	movff Q1_HI, PORTD ; temp/check	    
	movff Q1_LO, PORTJ ; temp/check
	
	
	;call  twobyte_negative
	
	
;	movff invert_HI, PORTD ; temp/check	    
;	movff invert_LO, PORTJ ; temp/check
	
	
	
	; hardcoding in target for now 

	
	movlw	0x00
    	movwf	PORTD, A	; lower 
	
	movlw	0xFF
	movwf	PORTJ, A	; upper
		
	call	Enable_Interrupt
	goto	feedbackloop
	
	
feedbackloop:
	
	; check LED change flag
	    ;YES - call LED light change
	call	changeLEDs
	; is A pressed on keyboard?
	    ; disbale interrupts, branch back to targetInput
    
	bra feedbackloop
	
	
changeLEDs:
	movlw	0x1
	movwf	PORTC, A
	
	return


;movff first_loc, 
;call sixteen_multiply
;    
    
    
    
end	rst