/*------settings------------------------------*/
sbit in_encA    at  RB7_bit;
sbit in_encBUT  at  RB6_bit;
sbit in_encB    at  RB5_bit;

sbit out_paj    at  RB3_bit;
sbit tlacidlo_rucky  at  RB2_bit;
sbit in_nap     at  RB1_bit;
sbit out_led    at  RB0_bit;

/*-Interrupt-rucka-----------*/
sbit povol_prerus_rucka at  INT2IE_bit;
sbit priz_prerus_rucka  at  INT2IF_bit;
/*-Interrupt-Enkoder-------*/
sbit povol_prerus_enkoder   at  RBIE_bit;
sbit priz_prerus_enkoder    at  RBIF_bit;
/*-Interrupt-Timer1--------*/
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
u_short  *p_rezim = &rezim;
u_short i, j, tmr_tmp, res_ad, res_eeprom, priz_enc;
u_short  *p_res_eeprom = &res_eeprom;
u_short  *p_priz_enc = &priz_enc;
u_short  lcd_result[8], temp_ad[3], sto, des, jed;
unsigned int temp_int_ad;
extern u_short byte;

void rut_encBUT(u_short *p_priz_enc);
u_short rut_encA(u_short rezim, u_short *p_res_eeprom);
u_short rut_encB(u_short rezim, u_short *p_res_eeprom);
u_short konver(u_short rezim, u_short res_ad_eeprom, u_short lcd_result[]);
void display(u_short lcd_result[]);
u_short nastav_rezim(u_short rezim, u_short res_eeprom);
//u_short povol_prerus(u_short *p_priz_enc);
void isr_portb(void);
void isr_tmr1(void);