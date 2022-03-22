#include <xc.inc>
  
global	targ_HI, targ_LO
    
extrn	UART_Setup, UART_Transmit_Message  ; external uart subroutines
extrn	LCD_Setup, LCD_Write_Message, LCD_Write_Hex, LCD_Clear, LCD_delay_ms ; external LCD subroutines
extrn	ADC_Setup, ADC_Read		   ; external ADC subroutines
extrn	ADC_Interrupt_Service, Enable_Interrupt	
extrn	Keypad_Setup, Keypad_Num_Decode, Keypad_A_Decode
    
   
extrn sixteen_sub, twobyte_negative
extrn Q2_LO, Q1_LO, Q2_HI, Q1_HI, invert_HI, invert_LO
   
extrn	ADCchange_HI, ADCchange_LO   

    
psect	udata_acs   ; reserve data space in access ram

decoded_value:	ds 1
test:		ds 1
temp:		ds 1
temp_HI:	ds 1
temp_LO:	ds 1
counter:	ds 1  
    
    
targ_HI:	ds 1
targ_LO:	ds 1
    
one_LED_HI:	ds 1
one_LED_LO:	ds 1
    
num_LEDS_to_change: ds 1
    

    
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
	call	Values_Loading
	movlw	0x00
	movwf	TRISD, A
	movlw	0x00
	movwf	TRISJ, A
	movlw	0x00
	movwf	TRISC, A
	
	; initialise  variables
	movlw	0
	movwf	ADCchange_LO, A
	movlw	0
	movwf	ADCchange_HI, A
	movlw	0
	movwf	PORTC, A
	
	
	
	goto	targetInput
		
	
    
	return 
	
Values_Loading:
	movlw	0x0A		; TODO: REPLACE WITH ACTUAL CALIBRATION
	movwf	one_LED_LO, A
	movlw	0x00
	movwf	one_LED_HI, A
	
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
    
	; TODO: CONVERT TO ADC 
	
	
	; hardcoding in target for now TODO

	
	movlw	0x00
    	movwf	targ_HI, A	; upper 
	
	movlw	0xFF
	movwf	targ_LO, A	; lower
		


	call	Enable_Interrupt
	goto	feedbackloop
	
	
;;;;;;;;;;;;;;;;;;;;;;
feedbackloop:
	
	; if any digit in amount to change is non-zero, branch to changing LEDs 
	
	movf	ADCchange_LO, W, A
	bnz	changeLEDs
	
	movf	ADCchange_HI, W, A
	bnz	changeLEDs

keypadCheck:
	
    
	; is A pressed on keyboard?
	    ; disbale interrupts, branch back to targetInput
	bra feedbackloop
	
;;;;;;;;;;;;;;;;;;;;;;;;;
	
changeLEDs:
	movff	ADCchange_HI, temp, A
	
	movf	ADCchange_HI, W, A  ; to remove
	movf	ADCchange_LO, W, A  ; to remove
	bcf     STATUS, C, 0
	rlcf	temp, 0, 0
	btfss	STATUS, C, 0  ; if carry is 1, skip
	bra	numIsPositive 
	
	; else num is negative
	
	movff	ADCchange_HI, Q1_HI, A
	movff	ADCchange_LO, Q1_LO, A
	call	twobyte_negative   ; made number positive
	
	movff	invert_HI, ADCchange_HI, A
	movff	invert_LO, ADCchange_LO, A
	
	call	find_num_LEDS
	
	movf	num_LEDS_to_change, W, A    ; if no change needed, branch back
	bz	gobackto_feedback
	call	rotate_right
    
    
    
	
	return

rotate_right:	;off
    
	bcf     STATUS, C, 0
	rrcf	PORTC, A
	bcf     STATUS, C, 0
	decf	num_LEDS_to_change, A
	movf	num_LEDS_to_change, W, A    ; TO REMOVE

	bz	gobackto_feedback
	bra	rotate_right

	
numIsPositive:
	call	find_num_LEDS

	movf	num_LEDS_to_change, W, A ; to  remove
	    
	movf	num_LEDS_to_change, W, A  ; if no change needed, branch back
	bz	gobackto_feedback
	
	call	rotate_left
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
specialCase:	;IF PORTC IS 0, THEN SIMPLY ADD 1. THEN THE ROTATE THING SHOULD WORK 
	movlw	1
	movwf	PORTC, A
	decf	num_LEDS_to_change, A
	bra	continue_Rotate
	
rotate_left:	; on
    
	; IF PORT C IS FF, THEN DONT DO THIS
	movlw	0xFF
	subwf	PORTC, 0, 0		; CAUSE FOR CONCERNNNNNNNNN,  FF- 0 GIVES 1 IN W? 
	; TODO: output message saying max possible light?
	bz	gobackto_feedback
    
	movf	PORTC, W, A
	bz	specialCase
    
    
continue_Rotate: 
	movf	num_LEDS_to_change, W, A  
	bz	gobackto_feedback ; finished changing LEDs
    
    
rotate_Loop:
	bcf     STATUS, C, 0
	rlcf	PORTC, A
	bcf     STATUS, C, 0  ; Clear carry (as rotating, and rotate moves carry into LSB) 
	
	movlw	1
	addwf	PORTC, A
	
	decf	num_LEDS_to_change, A
	movf	num_LEDS_to_change, W	; to remove 
	movf	num_LEDS_to_change, W, A  ; TO REMOVE? 
	bz	gobackto_feedback ; finished changing LEDs
	bra	rotate_Loop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	

find_num_LEDS:
	
	movff	ADCchange_HI, Q1_HI
	movff	ADCchange_LO, Q1_LO
	movff	one_LED_HI, Q2_HI
	movff	one_LED_LO, Q2_LO
	
	
	movlw	0xFF
	movwf	num_LEDS_to_change, A
	
	movf	ADCchange_HI, W, A	    ; to remove
	movf	ADCchange_LO, W, A	    ;  to remove
loop:
	incf	num_LEDS_to_change, A
	movf	num_LEDS_to_change, W, A	    ;  to remove
	call	sixteen_sub
	
	movf	Q1_HI, W, A	    ;  to remove
	movf	Q1_LO, W, A	    ;  to remove
	rlcf	Q1_HI, 0, 0
	btfss	STATUS, C, 0
	bra	loop	    ; if number is positive
	; else num is negative
	
	return
	
gobackto_feedback:
	; reset the ADC change (needed if LEDs were serviced)
	movlw	0
	movwf	ADCchange_LO, A
	movlw	0
	movwf	ADCchange_HI, A
	
	goto	keypadCheck
    
end	rst