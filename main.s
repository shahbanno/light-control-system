#include <xc.inc>
  
global	targ_HI, targ_LO
    
extrn	UART_Setup, UART_Transmit_Message  ; external uart subroutines
extrn	LCD_Setup, LCD_Write_Message, LCD_Write_Hex, LCD_Clear, LCD_delay_ms ; external LCD subroutines
extrn	ADC_Setup, ADC_Read		   ; external ADC subroutines
extrn	ADC_Interrupt_Service, Enable_Interrupt	
extrn	Keypad_Setup, Keypad_Num_Decode, Keypad_A_Decode
    
   
extrn sixteen_sub, twobyte_negative, sixteen_multiply
extrn Q2_LO, Q1_LO, Q2_HI, Q1_HI, invert_HI, invert_LO
extrn ARG1H, ARG1L, ARG2H, ARG2L, RES0, RES1, RES2, RES3
   
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
    

thou_hi: ds 1
thou_lo: ds 1
hun_hi: ds 1
hun_lo: ds 1
ten: ds 1
unit: ds 1
    
    
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
	movlw 0	; initialise values
	movwf thou_hi, A
	movwf thou_lo, A
	movwf hun_hi, A
	movwf hun_lo, A
	movwf ten, A
	movwf unit, A
    
    
	lfsr	0, first_loc ; set up inrecementation
	movlw	0
	movwf	counter, A
	call	inputDigitsLoop		
		
combineInput:	
    	; THIS JUST RECALLS WHAT  WAS INPUT USING POSTINC
;	call	LCD_Clear
;	lfsr	0, first_loc
;combineInput_loop:
;	movf	POSTINC0, W, A
;	call	LCD_Write_Hex
;	movf	counter, W, A
;	decfsz	counter, A
;	
;	bra	combineInput_loop
    
	
	bra	test_size
	
	
save_input:
	movff	thou_hi, targ_HI, A	; upper 
	movff	thou_lo, targ_LO, A	; lower  
	
	movf	thou_hi, W, A ; to remove
	movf	thou_lo, W, A ; to remove
	
	movf	targ_HI, W, A ; to remove
	movf	targ_LO, W, A ; to remove
	
	
	; TODO: CONVERT TO ADC 
	
	
	; hardcoding in target 
;	movlw	0x00
;    	movwf	targ_HI, A	; upper 
;	
;	movlw	0xFF
;	movwf	targ_LO, A	; lower
	

	call	Enable_Interrupt
	goto	feedbackloop

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
test_size:
	; check the number of digits

	lfsr 0, first_loc ; reset incrementation (need this for later)

	movlw 0x4
	subwf counter, 0, 0
	bz thous

	movlw 0x3
	subwf counter, 0, 0
	bz huns

	movlw 0x2
	subwf counter, 0, 0
	bz tes

	movlw 0x1
	subwf counter, 0, 0
	bz unis

thous:
	call thousands
	call hundreds
	call tens
	call units
	call sum
	bra save_input

huns:
	call hundreds
	call tens
	call units
	call sum
	bra save_input
tes:
	call tens
	call units
	call sum
	bra save_input
unis:
	call units
	call sum
	bra save_input

thousands:
	; thousands can go up to 4095 which is 0xFFF - 12 bits
	; and 1000 = 0x3e8
	; using 16x16 multiplier and its arguments/results

	; set 1000 as arg1
	movlw 0x3
	movwf ARG1H, A
	movlw 0xe8
	movwf ARG1L, A

	; set digit as arg2L, arg2H = 0
	movlw 0
	movwf ARG2H, A
	movff POSTINC0, ARG2L, A




	call sixteen_multiply

	; get a sixteen bit result and store it in hi and lo

	movff RES1, thou_hi, A
	movff RES0, thou_lo, A
	return

hundreds:
	;hundreds can go up to 999 which is 0x3E7 - 12 bits
	; and 100 = 0x64
	; using 16x16 multiplier to do 12x8 as before

	; set 100 as ARG1L, ARG1H = 0
	movlw 0
	movwf ARG1H, A
	movlw 0x64
	movwf ARG1L, A

	; set digit as arg2L, arg2H = 0
	movlw 0
	movwf ARG2H, A
	movff POSTINC0, ARG2L, A

	call sixteen_multiply

	; get a sixteen bit result and store it in hi and lo

	movff RES1, hun_hi, A
	movff RES0, hun_lo, A
	return

tens:
	; tens can go up to 99 = 0x63 - only 8 bits
	; and 10 = 0xA
	; just use the builtin multiplier mulwf
	movlw 0xA
	mulwf POSTINC0, A
	movff PRODL, ten
	return

units:
	; units dont need to be multiplied by anything
	movff POSTINC0, unit, A
	return

sum:
	; time to add it all up
	movf ten, W, A
	addwf unit, 0, 0
	;movwf tent, A

	;movf tent, W, A
	addwf hun_lo, 1, 0
	btfsc STATUS, C, 0
	incf hun_hi, A

	movf hun_lo, W, A
	addwf thou_lo, 1, 0
	movf hun_hi, W, A
	addwfc thou_hi, 1, 0
	return
	
	
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
feedbackloop:
	
	; if any digit in amount to change is non-zero, branch to changing LEDs 
	
	movf	ADCchange_LO, W, A
	bnz	changeLEDs
	
	movf	ADCchange_HI, W, A
	bnz	changeLEDs
 
keypadCheck:
	; is A pressed on keyboard?
	    ; disbale interrupts, branch back to targetInput    
   
	    
;	    
;	call	Keypad_A_Decode
;	movwf	decoded_value, A
;	movlw	0xA
;	subwf	decoded_value, 0, 0
;	bz	targetInput	    ; TODO: consider disabling interrupt? 
    

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
	movf	num_LEDS_to_change, W, A	; to remove 
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