
_isr_portb:

;pajka.c,35 :: 		void isr_portb() iv 0x0008 ics ICS_AUTO {
;pajka.c,36 :: 		povol_prerus_enkoder = 0;
	BCF         RBIE_bit+0, BitPos(RBIE_bit+0) 
;pajka.c,37 :: 		Delay_ms(2);    //zakmity max 2ms pre enkoder a tlacidlo rucky
	MOVLW       3
	MOVWF       R12, 0
	MOVLW       151
	MOVWF       R13, 0
L_isr_portb0:
	DECFSZ      R13, 1, 1
	BRA         L_isr_portb0
	DECFSZ      R12, 1, 1
	BRA         L_isr_portb0
	NOP
	NOP
;pajka.c,38 :: 		if (in_encA)  priz_enc = 1;
	BTFSS       RB7_bit+0, BitPos(RB7_bit+0) 
	GOTO        L_isr_portb1
	MOVLW       1
	MOVWF       _priz_enc+0 
L_isr_portb1:
;pajka.c,39 :: 		if (in_encB)  priz_enc = 2;
	BTFSS       RB5_bit+0, BitPos(RB5_bit+0) 
	GOTO        L_isr_portb2
	MOVLW       2
	MOVWF       _priz_enc+0 
L_isr_portb2:
;pajka.c,41 :: 		if (in_encBUT) priz_enc = 3;
	BTFSS       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_isr_portb3
	MOVLW       3
	MOVWF       _priz_enc+0 
L_isr_portb3:
;pajka.c,42 :: 		priz_prerus_enkoder = 0;
	BCF         RBIF_bit+0, BitPos(RBIF_bit+0) 
;pajka.c,43 :: 		}
L_end_isr_portb:
L__isr_portb82:
	RETFIE      1
; end of _isr_portb

_isr_tmr1:
	MOVWF       ___Low_saveWREG+0 
	MOVF        STATUS+0, 0 
	MOVWF       ___Low_saveSTATUS+0 
	MOVF        BSR+0, 0 
	MOVWF       ___Low_saveBSR+0 

;pajka.c,45 :: 		void isr_tmr1() iv 0x0018 ics ICS_AUTO {
;pajka.c,46 :: 		povol_prerus_rucka = 0;
	BCF         INT2IE_bit+0, BitPos(INT2IE_bit+0) 
;pajka.c,47 :: 		if(priz_prerus_tmr1)
	BTFSS       TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
	GOTO        L_isr_tmr14
;pajka.c,48 :: 		if(tmr_tmp < 10){
	MOVLW       10
	SUBWF       _tmr_tmp+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_isr_tmr15
;pajka.c,49 :: 		tmr_tmp++;
	INCF        _tmr_tmp+0, 1 
;pajka.c,50 :: 		}
	GOTO        L_isr_tmr16
L_isr_tmr15:
;pajka.c,52 :: 		svietiLCD = ~svietiLCD;
	BTG         _mojPriznak+0, 1 
;pajka.c,53 :: 		tmr_tmp = 0;
	CLRF        _tmr_tmp+0 
;pajka.c,54 :: 		}
L_isr_tmr16:
L_isr_tmr14:
;pajka.c,55 :: 		if (priz_prerus_rucka) priznak_tlacidlo_rucky = ~priznak_tlacidlo_rucky;
	BTFSS       INT2IF_bit+0, BitPos(INT2IF_bit+0) 
	GOTO        L_isr_tmr17
	BTG         _mojPriznak+0, 3 
L_isr_tmr17:
;pajka.c,56 :: 		priz_prerus_rucka = 0;
	BCF         INT2IF_bit+0, BitPos(INT2IF_bit+0) 
;pajka.c,57 :: 		priz_prerus_tmr1 = 0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;pajka.c,58 :: 		}
L_end_isr_tmr1:
L__isr_tmr184:
	MOVF        ___Low_saveBSR+0, 0 
	MOVWF       BSR+0 
	MOVF        ___Low_saveSTATUS+0, 0 
	MOVWF       STATUS+0 
	SWAPF       ___Low_saveWREG+0, 1 
	SWAPF       ___Low_saveWREG+0, 0 
	RETFIE      0
; end of _isr_tmr1

_main:

;pajka.c,61 :: 		void main() {
;pajka.c,62 :: 		TRISA = 0b00000001;
	MOVLW       1
	MOVWF       TRISA+0 
;pajka.c,63 :: 		TRISB = 0b11100110;
	MOVLW       230
	MOVWF       TRISB+0 
;pajka.c,64 :: 		TRISC = 0;
	CLRF        TRISC+0 
;pajka.c,65 :: 		PORTA = 0;
	CLRF        PORTA+0 
;pajka.c,66 :: 		PORTB = 0;
	CLRF        PORTB+0 
;pajka.c,67 :: 		PORTC = 0;
	CLRF        PORTC+0 
;pajka.c,68 :: 		INTCON = 0;
	CLRF        INTCON+0 
;pajka.c,69 :: 		RCON.IPEN = 1;      // interrupt priority enabled
	BSF         RCON+0, 7 
;pajka.c,70 :: 		INTCON.GIEH = 1;   //high prior int enabled
	BSF         INTCON+0, 7 
;pajka.c,71 :: 		INTCON.GIEL = 1;   //low prior int enabled
	BSF         INTCON+0, 6 
;pajka.c,72 :: 		INTCON2.RBPU = 0;     //int pull-up
	BCF         INTCON2+0, 7 
;pajka.c,73 :: 		INTCON2.RBIP = 1;   //portb high priority interrupt
	BSF         INTCON2+0, 0 
;pajka.c,75 :: 		ADCON0 = 0b00000001; //ADC On, AN0 - analog
	MOVLW       1
	MOVWF       ADCON0+0 
;pajka.c,76 :: 		ADCON1 = 0b10001110; //AN0 analog, right just, 12 TaD, FOSC/8
	MOVLW       142
	MOVWF       ADCON1+0 
;pajka.c,77 :: 		PIE1.ADIE = 0;      //AD polluje
	BCF         PIE1+0, 6 
;pajka.c,80 :: 		INTCON2.INTEDG2 = 1;
	BSF         INTCON2+0, 4 
;pajka.c,82 :: 		INTCON3.INT2IP = 0;
	BCF         INTCON3+0, 7 
;pajka.c,84 :: 		T1CON = 0b10110000; //16 bit operation, 1:8 prescaler, oscil disabled
	MOVLW       176
	MOVWF       T1CON+0 
;pajka.c,85 :: 		TMR1IP_bit = 0;     //low priority
	BCF         TMR1IP_bit+0, BitPos(TMR1IP_bit+0) 
;pajka.c,87 :: 		priz_prerus_enkoder = 0;
	BCF         RBIF_bit+0, BitPos(RBIF_bit+0) 
;pajka.c,88 :: 		priz_prerus_rucka = 0;
	BCF         INT2IF_bit+0, BitPos(INT2IF_bit+0) 
;pajka.c,89 :: 		priz_prerus_tmr1 = 0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;pajka.c,90 :: 		povol_prerus_enkoder = 1;
	BSF         RBIE_bit+0, BitPos(RBIE_bit+0) 
;pajka.c,91 :: 		povol_prerus_rucka = 1;
	BSF         INT2IE_bit+0, BitPos(INT2IE_bit+0) 
;pajka.c,92 :: 		povol_prerus_tmr1 = 1;
	BSF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;pajka.c,93 :: 		priznak_tlacidlo_rucky = 0;
	BCF         _mojPriznak+0, 3 
;pajka.c,94 :: 		stary_rezim = 0;
	CLRF        _stary_rezim+0 
;pajka.c,95 :: 		rezim = 0;
	CLRF        _rezim+0 
;pajka.c,96 :: 		priz_enc = 0;
	CLRF        _priz_enc+0 
;pajka.c,97 :: 		blinkdisp = 0;
	BCF         _mojPriznak+0, 0 
;pajka.c,98 :: 		zapis = 0;
	BCF         _mojPriznak+0, 2 
;pajka.c,99 :: 		tmr_tmp = 0;
	CLRF        _tmr_tmp+0 
;pajka.c,100 :: 		svietiLCD = 0;
	BCF         _mojPriznak+0, 1 
;pajka.c,101 :: 		i = 0;
	CLRF        _i+0 
;pajka.c,102 :: 		j = 0;
	CLRF        _j+0 
;pajka.c,109 :: 		nastav_rezim(rezim, res_eeprom);   //pri zapnuti prejde do udrziav rezimu
	CLRF        FARG_nastav_rezim_rezim+0 
	MOVF        _res_eeprom+0, 0 
	MOVWF       FARG_nastav_rezim_res_eeprom+0 
	CALL        _nastav_rezim+0, 0
;pajka.c,110 :: 		while (1){
L_main8:
;pajka.c,112 :: 		for(i=0; i<3; i++){
	CLRF        _i+0 
L_main10:
	MOVLW       3
	SUBWF       _i+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main11
;pajka.c,114 :: 		temp_int_ad = 0x288;     //skuska - 952
	MOVLW       136
	MOVWF       _temp_int_ad+0 
	MOVLW       2
	MOVWF       _temp_int_ad+1 
;pajka.c,115 :: 		temp_int_ad >>= 2;       //posun o dva bity - delenie styrmi - 238
	MOVF        _temp_int_ad+0, 0 
	MOVWF       R0 
	MOVF        _temp_int_ad+1, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	MOVF        R0, 0 
	MOVWF       _temp_int_ad+0 
	MOVF        R1, 0 
	MOVWF       _temp_int_ad+1 
;pajka.c,116 :: 		temp_ad[i] = temp_int_ad;
	MOVLW       _temp_ad+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_temp_ad+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;pajka.c,117 :: 		Delay_ms(2);
	MOVLW       3
	MOVWF       R12, 0
	MOVLW       151
	MOVWF       R13, 0
L_main13:
	DECFSZ      R13, 1, 1
	BRA         L_main13
	DECFSZ      R12, 1, 1
	BRA         L_main13
	NOP
	NOP
;pajka.c,112 :: 		for(i=0; i<3; i++){
	INCF        _i+0, 1 
;pajka.c,118 :: 		}
	GOTO        L_main10
L_main11:
;pajka.c,119 :: 		res_ad = ((temp_ad[0] + temp_ad[1] + temp_ad[2])/3);
	MOVF        _temp_ad+1, 0 
	ADDWF       _temp_ad+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        _temp_ad+2, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       3
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       _res_ad+0 
;pajka.c,121 :: 		switch(priz_enc) {
	GOTO        L_main14
;pajka.c,122 :: 		case 1 : rut_encA(&res_eeprom); break;
L_main16:
	MOVLW       _res_eeprom+0
	MOVWF       FARG_rut_encA_p_res_eeprom+0 
	MOVLW       hi_addr(_res_eeprom+0)
	MOVWF       FARG_rut_encA_p_res_eeprom+1 
	CALL        _rut_encA+0, 0
	GOTO        L_main15
;pajka.c,123 :: 		case 2 : rut_encB(&res_eeprom); break;
L_main17:
	MOVLW       _res_eeprom+0
	MOVWF       FARG_rut_encB_p_res_eeprom+0 
	MOVLW       hi_addr(_res_eeprom+0)
	MOVWF       FARG_rut_encB_p_res_eeprom+1 
	CALL        _rut_encB+0, 0
	GOTO        L_main15
;pajka.c,124 :: 		case 3 : rut_encBUT(&priz_enc); break;
L_main18:
	MOVLW       _priz_enc+0
	MOVWF       FARG_rut_encBUT_p_priz_enc+0 
	MOVLW       hi_addr(_priz_enc+0)
	MOVWF       FARG_rut_encBUT_p_priz_enc+1 
	CALL        _rut_encBUT+0, 0
	GOTO        L_main15
;pajka.c,126 :: 		}
L_main14:
	MOVF        _priz_enc+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_main16
	MOVF        _priz_enc+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_main17
	MOVF        _priz_enc+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_main18
L_main15:
;pajka.c,128 :: 		if(priz_prerus_rucka){  //ak prislo prerusenie od tlacidla
	BTFSS       INT2IF_bit+0, BitPos(INT2IF_bit+0) 
	GOTO        L_main19
;pajka.c,129 :: 		if ((priznak_tlacidlo_rucky)&&(!blinkdisp)){
	BTFSS       _mojPriznak+0, 3 
	GOTO        L_main22
	BTFSC       _mojPriznak+0, 0 
	GOTO        L_main22
L__main80:
;pajka.c,130 :: 		if (rezim) stary_rezim = rezim;
	MOVF        _rezim+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main23
	MOVF        _rezim+0, 0 
	MOVWF       _stary_rezim+0 
L_main23:
;pajka.c,131 :: 		rezim = 0;
	CLRF        _rezim+0 
;pajka.c,132 :: 		nastav_rezim(rezim, res_eeprom);
	CLRF        FARG_nastav_rezim_rezim+0 
	MOVF        _res_eeprom+0, 0 
	MOVWF       FARG_nastav_rezim_res_eeprom+0 
	CALL        _nastav_rezim+0, 0
;pajka.c,133 :: 		}
L_main22:
;pajka.c,134 :: 		if ((!priznak_tlacidlo_rucky)&&(!blinkdisp)){
	BTFSC       _mojPriznak+0, 3 
	GOTO        L_main26
	BTFSC       _mojPriznak+0, 0 
	GOTO        L_main26
L__main79:
;pajka.c,135 :: 		rezim = stary_rezim;
	MOVF        _stary_rezim+0, 0 
	MOVWF       _rezim+0 
;pajka.c,136 :: 		nastav_rezim(rezim, res_eeprom);
	MOVF        _stary_rezim+0, 0 
	MOVWF       FARG_nastav_rezim_rezim+0 
	MOVF        _res_eeprom+0, 0 
	MOVWF       FARG_nastav_rezim_res_eeprom+0 
	CALL        _nastav_rezim+0, 0
;pajka.c,137 :: 		}
L_main26:
;pajka.c,138 :: 		priz_prerus_rucka = 0;
	BCF         INT2IF_bit+0, BitPos(INT2IF_bit+0) 
;pajka.c,139 :: 		povol_prerus(priz_enc);
	MOVF        _priz_enc+0, 0 
	MOVWF       FARG_povol_prerus_p_priz_enc+0 
	MOVLW       0
	MOVWF       FARG_povol_prerus_p_priz_enc+1 
	CALL        _povol_prerus+0, 0
;pajka.c,140 :: 		}
L_main19:
;pajka.c,142 :: 		if(blinkdisp){
	BTFSS       _mojPriznak+0, 0 
	GOTO        L_main27
;pajka.c,143 :: 		konver(rezim, res_eeprom, &lcd_result);
	MOVF        _rezim+0, 0 
	MOVWF       FARG_konver_rezim+0 
	MOVF        _res_eeprom+0, 0 
	MOVWF       FARG_konver_res_ad_eeprom+0 
	MOVLW       _lcd_result+0
	MOVWF       FARG_konver_lcd_result+0 
	MOVLW       hi_addr(_lcd_result+0)
	MOVWF       FARG_konver_lcd_result+1 
	CALL        _konver+0, 0
;pajka.c,144 :: 		display(&lcd_result);
	MOVLW       _lcd_result+0
	MOVWF       FARG_display_lcd_result+0 
	MOVLW       hi_addr(_lcd_result+0)
	MOVWF       FARG_display_lcd_result+1 
	CALL        _display+0, 0
;pajka.c,145 :: 		}
	GOTO        L_main28
L_main27:
;pajka.c,147 :: 		konver(rezim, res_ad, &lcd_result);
	MOVF        _rezim+0, 0 
	MOVWF       FARG_konver_rezim+0 
	MOVF        _res_ad+0, 0 
	MOVWF       FARG_konver_res_ad_eeprom+0 
	MOVLW       _lcd_result+0
	MOVWF       FARG_konver_lcd_result+0 
	MOVLW       hi_addr(_lcd_result+0)
	MOVWF       FARG_konver_lcd_result+1 
	CALL        _konver+0, 0
;pajka.c,148 :: 		display(&lcd_result);
	MOVLW       _lcd_result+0
	MOVWF       FARG_display_lcd_result+0 
	MOVLW       hi_addr(_lcd_result+0)
	MOVWF       FARG_display_lcd_result+1 
	CALL        _display+0, 0
;pajka.c,149 :: 		}
L_main28:
;pajka.c,153 :: 		if (res_eeprom > res_ad){
	MOVF        _res_eeprom+0, 0 
	SUBWF       _res_ad+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main29
;pajka.c,154 :: 		out_paj = 1;
	BSF         RB3_bit+0, BitPos(RB3_bit+0) 
;pajka.c,155 :: 		}
	GOTO        L_main30
L_main29:
;pajka.c,157 :: 		out_paj = 0;
	BCF         RB3_bit+0, BitPos(RB3_bit+0) 
;pajka.c,158 :: 		}
L_main30:
;pajka.c,159 :: 		}//while
	GOTO        L_main8
;pajka.c,160 :: 		}//main
L_end_main:
	GOTO        $+0
; end of _main

_nastav_rezim:

;pajka.c,162 :: 		u_short nastav_rezim(u_short rezim, u_short res_eeprom){
;pajka.c,164 :: 		res_eeprom = EEPROM_Read(rezim);
	MOVF        FARG_nastav_rezim_rezim+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_nastav_rezim_res_eeprom+0 
;pajka.c,165 :: 		return(res_eeprom);
;pajka.c,166 :: 		}
L_end_nastav_rezim:
	RETURN      0
; end of _nastav_rezim

_rut_encBUT:

;pajka.c,168 :: 		u_short rut_encBUT(u_short *p_priz_enc){
;pajka.c,169 :: 		Delay_ms(500);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_rut_encBUT31:
	DECFSZ      R13, 1, 1
	BRA         L_rut_encBUT31
	DECFSZ      R12, 1, 1
	BRA         L_rut_encBUT31
	DECFSZ      R11, 1, 1
	BRA         L_rut_encBUT31
	NOP
	NOP
;pajka.c,170 :: 		if(in_encBUT){             //ak je stlacenie dlhe
	BTFSS       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_rut_encBUT32
;pajka.c,171 :: 		if(blinkdisp){
	BTFSS       _mojPriznak+0, 0 
	GOTO        L_rut_encBUT33
;pajka.c,172 :: 		eeprom_write(rezim, res_eeprom);    //zapis hodnotu do eeprom
	MOVF        _rezim+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        _res_eeprom+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;pajka.c,173 :: 		blinkdisp = 0;  //hned aj vypni blikanie
	BCF         _mojPriznak+0, 0 
;pajka.c,174 :: 		spusti_tmr1 = 0;    //zastav tmr1
	BCF         TMR1ON_bit+0, BitPos(TMR1ON_bit+0) 
;pajka.c,175 :: 		povol_prerus_tmr1 = 0;
	BCF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;pajka.c,176 :: 		priz_prerus_tmr1 = 0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;pajka.c,177 :: 		svietiLCD = 0;
	BCF         _mojPriznak+0, 1 
;pajka.c,178 :: 		zapis = 1;
	BSF         _mojPriznak+0, 2 
;pajka.c,179 :: 		}
L_rut_encBUT33:
;pajka.c,180 :: 		}
	GOTO        L_rut_encBUT34
L_rut_encBUT32:
;pajka.c,182 :: 		blinkdisp = ~blinkdisp; //zapni/vypni blikanie
	BTG         _mojPriznak+0, 0 
;pajka.c,183 :: 		if(blinkdisp){          //ak si zapol blikanie
	BTFSS       _mojPriznak+0, 0 
	GOTO        L_rut_encBUT35
;pajka.c,184 :: 		TMR1H = 0;
	CLRF        TMR1H+0 
;pajka.c,185 :: 		TMR1L = 0;
	CLRF        TMR1L+0 
;pajka.c,186 :: 		priz_prerus_tmr1 = 0;//spusti tmr1
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;pajka.c,187 :: 		povol_prerus_tmr1 = 1;
	BSF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;pajka.c,188 :: 		spusti_tmr1 = 1;
	BSF         TMR1ON_bit+0, BitPos(TMR1ON_bit+0) 
;pajka.c,189 :: 		}
	GOTO        L_rut_encBUT36
L_rut_encBUT35:
;pajka.c,191 :: 		spusti_tmr1 = 0;    //zastav tmr1
	BCF         TMR1ON_bit+0, BitPos(TMR1ON_bit+0) 
;pajka.c,192 :: 		povol_prerus_tmr1 = 0;
	BCF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;pajka.c,193 :: 		priz_prerus_tmr1 = 0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;pajka.c,194 :: 		TMR1H = 0;
	CLRF        TMR1H+0 
;pajka.c,195 :: 		TMR1L = 0;
	CLRF        TMR1L+0 
;pajka.c,196 :: 		svietiLCD = 0;
	BCF         _mojPriznak+0, 1 
;pajka.c,197 :: 		zapis = 0;
	BCF         _mojPriznak+0, 2 
;pajka.c,198 :: 		}
L_rut_encBUT36:
;pajka.c,199 :: 		}
L_rut_encBUT34:
;pajka.c,202 :: 		povol_prerus(&priz_enc);
	MOVLW       _priz_enc+0
	MOVWF       FARG_povol_prerus_p_priz_enc+0 
	MOVLW       hi_addr(_priz_enc+0)
	MOVWF       FARG_povol_prerus_p_priz_enc+1 
	CALL        _povol_prerus+0, 0
;pajka.c,203 :: 		}
L_end_rut_encBUT:
	RETURN      0
; end of _rut_encBUT

_rut_encA:

;pajka.c,205 :: 		u_short rut_encA(u_short *p_res_eeprom){
;pajka.c,206 :: 		if (!blinkdisp){    //ak neblika display
	BTFSC       _mojPriznak+0, 0 
	GOTO        L_rut_encA37
;pajka.c,207 :: 		rezim += 1;     //tak zmen rezim
	INCF        _rezim+0, 1 
;pajka.c,208 :: 		if (rezim > 3) {
	MOVF        _rezim+0, 0 
	SUBLW       3
	BTFSC       STATUS+0, 0 
	GOTO        L_rut_encA38
;pajka.c,209 :: 		rezim = 0;
	CLRF        _rezim+0 
;pajka.c,210 :: 		}
L_rut_encA38:
;pajka.c,211 :: 		res_eeprom = EEPROM_Read(rezim);
	MOVF        _rezim+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _res_eeprom+0 
;pajka.c,212 :: 		}
	GOTO        L_rut_encA39
L_rut_encA37:
;pajka.c,214 :: 		res_eeprom += 5;
	MOVLW       5
	ADDWF       _res_eeprom+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _res_eeprom+0 
;pajka.c,215 :: 		konver(rezim, res_eeprom, &lcd_result);
	MOVF        _rezim+0, 0 
	MOVWF       FARG_konver_rezim+0 
	MOVF        R0, 0 
	MOVWF       FARG_konver_res_ad_eeprom+0 
	MOVLW       _lcd_result+0
	MOVWF       FARG_konver_lcd_result+0 
	MOVLW       hi_addr(_lcd_result+0)
	MOVWF       FARG_konver_lcd_result+1 
	CALL        _konver+0, 0
;pajka.c,216 :: 		display(&lcd_result);
	MOVLW       _lcd_result+0
	MOVWF       FARG_display_lcd_result+0 
	MOVLW       hi_addr(_lcd_result+0)
	MOVWF       FARG_display_lcd_result+1 
	CALL        _display+0, 0
;pajka.c,217 :: 		}
L_rut_encA39:
;pajka.c,218 :: 		povol_prerus(priz_enc);
	MOVF        _priz_enc+0, 0 
	MOVWF       FARG_povol_prerus_p_priz_enc+0 
	MOVLW       0
	MOVWF       FARG_povol_prerus_p_priz_enc+1 
	CALL        _povol_prerus+0, 0
;pajka.c,219 :: 		return(rezim);
	MOVF        _rezim+0, 0 
	MOVWF       R0 
;pajka.c,220 :: 		}
L_end_rut_encA:
	RETURN      0
; end of _rut_encA

_rut_encB:

;pajka.c,222 :: 		u_short rut_encB(u_short *p_res_eeprom){
;pajka.c,223 :: 		if (!blinkdisp){        //a neblika display
	BTFSC       _mojPriznak+0, 0 
	GOTO        L_rut_encB40
;pajka.c,224 :: 		if (!rezim) {     //tak zmen rezim
	MOVF        _rezim+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_rut_encB41
;pajka.c,225 :: 		rezim = 3;
	MOVLW       3
	MOVWF       _rezim+0 
;pajka.c,226 :: 		}
	GOTO        L_rut_encB42
L_rut_encB41:
;pajka.c,228 :: 		rezim -= 1;
	DECF        _rezim+0, 1 
;pajka.c,229 :: 		}
L_rut_encB42:
;pajka.c,230 :: 		res_eeprom = EEPROM_Read(rezim);
	MOVF        _rezim+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _res_eeprom+0 
;pajka.c,231 :: 		}
	GOTO        L_rut_encB43
L_rut_encB40:
;pajka.c,233 :: 		res_eeprom -= 5;
	MOVLW       5
	SUBWF       _res_eeprom+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _res_eeprom+0 
;pajka.c,234 :: 		konver(rezim, res_eeprom, &lcd_result);
	MOVF        _rezim+0, 0 
	MOVWF       FARG_konver_rezim+0 
	MOVF        R0, 0 
	MOVWF       FARG_konver_res_ad_eeprom+0 
	MOVLW       _lcd_result+0
	MOVWF       FARG_konver_lcd_result+0 
	MOVLW       hi_addr(_lcd_result+0)
	MOVWF       FARG_konver_lcd_result+1 
	CALL        _konver+0, 0
;pajka.c,235 :: 		display(&lcd_result);
	MOVLW       _lcd_result+0
	MOVWF       FARG_display_lcd_result+0 
	MOVLW       hi_addr(_lcd_result+0)
	MOVWF       FARG_display_lcd_result+1 
	CALL        _display+0, 0
;pajka.c,236 :: 		}
L_rut_encB43:
;pajka.c,237 :: 		povol_prerus(priz_enc);
	MOVF        _priz_enc+0, 0 
	MOVWF       FARG_povol_prerus_p_priz_enc+0 
	MOVLW       0
	MOVWF       FARG_povol_prerus_p_priz_enc+1 
	CALL        _povol_prerus+0, 0
;pajka.c,238 :: 		return(rezim);
	MOVF        _rezim+0, 0 
	MOVWF       R0 
;pajka.c,239 :: 		}
L_end_rut_encB:
	RETURN      0
; end of _rut_encB

_konver:

;pajka.c,241 :: 		u_short konver(u_short rezim, u_short res_ad_eeprom, u_short lcd_result[]){
;pajka.c,242 :: 		u_short temp = 0;
	CLRF        konver_temp_L0+0 
;pajka.c,245 :: 		res_lcd = (res_ad_eeprom * prevod_lcd);
	MOVF        FARG_konver_res_ad_eeprom+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       185
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       konver_res_lcd_L0+0 
	MOVF        R1, 0 
	MOVWF       konver_res_lcd_L0+1 
;pajka.c,246 :: 		res_lcd = res_lcd / 100;
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       konver_res_lcd_L0+0 
	MOVF        R1, 0 
	MOVWF       konver_res_lcd_L0+1 
;pajka.c,247 :: 		digit_sto = div(res_lcd, 100);   //oddelim stovky
	MOVF        R0, 0 
	MOVWF       FARG_div_number+0 
	MOVF        R1, 0 
	MOVWF       FARG_div_number+1 
	MOVLW       100
	MOVWF       FARG_div_denom+0 
	MOVLW       0
	MOVWF       FARG_div_denom+1 
	MOVLW       FLOC__konver+0
	MOVWF       R0 
	MOVLW       hi_addr(FLOC__konver+0)
	MOVWF       R1 
	CALL        _div+0, 0
	MOVLW       4
	MOVWF       R0 
	MOVLW       _digit_sto+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_digit_sto+0)
	MOVWF       FSR1H 
	MOVLW       FLOC__konver+0
	MOVWF       FSR0 
	MOVLW       hi_addr(FLOC__konver+0)
	MOVWF       FSR0H 
L_konver44:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_konver44
;pajka.c,248 :: 		sto = digit_sto.quot;
	MOVF        _digit_sto+0, 0 
	MOVWF       _sto+0 
;pajka.c,249 :: 		res_lcd = res_lcd - (sto*100);
	MOVLW       100
	MULWF       _digit_sto+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        PRODH+0, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	SUBWF       konver_res_lcd_L0+0, 0 
	MOVWF       R0 
	MOVF        R1, 0 
	SUBWFB      konver_res_lcd_L0+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       konver_res_lcd_L0+0 
	MOVF        R1, 0 
	MOVWF       konver_res_lcd_L0+1 
;pajka.c,250 :: 		digit_des = div(res_lcd, 10);    //oddelim desiatky
	MOVF        R0, 0 
	MOVWF       FARG_div_number+0 
	MOVF        R1, 0 
	MOVWF       FARG_div_number+1 
	MOVLW       10
	MOVWF       FARG_div_denom+0 
	MOVLW       0
	MOVWF       FARG_div_denom+1 
	MOVLW       FLOC__konver+0
	MOVWF       R0 
	MOVLW       hi_addr(FLOC__konver+0)
	MOVWF       R1 
	CALL        _div+0, 0
	MOVLW       4
	MOVWF       R0 
	MOVLW       _digit_des+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_digit_des+0)
	MOVWF       FSR1H 
	MOVLW       FLOC__konver+0
	MOVWF       FSR0 
	MOVLW       hi_addr(FLOC__konver+0)
	MOVWF       FSR0H 
L_konver45:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_konver45
;pajka.c,251 :: 		des = digit_des.quot;
	MOVF        _digit_des+0, 0 
	MOVWF       _des+0 
;pajka.c,252 :: 		jed = digit_des.rem;            //zostanu jednotky
	MOVF        _digit_des+2, 0 
	MOVWF       _jed+0 
;pajka.c,254 :: 		switch (rezim) {
	GOTO        L_konver46
;pajka.c,255 :: 		case 0: lcd_result[6] = 0x55; lcd_result[7] = 0x44; break;  //UD - udrziav
L_konver48:
	MOVLW       6
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       85
	MOVWF       POSTINC1+0 
	MOVLW       7
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       68
	MOVWF       POSTINC1+0 
	GOTO        L_konver47
;pajka.c,256 :: 		case 1: lcd_result[6] = 0x53; lcd_result[7] = 0x4D; break;  //SM - smd
L_konver49:
	MOVLW       6
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       83
	MOVWF       POSTINC1+0 
	MOVLW       7
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       77
	MOVWF       POSTINC1+0 
	GOTO        L_konver47
;pajka.c,257 :: 		case 2: lcd_result[6] = 0x4E; lcd_result[7] = 0x4F; break;  //NO - normal
L_konver50:
	MOVLW       6
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       78
	MOVWF       POSTINC1+0 
	MOVLW       7
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       79
	MOVWF       POSTINC1+0 
	GOTO        L_konver47
;pajka.c,258 :: 		case 3: lcd_result[6] = 0x48; lcd_result[7] = 0x49; break;  //HI - vysoka
L_konver51:
	MOVLW       6
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       72
	MOVWF       POSTINC1+0 
	MOVLW       7
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       73
	MOVWF       POSTINC1+0 
	GOTO        L_konver47
;pajka.c,259 :: 		}
L_konver46:
	MOVF        FARG_konver_rezim+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_konver48
	MOVF        FARG_konver_rezim+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_konver49
	MOVF        FARG_konver_rezim+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_konver50
	MOVF        FARG_konver_rezim+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_konver51
L_konver47:
;pajka.c,260 :: 		lcd_result[3] = 0xDF;   //stupen z tabuliek graf. kontroleru
	MOVLW       3
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       223
	MOVWF       POSTINC1+0 
;pajka.c,261 :: 		lcd_result[4] = 0x43;   //C - celsia
	MOVLW       4
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       67
	MOVWF       POSTINC1+0 
;pajka.c,262 :: 		if(!svietiLCD){ //ak nie je nastaveny priznak tak prazdna medzera
	BTFSC       _mojPriznak+0, 1 
	GOTO        L_konver52
;pajka.c,263 :: 		lcd_result[5] = 0x20;   //medzera
	MOVLW       5
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       32
	MOVWF       POSTINC1+0 
;pajka.c,264 :: 		}
	GOTO        L_konver53
L_konver52:
;pajka.c,266 :: 		lcd_result[5] = 0xFD;   //znak <<
	MOVLW       5
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       253
	MOVWF       POSTINC1+0 
;pajka.c,267 :: 		}
L_konver53:
;pajka.c,268 :: 		if(zapis) lcd_result[5] = 0x23;   //znak zapisu #
	BTFSS       _mojPriznak+0, 2 
	GOTO        L_konver54
	MOVLW       5
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       35
	MOVWF       POSTINC1+0 
L_konver54:
;pajka.c,269 :: 		for (temp = 0; temp < 3; temp++){
	CLRF        konver_temp_L0+0 
L_konver55:
	MOVLW       3
	SUBWF       konver_temp_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_konver56
;pajka.c,270 :: 		switch (temp) {
	GOTO        L_konver58
;pajka.c,271 :: 		case 0 : temp0 = sto; break;
L_konver60:
	MOVF        _sto+0, 0 
	MOVWF       konver_temp0_L0+0 
	GOTO        L_konver59
;pajka.c,272 :: 		case 1 : temp0 = des; break;
L_konver61:
	MOVF        _des+0, 0 
	MOVWF       konver_temp0_L0+0 
	GOTO        L_konver59
;pajka.c,273 :: 		case 2 : temp0 = jed; break;
L_konver62:
	MOVF        _jed+0, 0 
	MOVWF       konver_temp0_L0+0 
	GOTO        L_konver59
;pajka.c,274 :: 		}
L_konver58:
	MOVF        konver_temp_L0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_konver60
	MOVF        konver_temp_L0+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_konver61
	MOVF        konver_temp_L0+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_konver62
L_konver59:
;pajka.c,275 :: 		switch(temp0) {
	GOTO        L_konver63
;pajka.c,276 :: 		case 0 : lcd_result[temp] = 0x30; break;
L_konver65:
	MOVF        konver_temp_L0+0, 0 
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       48
	MOVWF       POSTINC1+0 
	GOTO        L_konver64
;pajka.c,277 :: 		case 1 : lcd_result[temp] = 0x31; break;
L_konver66:
	MOVF        konver_temp_L0+0, 0 
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       49
	MOVWF       POSTINC1+0 
	GOTO        L_konver64
;pajka.c,278 :: 		case 2 : lcd_result[temp] = 0x32; break;
L_konver67:
	MOVF        konver_temp_L0+0, 0 
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       50
	MOVWF       POSTINC1+0 
	GOTO        L_konver64
;pajka.c,279 :: 		case 3 : lcd_result[temp] = 0x33; break;
L_konver68:
	MOVF        konver_temp_L0+0, 0 
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       51
	MOVWF       POSTINC1+0 
	GOTO        L_konver64
;pajka.c,280 :: 		case 4 : lcd_result[temp] = 0x34; break;
L_konver69:
	MOVF        konver_temp_L0+0, 0 
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       52
	MOVWF       POSTINC1+0 
	GOTO        L_konver64
;pajka.c,281 :: 		case 5 : lcd_result[temp] = 0x35; break;
L_konver70:
	MOVF        konver_temp_L0+0, 0 
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       53
	MOVWF       POSTINC1+0 
	GOTO        L_konver64
;pajka.c,282 :: 		case 6 : lcd_result[temp] = 0x36; break;
L_konver71:
	MOVF        konver_temp_L0+0, 0 
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       54
	MOVWF       POSTINC1+0 
	GOTO        L_konver64
;pajka.c,283 :: 		case 7 : lcd_result[temp] = 0x37; break;
L_konver72:
	MOVF        konver_temp_L0+0, 0 
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       55
	MOVWF       POSTINC1+0 
	GOTO        L_konver64
;pajka.c,284 :: 		case 8 : lcd_result[temp] = 0x38; break;
L_konver73:
	MOVF        konver_temp_L0+0, 0 
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       56
	MOVWF       POSTINC1+0 
	GOTO        L_konver64
;pajka.c,285 :: 		case 9 : lcd_result[temp] = 0x39; break;
L_konver74:
	MOVF        konver_temp_L0+0, 0 
	ADDWF       FARG_konver_lcd_result+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_konver_lcd_result+1, 0 
	MOVWF       FSR1H 
	MOVLW       57
	MOVWF       POSTINC1+0 
	GOTO        L_konver64
;pajka.c,286 :: 		}
L_konver63:
	MOVF        konver_temp0_L0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_konver65
	MOVF        konver_temp0_L0+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_konver66
	MOVF        konver_temp0_L0+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_konver67
	MOVF        konver_temp0_L0+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_konver68
	MOVF        konver_temp0_L0+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_konver69
	MOVF        konver_temp0_L0+0, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L_konver70
	MOVF        konver_temp0_L0+0, 0 
	XORLW       6
	BTFSC       STATUS+0, 2 
	GOTO        L_konver71
	MOVF        konver_temp0_L0+0, 0 
	XORLW       7
	BTFSC       STATUS+0, 2 
	GOTO        L_konver72
	MOVF        konver_temp0_L0+0, 0 
	XORLW       8
	BTFSC       STATUS+0, 2 
	GOTO        L_konver73
	MOVF        konver_temp0_L0+0, 0 
	XORLW       9
	BTFSC       STATUS+0, 2 
	GOTO        L_konver74
L_konver64:
;pajka.c,269 :: 		for (temp = 0; temp < 3; temp++){
	INCF        konver_temp_L0+0, 1 
;pajka.c,287 :: 		}
	GOTO        L_konver55
L_konver56:
;pajka.c,288 :: 		return (0);
	CLRF        R0 
;pajka.c,289 :: 		}
L_end_konver:
	RETURN      0
; end of _konver

_display:

;pajka.c,291 :: 		void display(u_short lcd_result[]){
;pajka.c,292 :: 		nobusy_send_instr(0x02);    //nastav na zaciatok displaya
	MOVLW       2
	MOVWF       FARG_nobusy_send_instr_byte+0 
	CALL        _nobusy_send_instr+0, 0
;pajka.c,293 :: 		for(i=0; i<8; i++){
	CLRF        _i+0 
L_display75:
	MOVLW       8
	SUBWF       _i+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_display76
;pajka.c,294 :: 		byte = lcd_result[i];
	MOVF        _i+0, 0 
	ADDWF       FARG_display_lcd_result+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_display_lcd_result+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _byte+0 
;pajka.c,295 :: 		nobusy_send_data(byte);
	MOVF        R0, 0 
	MOVWF       FARG_nobusy_send_data_byte+0 
	CALL        _nobusy_send_data+0, 0
;pajka.c,296 :: 		if(i<7) nobusy_send_instr(0x06);    //posun display - entry mode set
	MOVLW       7
	SUBWF       _i+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_display78
	MOVLW       6
	MOVWF       FARG_nobusy_send_instr_byte+0 
	CALL        _nobusy_send_instr+0, 0
L_display78:
;pajka.c,293 :: 		for(i=0; i<8; i++){
	INCF        _i+0, 1 
;pajka.c,297 :: 		}
	GOTO        L_display75
L_display76:
;pajka.c,298 :: 		}
L_end_display:
	RETURN      0
; end of _display

_povol_prerus:

;pajka.c,300 :: 		u_short povol_prerus(u_short *p_priz_enc){
;pajka.c,301 :: 		priz_enc = 0;   //aby som zbytocne neskakal do rutiny a nemenil rezim
	CLRF        _priz_enc+0 
;pajka.c,302 :: 		povol_prerus_rucka = 1;
	BSF         INT2IE_bit+0, BitPos(INT2IE_bit+0) 
;pajka.c,303 :: 		povol_prerus_enkoder = 1; //potom povolim prerusenie
	BSF         RBIE_bit+0, BitPos(RBIE_bit+0) 
;pajka.c,304 :: 		return(priz_enc);
	CLRF        R0 
;pajka.c,305 :: 		}
L_end_povol_prerus:
	RETURN      0
; end of _povol_prerus
