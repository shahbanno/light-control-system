#include <xc.inc>


global Keypad_Setup, Keypad_A_Decode, Keypad_Num_Decode


psect udata_acs ; named variables in access ram
LCD_cnt_l: ds 1 ; reserve 1 byte for variable LCD_cnt_l
LCD_cnt_h: ds 1 ; reserve 1 byte for variable LCD_cnt_h
LCD_cnt_ms: ds 1 ; reserve 1 byte for ms counter
LCD_tmp: ds 1 ; reserve 1 byte for temporary use
LCD_counter: ds 1 ; reserve 1 byte for counting through nessage
Row_bits: ds 1 ; store row bits (lower nibble needed)
Col_bits: ds 1 ; '' column '' (upper nibble ,,)
All_bits: ds 1
LCD_E EQU 5 ; LCD enable bit
LCD_RS EQU 4 ; LCD register select bit


psect keypad_code,class=CODE


Keypad_Setup: ; keypad connected to port E
    banksel PADCFG1
    bsf REPU
    banksel 0
    clrf LATE, A
    ; movlw 0x00
    ; movf TRISH, A
    return

Decode_Rows_Cols:
    ; decode rows
    movlw 0x0F
    movwf TRISE, A
    movlw 2
    call LCD_delay_ms

    ; movlw 0x0A
    ; movwf PORTE, A

    movff PORTE, Row_bits, A
    ; decode columns
    movlw 0xF0
    movwf TRISE, A
    movlw 2
    call LCD_delay_ms
    movff PORTE, Col_bits, A

    movf Row_bits, W, A
    iorwf Col_bits, 0,0
;    movwf PORTH, A
;    movff LATH, All_bits, A
    movwf All_bits
    
    return 
    
    
Keypad_A_Decode:
    call Decode_Rows_Cols
    
    ; CHECK IF A
    movlw 0x7E
    subwf All_bits, 0,0
    bz outputA
    
    return 
    
    
Keypad_Num_Decode:
    call Decode_Rows_Cols

    ; what number is it?
    
    ;
    ; CHECK IF 1
    movlw 0xEE
    subwf All_bits, 0,0
    bz output1

    ; CHECK IF 2
    movlw 0xED
    subwf All_bits, 0,0
    bz output2

    ; CHECK IF 3
    movlw 0xEB
    subwf All_bits, 0,0
    bz output3

    ; CHECK IF F
    ; movlw 0xE7
    ; subwf All_bits, 0
    ; bz output2

    
    ; CHECK IF 4
    movlw 0xDE
    subwf All_bits, 0,0
    bz output4

    ; CHECK IF 5
    movlw 0xDD
    subwf All_bits, 0,0
    bz output5

    ; CHECK IF 6
    movlw 0xDB
    subwf All_bits, 0,0
    bz output6

    ; CHECK IF 7
    movlw 0xBE
    subwf All_bits, 0,0
    bz output7

    ; CHECK IF 8
    movlw 0xBD
    subwf All_bits, 0,0
    bz output8

    ; CHECK IF 9
    movlw 0xBB
    subwf All_bits, 0,0
    bz output9

    ; CHECK IF D
    movlw 0xB7
    subwf All_bits, 0,0
    bz outputD

    ; CHECK IF 0
    movlw 0x7D
    subwf All_bits, 0,0
    bz output0

    ; None of these options so NULL
    bz outputNull


outputNull:
    movlw 0xFF
    return

output1:
    movlw 0x1
    return

output2:
    movlw 0x2
    return

output3:
    movlw 0x3
    return

output4:
    movlw 0x4
    return

output5:
    movlw 0x5
    return

output6:
    movlw 0x6
    return

output7:
    movlw 0x7
    return

output8:
    movlw 0x8
    return

output9:
    movlw 0x9
    return

outputA:
    movlw 0xA
    return

outputD:
    movlw 0xD
    return



; ** a few delay routines below here as LCD timing can be quite critical ****
LCD_delay_ms: ; delay given in ms in W
    movwf LCD_cnt_ms, A
lcdlp2: 
    movlw 250 ; 1 ms delay
    call LCD_delay_x4us
    decfsz LCD_cnt_ms, A
    bra lcdlp2
    return

LCD_delay_x4us: ; delay given in chunks of 4 microsecond in W
    movwf LCD_cnt_l, A ; now need to multiply by 16
    swapf LCD_cnt_l, F, A ; swap nibbles
    movlw 0x0f
    andwf LCD_cnt_l, W, A ; move low nibble to W
    movwf LCD_cnt_h, A ; then to LCD_cnt_h
    movlw 0xf0
    andwf LCD_cnt_l, F, A ; keep high nibble in LCD_cnt_l
    call LCD_delay
    return

LCD_delay: ; delay routine 4 instruction loop == 250ns
    movlw 0x00 ; W=0
lcdlp1: 
    decf LCD_cnt_l, F, A ; no carry when 0x00 -> 0xff
    subwfb LCD_cnt_h, F, A ; no carry when 0x00 -> 0xff
    bc lcdlp1 ; carry, then loop again
    return ; carry reset so return



end


