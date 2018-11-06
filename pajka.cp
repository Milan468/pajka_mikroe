#line 1 "C:/aplikace/milan/mikroC PRO for PIC/Projects/pajka/pajka.c"
#line 1 "c:/aplikace/milan/mikroc pro for pic/projects/pajka/libst7036.h"
void init();
void nobusy_send_instr(unsigned char byte);
void nobusy_send_data(unsigned char byte);
#line 1 "c:/aplikace/milan/mikroc pro for pic/projects/pajka/pajka.h"

sbit in_encA at RB7_bit;
sbit in_encBUT at RB6_bit;
sbit in_encB at RB5_bit;

sbit out_paj at RB3_bit;
sbit tlacidlo_rucky at RB2_bit;
sbit in_nap at RB1_bit;
sbit out_led at RB0_bit;


sbit povol_prerus_rucka at INT2IE_bit;
sbit priz_prerus_rucka at INT2IF_bit;

sbit povol_prerus_enkoder at RBIE_bit;
sbit priz_prerus_enkoder at RBIF_bit;

sbit spusti_tmr1 at TMR1ON_bit;
sbit priz_prerus_tmr1 at TMR1IF_bit;
sbit povol_prerus_tmr1 at TMR1IE_bit;

typedef struct divstruct {
 int quot;
 int rem;
 } div_t;
div_t digit_sto, digit_des, digit_jed;

typedef unsigned short u_short;

unsigned short mojPriznak;
sbit blinkdisp at mojPriznak.B0;
sbit svietiLCD at mojPriznak.B1;
sbit zapis at mojPriznak.B2;
sbit priznak_tlacidlo_rucky at mojPriznak.B3;

const prevod_lcd = 185;
const unsigned int EEPROM_array[] = {0x51, 0x97, 0xA2, 0xBD};
u_short rezim, stary_rezim;
u_short *p_rezim = &rezim;
u_short i, j, tmr_tmp, res_ad, res_eeprom, priz_enc;
u_short *p_res_eeprom = &res_eeprom;
u_short *p_priz_enc = &priz_enc;
u_short lcd_result[8], temp_ad[3], sto, des, jed;
unsigned int temp_int_ad;
extern u_short byte;

u_short rut_encBUT(u_short *p_priz_enc);
u_short rut_encA(u_short *p_res_eeprom);
u_short rut_encB(u_short *p_res_eeprom);
u_short konver(u_short rezim, u_short res_ad_eeprom, u_short lcd_result[]);
void display(u_short lcd_result[]);
u_short nastav_rezim(u_short rezim, u_short res_eeprom);
u_short povol_prerus(u_short *p_priz_enc);
void isr_portb(void);
void isr_tmr1(void);
#line 35 "C:/aplikace/milan/mikroC PRO for PIC/Projects/pajka/pajka.c"
void isr_portb() iv 0x0008 ics ICS_AUTO {
 povol_prerus_enkoder = 0;
 Delay_ms(2);
 if (in_encA) priz_enc = 1;
 if (in_encB) priz_enc = 2;

 if (in_encBUT) priz_enc = 3;
 priz_prerus_enkoder = 0;
}

void isr_tmr1() iv 0x0018 ics ICS_AUTO {
 povol_prerus_rucka = 0;
 if(priz_prerus_tmr1)
 if(tmr_tmp < 10){
 tmr_tmp++;
 }
 else{
 svietiLCD = ~svietiLCD;
 tmr_tmp = 0;
 }
 if (priz_prerus_rucka) priznak_tlacidlo_rucky = ~priznak_tlacidlo_rucky;
 priz_prerus_rucka = 0;
 priz_prerus_tmr1 = 0;
}


void main() {
 TRISA = 0b00000001;
 TRISB = 0b11100110;
 TRISC = 0;
 PORTA = 0;
 PORTB = 0;
 PORTC = 0;
 INTCON = 0;
 RCON.IPEN = 1;
 INTCON.GIEH = 1;
 INTCON.GIEL = 1;
 INTCON2.RBPU = 0;
 INTCON2.RBIP = 1;

 ADCON0 = 0b00000001;
 ADCON1 = 0b10001110;
 PIE1.ADIE = 0;


 INTCON2.INTEDG2 = 1;

 INTCON3.INT2IP = 0;

 T1CON = 0b10110000;
 TMR1IP_bit = 0;

 priz_prerus_enkoder = 0;
 priz_prerus_rucka = 0;
 priz_prerus_tmr1 = 0;
 povol_prerus_enkoder = 1;
 povol_prerus_rucka = 1;
 povol_prerus_tmr1 = 1;
 priznak_tlacidlo_rucky = 0;
 stary_rezim = 0;
 rezim = 0;
 priz_enc = 0;
 blinkdisp = 0;
 zapis = 0;
 tmr_tmp = 0;
 svietiLCD = 0;
 i = 0;
 j = 0;
#line 109 "C:/aplikace/milan/mikroC PRO for PIC/Projects/pajka/pajka.c"
 nastav_rezim(rezim, res_eeprom);
while (1){

 for(i=0; i<3; i++){

 temp_int_ad = 0x288;
 temp_int_ad >>= 2;
 temp_ad[i] = temp_int_ad;
 Delay_ms(2);
 }
 res_ad = ((temp_ad[0] + temp_ad[1] + temp_ad[2])/3);

 switch(priz_enc) {
 case 1 : rut_encA(&res_eeprom); break;
 case 2 : rut_encB(&res_eeprom); break;
 case 3 : rut_encBUT(&priz_enc); break;
 break;
 }

 if(priz_prerus_rucka){
 if ((priznak_tlacidlo_rucky)&&(!blinkdisp)){
 if (rezim) stary_rezim = rezim;
 rezim = 0;
 nastav_rezim(rezim, res_eeprom);
 }
 if ((!priznak_tlacidlo_rucky)&&(!blinkdisp)){
 rezim = stary_rezim;
 nastav_rezim(rezim, res_eeprom);
 }
 priz_prerus_rucka = 0;
 povol_prerus(priz_enc);
 }

 if(blinkdisp){
 konver(rezim, res_eeprom, &lcd_result);
 display(&lcd_result);
 }
 else{
 konver(rezim, res_ad, &lcd_result);
 display(&lcd_result);
 }



 if (res_eeprom > res_ad){
 out_paj = 1;
 }
 else{
 out_paj = 0;
 }
}
}

u_short nastav_rezim(u_short rezim, u_short res_eeprom){

 res_eeprom = EEPROM_Read(rezim);
 return(res_eeprom);
}

u_short rut_encBUT(u_short *p_priz_enc){
 Delay_ms(500);
 if(in_encBUT){
 if(blinkdisp){
 eeprom_write(rezim, res_eeprom);
 blinkdisp = 0;
 spusti_tmr1 = 0;
 povol_prerus_tmr1 = 0;
 priz_prerus_tmr1 = 0;
 svietiLCD = 0;
 zapis = 1;
 }
 }
 else{
 blinkdisp = ~blinkdisp;
 if(blinkdisp){
 TMR1H = 0;
 TMR1L = 0;
 priz_prerus_tmr1 = 0;
 povol_prerus_tmr1 = 1;
 spusti_tmr1 = 1;
 }
 else{
 spusti_tmr1 = 0;
 povol_prerus_tmr1 = 0;
 priz_prerus_tmr1 = 0;
 TMR1H = 0;
 TMR1L = 0;
 svietiLCD = 0;
 zapis = 0;
 }
 }


 povol_prerus(&priz_enc);
}

u_short rut_encA(u_short *p_res_eeprom){
 if (!blinkdisp){
 rezim += 1;
 if (rezim > 3) {
 rezim = 0;
 }
 res_eeprom = EEPROM_Read(rezim);
 }
 else {
 res_eeprom += 5;
 konver(rezim, res_eeprom, &lcd_result);
 display(&lcd_result);
 }
 povol_prerus(priz_enc);
 return(rezim);
}

u_short rut_encB(u_short *p_res_eeprom){
 if (!blinkdisp){
 if (!rezim) {
 rezim = 3;
 }
 else{
 rezim -= 1;
 }
 res_eeprom = EEPROM_Read(rezim);
 }
 else {
 res_eeprom -= 5;
 konver(rezim, res_eeprom, &lcd_result);
 display(&lcd_result);
 }
 povol_prerus(priz_enc);
 return(rezim);
}

u_short konver(u_short rezim, u_short res_ad_eeprom, u_short lcd_result[]){
u_short temp = 0;
u_short temp0, res_temp;
unsigned int res_lcd;
 res_lcd = (res_ad_eeprom * prevod_lcd);
 res_lcd = res_lcd / 100;
 digit_sto = div(res_lcd, 100);
 sto = digit_sto.quot;
 res_lcd = res_lcd - (sto*100);
 digit_des = div(res_lcd, 10);
 des = digit_des.quot;
 jed = digit_des.rem;

 switch (rezim) {
 case 0: lcd_result[6] = 0x55; lcd_result[7] = 0x44; break;
 case 1: lcd_result[6] = 0x53; lcd_result[7] = 0x4D; break;
 case 2: lcd_result[6] = 0x4E; lcd_result[7] = 0x4F; break;
 case 3: lcd_result[6] = 0x48; lcd_result[7] = 0x49; break;
 }
 lcd_result[3] = 0xDF;
 lcd_result[4] = 0x43;
 if(!svietiLCD){
 lcd_result[5] = 0x20;
 }
 else{
 lcd_result[5] = 0xFD;
 }
 if(zapis) lcd_result[5] = 0x23;
 for (temp = 0; temp < 3; temp++){
 switch (temp) {
 case 0 : temp0 = sto; break;
 case 1 : temp0 = des; break;
 case 2 : temp0 = jed; break;
 }
 switch(temp0) {
 case 0 : lcd_result[temp] = 0x30; break;
 case 1 : lcd_result[temp] = 0x31; break;
 case 2 : lcd_result[temp] = 0x32; break;
 case 3 : lcd_result[temp] = 0x33; break;
 case 4 : lcd_result[temp] = 0x34; break;
 case 5 : lcd_result[temp] = 0x35; break;
 case 6 : lcd_result[temp] = 0x36; break;
 case 7 : lcd_result[temp] = 0x37; break;
 case 8 : lcd_result[temp] = 0x38; break;
 case 9 : lcd_result[temp] = 0x39; break;
 }
 }
 return (0);
}

void display(u_short lcd_result[]){
 nobusy_send_instr(0x02);
 for(i=0; i<8; i++){
 byte = lcd_result[i];
 nobusy_send_data(byte);
 if(i<7) nobusy_send_instr(0x06);
 }
}

u_short povol_prerus(u_short *p_priz_enc){
 priz_enc = 0;
 povol_prerus_rucka = 1;
 povol_prerus_enkoder = 1;
 return(priz_enc);
}
