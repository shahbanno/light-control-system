#include <xc.inc>

extrn	UART_Setup, UART_Transmit_Message  ; external uart subroutines
extrn	LCD_Setup, LCD_Write_Message, LCD_Write_Hex, LCD_Clear, LCD_delay_ms ; external LCD subroutines
extrn	ADC_Setup, ADC_Read		   ; external ADC subroutines
extrn	ADC_Interrupt_Service, Enable_Interrupt	
    
    
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
	goto	ADC_Interrupt_Service
	
	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup UART
	call	ADC_Setup	; setup ADC
	goto	targetInput
	
targetInput:
    
	call	Enable_Interrupt
	goto	feedbackloop
	
	
feedbackloop:
	
    
	bra feedbackloop
   
;	
	

	return

end	rst