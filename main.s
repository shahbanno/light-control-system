#include <xc.inc>

extrn	UART_Setup, UART_Transmit_Message  ; external uart subroutines
extrn	LCD_Setup, LCD_Write_Message, LCD_Write_Hex, LCD_Clear, LCD_delay_ms ; external LCD subroutines
extrn	ADC_Setup, ADC_Read		   ; external ADC subroutines
extrn	DAC_Setup, DAC_Int_Hi	
    
    
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
delay_count:ds 1    ; reserve one byte for counter in the delay routine
ARG1L:    ds 1 
ARG1H:    ds 1 
ARG2L:    ds 1 
ARG2H:    ds 1 
ARG1:	  ds 1
ARG2_0:	  ds 1
ARG2_1:	  ds 1
ARG2_2:	  ds 1
ARG2_3:	  ds 1

RES0:	  ds 1
RES1:	  ds 1
RES2:	  ds 1
RES3:	  ds 1
    
RES0_2:	  ds 1
RES1_2:	  ds 1
RES2_2:	  ds 1
    
carry:	  ds 1
myNum:	  ds 1  
    
    
psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
myArray:    ds 0x80 ; reserve 128 bytes for message data


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
	goto	DAC_Int_Hi
	
	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup UART
	call	ADC_Setup	; setup ADC
	goto	measure_loop
	
	; ******* Main programme ****************************************
;start: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
;	movlw	low highword(myTable)	; address of data in PM
;	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
;	movlw	high(myTable)	; address of data in PM
;	movwf	TBLPTRH, A		; load high byte to TBLPTRH
;	movlw	low(myTable)	; address of data in PM
;	movwf	TBLPTRL, A		; load low byte to TBLPTRL
;	movlw	myTable_l	; bytes to read
;	movwf 	counter, A		; our counter register
;loop: 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
;	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
;	decfsz	counter, A		; count down to zero
;	bra	loop		; keep going until finished
;		
;	movlw	myTable_l	; output message to UART
;	lfsr	2, myArray
;	call	UART_Transmit_Message
;
;	movlw	myTable_l-1	; output message to LCD
;				; don't send the final carriage return to LCD
;	lfsr	2, myArray
;	call	LCD_Write_Message

    
measure_loop:
	call	ADC_Read
	
;	call LCD_Clear
;
;	movlw	0x2323
;	call	LCD_Write_Hex
	
	
	movf	ADRESH, W, A
	call	LCD_Write_Hex
	movf	ADRESL, W, A
	call	LCD_Write_Hex
;	
	
	call	DAC_Setup
	goto	$
	
	
;	; store reading in register
;;	banksel ARG1H
;;	movff	ADRESH, ARG1H, A
;;	movff	ADRESL, ARG1L, A
;	
;	
;	;multiplier
;	
;	banksel ARG2_0
;	movlw	0x21
;	movwf	ARG2_0, A
;	
;	banksel ARG2_1
;	movlw	0x43
;	movwf	ARG2_1, A
;	
;	banksel ARG2_2
;	movlw	0x65
;	movwf	ARG2_2, A
;	
;	banksel ARG2_3
;	movlw	0x87
;	movwf	ARG2_3, A
;	
;	; denary 17
;	banksel ARG1
;	movlw	0x11
;	movwf	ARG1, A
;	
;	
;	call	eight_twentyfour_multiply
;	
;;	testing the number 4
;	banksel ARG1H
;	movlw	0x05
;	movwf	ARG1H, A
;	movlw	0x04
;	movwf	ARG1L, A
;	
;;	
;;;	store number we're multiplying by in register 
;	banksel ARG2H
;	movlw	0x02
;	movwf	ARG2H, A
;	banksel ARG2L
;	movlw	0x03
;	movwf	ARG2L, A
;;;	
;	
;	call	write_res_LCD
;	
	movlw	10000
	call	LCD_delay_ms
	movlw	10000
	call	LCD_delay_ms
	movlw	10000
	call	LCD_delay_ms
	movlw	10000
	call	LCD_delay_ms
	movlw	10000
	call	LCD_delay_ms
;	
;	goto	measure_loop		; goto current line in code
	
	
	; write to LCD (output MSB first)
write_res_LCD:
	call	LCD_Clear
	movf	RES3, W, A
	call	LCD_Write_Hex
	movf	RES2, W, A
	call	LCD_Write_Hex
	movf	RES1, W, A
	call	LCD_Write_Hex
	movf	RES0, W, A
	call	LCD_Write_Hex
		
;	movlw	12
;	movwf	myNum, A	
;	lfsr	2, myNum
;	movlw	2
;	call	LCD_Write_Message

	return


	; a delay subroutine if you need one, times around loop in delay_count
delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return
	
	
test_new_multiplier:
	; denary 67305985
	banksel ARG2_0
	movlw	0x01
	movwf	ARG2_0, A
	
	banksel ARG2_1
	movlw	0x02
	movwf	ARG2_1, A
	
	banksel ARG2_2
	movlw	0x03
	movwf	ARG2_2, A
	
	banksel ARG2_3
	movlw	0x04
	movwf	ARG2_3, A
	
	; denary 18
	banksel ARG1
	movlw	0x12
	movwf	ARG1, A
	
	call	eight_twentyfour_multiply	; expect denary 1211507730, hex 48362412

	call	write_res_LCD
	
	return
	
	
sixteen_multiply:
	banksel	   ARG1L
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
	

	
eight_twentyfour_multiply:
	; arg1 stores 8 bit number
	; arg2 stores 24 bit
	
	banksel	   ARG1L
	MOVF ARG1, W, A
	MULWF ARG2_0, A ; ARG1L * ARG2L->
	; PRODH:PRODL
	MOVFF PRODH, RES1 ;
	MOVFF PRODL, RES0 ;
	
	MOVF ARG1, W, A
	MULWF ARG2_1, A ; ARG1L * ARG2H->
	; PRODH:PRODL
	MOVF PRODL, W, A ;
	banksel RES1
	ADDWFC RES1, F, A ; Add cross
	MOVF PRODH, W, A ; products
	ADDWFC RES2, F, A ;
	CLRF WREG, A ;
	ADDWFC RES3, F, A ;
	;
	
	
	banksel	   ARG1
	MOVF ARG1, W, A
	MULWF ARG2_2, A ; ARG1L * ARG2L->
	; PRODH:PRODL
	MOVFF PRODH, RES1_2 ;
	MOVFF PRODL, RES0_2 ;
	
	MOVF ARG1, W, A
	MULWF ARG2_3, A ; ARG1L * ARG2H->
	; PRODH:PRODL
	MOVF PRODL, W, A ;
	banksel RES1_2
	ADDWFC RES1_2, F, A ; Add cross
	MOVF PRODH, W, A ; products
	ADDWFC RES2_2, F, A ;
	CLRF WREG, A ;
	;ADDWFC RES3_2, F, A ;
	
	
	call	LCD_Clear
	
	movf	RES3, W, A
	call	LCD_Write_Hex
	movf	RES2, W, A
	call	LCD_Write_Hex
	movf	RES1, W, A
	call	LCD_Write_Hex
	movf	RES0, W, A
	call	LCD_Write_Hex
	
	
;	movf	RES3_2, W, A
;	call	LCD_Write_Hex
	movf	RES2_2, W, A
	call	LCD_Write_Hex
	movf	RES1_2, W, A
	call	LCD_Write_Hex
	movf	RES0_2, W, A
	call	LCD_Write_Hex
	
	
	
	;movf	RES2, W, A
	
	
	;test
;	movf	RES0_2, W, A
;	ADDWFC	RES2, F, A 
;	movwf	RES2, A
;	
;	
;	movf	RES1_2, W, A
;	ADDWFC	RES3, F, A 
;	movwf	RES3, A
	;;;;;;;;;;
	
	
	
	; output is res0. res1, res2. res3
	; overflow stored in res2_2
	
	
	
	
	
	
	
	
	banksel 0
	return
	
	end	rst