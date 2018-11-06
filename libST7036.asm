
_nobusy_send_instr:

;libST7036.c,17 :: 		void nobusy_send_instr(unsigned char byte){
;libST7036.c,18 :: 		lcd_RS = 0;
	BCF         LATA1_bit+0, BitPos(LATA1_bit+0) 
;libST7036.c,19 :: 		lcd_RW = 0;
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;libST7036.c,20 :: 		lcd_E = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;libST7036.c,21 :: 		LATC = byte;
	MOVF        FARG_nobusy_send_instr_byte+0, 0 
	MOVWF       LATC+0 
;libST7036.c,22 :: 		lcd_E = 0;
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;libST7036.c,23 :: 		Delay_us(100);
	MOVLW       33
	MOVWF       R13, 0
L_nobusy_send_instr0:
	DECFSZ      R13, 1, 1
	BRA         L_nobusy_send_instr0
;libST7036.c,24 :: 		}
L_end_nobusy_send_instr:
	RETURN      0
; end of _nobusy_send_instr

_nobusy_send_data:

;libST7036.c,26 :: 		void nobusy_send_data(unsigned char byte){
;libST7036.c,27 :: 		lcd_RS = 1;
	BSF         LATA1_bit+0, BitPos(LATA1_bit+0) 
;libST7036.c,28 :: 		lcd_RW = 0;
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;libST7036.c,29 :: 		lcd_E = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;libST7036.c,30 :: 		LATC = byte;
	MOVF        FARG_nobusy_send_data_byte+0, 0 
	MOVWF       LATC+0 
;libST7036.c,31 :: 		lcd_E = 0;
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;libST7036.c,32 :: 		Delay_us(100);
	MOVLW       33
	MOVWF       R13, 0
L_nobusy_send_data1:
	DECFSZ      R13, 1, 1
	BRA         L_nobusy_send_data1
;libST7036.c,33 :: 		}
L_end_nobusy_send_data:
	RETURN      0
; end of _nobusy_send_data

_init:

;libST7036.c,35 :: 		void init(void){
;libST7036.c,36 :: 		Delay_ms(40);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_init2:
	DECFSZ      R13, 1, 1
	BRA         L_init2
	DECFSZ      R12, 1, 1
	BRA         L_init2
	NOP
	NOP
;libST7036.c,37 :: 		nobusy_send_instr(0x31);     //8bit, 1 line, 5*8 font, instr. table 1
	MOVLW       49
	MOVWF       FARG_nobusy_send_instr_byte+0 
	CALL        _nobusy_send_instr+0, 0
;libST7036.c,38 :: 		nobusy_send_instr(0x31);        //8bit, 1 line, 5*8 font, instr. table 0
	MOVLW       49
	MOVWF       FARG_nobusy_send_instr_byte+0 
	CALL        _nobusy_send_instr+0, 0
;libST7036.c,40 :: 		nobusy_send_instr(0x14);        //set bias
	MOVLW       20
	MOVWF       FARG_nobusy_send_instr_byte+0 
	CALL        _nobusy_send_instr+0, 0
;libST7036.c,41 :: 		nobusy_send_instr(0x51);        //power, icon off, booster o
	MOVLW       81
	MOVWF       FARG_nobusy_send_instr_byte+0 
	CALL        _nobusy_send_instr+0, 0
;libST7036.c,42 :: 		nobusy_send_instr(0x6a);        //set follower
	MOVLW       106
	MOVWF       FARG_nobusy_send_instr_byte+0 
	CALL        _nobusy_send_instr+0, 0
;libST7036.c,43 :: 		nobusy_send_instr(0x74);        //set contrast
	MOVLW       116
	MOVWF       FARG_nobusy_send_instr_byte+0 
	CALL        _nobusy_send_instr+0, 0
;libST7036.c,45 :: 		nobusy_send_instr(0x30);        //8bit, 1 line, 5*8 font, instr. table 0
	MOVLW       48
	MOVWF       FARG_nobusy_send_instr_byte+0 
	CALL        _nobusy_send_instr+0, 0
;libST7036.c,46 :: 		nobusy_send_instr(0x0c);       //display on, cursor off
	MOVLW       12
	MOVWF       FARG_nobusy_send_instr_byte+0 
	CALL        _nobusy_send_instr+0, 0
;libST7036.c,47 :: 		nobusy_send_instr(0x01);      //clear display
	MOVLW       1
	MOVWF       FARG_nobusy_send_instr_byte+0 
	CALL        _nobusy_send_instr+0, 0
;libST7036.c,48 :: 		Delay_ms(2);
	MOVLW       3
	MOVWF       R12, 0
	MOVLW       151
	MOVWF       R13, 0
L_init3:
	DECFSZ      R13, 1, 1
	BRA         L_init3
	DECFSZ      R12, 1, 1
	BRA         L_init3
	NOP
	NOP
;libST7036.c,49 :: 		nobusy_send_instr(0x06);      //entry mode, autoincrement
	MOVLW       6
	MOVWF       FARG_nobusy_send_instr_byte+0 
	CALL        _nobusy_send_instr+0, 0
;libST7036.c,50 :: 		}
L_end_init:
	RETURN      0
; end of _init
