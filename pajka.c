/* -----------------------------------------------------------------------
Compiler : mikroe
Processor : 18F252
MCLR - ON; XT oscil.
Tacq = 20 mikros
Hrot dava napatie 39 mikroV/C, pri zosilneni Au=270 je to 10.53 mV/C
Pri 100 *C je to 1.053 V co je po prevode AD - 54(0x36)
Prevodna konstanta medzi AD a *C je teda 100/54 = 1.85 C/bit.
 * Teploty budu -udrziav -UD -0  - 150*C - 81  - 0x51
 *              -SMD     -SM -1  - 280*C - 151 - 0x97
 *              -normal  -NO -2  - 300*C - 162 - 0xA2
 *              -vysoka  -VY -3  - 350*C - 189 - 0xBD
 *
 *
 *RA0 - I  -in_term  -vstup z termistoru
 *RA1 - O - RS
 *RA2 - o - RW
 *RA3 - O - E
 *RB0 - O - out_led
 *RB1 - I - in_nap
 *RB2 - I - tlacidlo_rucky
 *RB3 - O - out_paj
 *RB4 - I -
 *RB5 - I - in_encB
 *RB6 - I - in_encBUT
 *RB7 - I - in_encA
 *RC7 - I/O -Busy

LCD : EADOGM081B-A (ST7036)
-----------------------------------------------------------------------*/
#include "libST7036.h"
#include "pajka.h"
/*-----interrupt-----------------------------*/
//void interrupt(){         //SIGHANDLER(int_handler) 0x08
void isr_portb() iv 0x0008 ics ICS_AUTO {
    povol_prerus_rucka = 0;
    povol_prerus_enkoder = 0;
    Delay_ms(2);    //zakmity max 2ms pre enkoder a tlacidlo rucky
    if (in_encA)  priz_enc = 1;
    if (in_encB)  priz_enc = 2;
    //Delay_ms(10);    //zakmity max 10ms pre tlacidlo
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

/*------main----------------------------------*/
void main() {
    TRISA = 0b00000001;         
    TRISB = 0b11100110;
    TRISC = 0;
    PORTA = 0;
    PORTB = 0;
    PORTC = 0;
    INTCON = 0;
    RCON.IPEN = 1;      // interrupt priority enabled
    INTCON.GIEH = 1;   //high prior int enabled
    INTCON.GIEL = 1;   //low prior int enabled
    INTCON2.RBPU = 0;     //int pull-up
    INTCON2.RBIP = 1;   //portb high priority interrupt
/*---------ADC---------------------------*/
    ADCON0 = 0b00000001; //ADC On, AN0 - analog
    ADCON1 = 0b10001110; //AN0 analog, right just, 12 TaD, FOSC/8
    PIE1.ADIE = 0;      //AD polluje
/*--------External INT---Rucka----------*/
    //INT2 hrana  - polozenim rucky prejde vstup do 1
    INTCON2.INTEDG2 = 1;
    //INT priority low
    INTCON3.INT2IP = 0;
/*---------Timer1------------------------*/
    T1CON = 0b10110000; //16 bit operation, 1:8 prescaler, oscil disabled
    TMR1IP_bit = 0;     //low priority
/*-----Inicializ-premen-------------------*/
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
    /*Delay_ms(50);
    init();
    for (j=0; j<4 ; j++)    //!!!!iba raz zapisat udaje do EEprom
    {
        //EEPROM_Write(j, EEPROM_array[j]);
    }*/
    nastav_rezim(rezim, res_eeprom);   //pri zapnuti prejde do udrziav rezimu
while (1){
/* spocitam 3 posledne vysledky a aritmet priemer kvoli statistike pokial je log 1*/
    for(i=0; i<3; i++){
        //temp_int_ad = ADC_Read(0);
        temp_int_ad = 0x288;     //skuska - 952
        temp_int_ad >>= 2;       //posun o dva bity - delenie styrmi - 238
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

    if(priz_prerus_rucka){  //ak prislo prerusenie od tlacidla
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
    
/* ked prejde do log 0 */
    //while (!in_nap);        //pockaj nulu
    if (res_eeprom > res_ad){
        out_paj = 1;
    }
    else{
        out_paj = 0;
    }
}//while
}//main
/*--------subroutines----------------------------  */
u_short nastav_rezim(u_short rezim, u_short res_eeprom){
    //Delay_ms(50);    //pockam kym skoncia zakmity
    res_eeprom = EEPROM_Read(rezim);
    return(res_eeprom);
}

u_short rut_encBUT(u_short *p_priz_enc){
    Delay_ms(500);
    if(in_encBUT){             //ak je stlacenie dlhe
        if(blinkdisp){
            eeprom_write(rezim, res_eeprom);    //zapis hodnotu do eeprom
            blinkdisp = 0;  //hned aj vypni blikanie
            spusti_tmr1 = 0;    //zastav tmr1
            povol_prerus_tmr1 = 0;
            priz_prerus_tmr1 = 0;
            svietiLCD = 0;
            zapis = 1;
        }
    }
    else{                   //ak je stlacenie kratke
        blinkdisp = ~blinkdisp; //zapni/vypni blikanie
        if(blinkdisp){          //ak si zapol blikanie
            TMR1H = 0;
            TMR1L = 0;
            priz_prerus_tmr1 = 0;//spusti tmr1
            povol_prerus_tmr1 = 1;
            spusti_tmr1 = 1;
        }
        else{
            spusti_tmr1 = 0;    //zastav tmr1
            povol_prerus_tmr1 = 0;
            priz_prerus_tmr1 = 0;
            TMR1H = 0;
            TMR1L = 0;
            svietiLCD = 0;
            zapis = 0;
        }
    }
    //priz_enc = 0;
    //return(priz_enc);
    povol_prerus(&priz_enc);
}

u_short rut_encA(u_short *p_res_eeprom){
    if (!blinkdisp){    //ak neblika display
        rezim += 1;     //tak zmen rezim
        if (rezim > 3) {
              rezim = 0;
        }
        res_eeprom = EEPROM_Read(rezim);
    }
    else {              //ak blika tak zmen teplotu
        res_eeprom += 5;
        konver(rezim, res_eeprom, &lcd_result);
        display(&lcd_result);
    }
    povol_prerus(priz_enc);
    return(rezim);
}

u_short rut_encB(u_short *p_res_eeprom){
    if (!blinkdisp){        //a neblika display
        if (!rezim) {     //tak zmen rezim
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
/*  Cez switch nastavim pismena a cez cyklus for pre lcd_result nastavim prve tri cislice */
u_short konver(u_short rezim, u_short res_ad_eeprom, u_short lcd_result[]){
u_short temp = 0;
u_short temp0, res_temp;
unsigned int res_lcd;
    res_lcd = (res_ad_eeprom * prevod_lcd);
    res_lcd = res_lcd / 100; 
    digit_sto = div(res_lcd, 100);   //oddelim stovky
    sto = digit_sto.quot;
    res_lcd = res_lcd - (sto*100);
    digit_des = div(res_lcd, 10);    //oddelim desiatky
    des = digit_des.quot;
    jed = digit_des.rem;            //zostanu jednotky
/*---nastavujem pismena pre rezim-------*/
    switch (rezim) {
        case 0: lcd_result[6] = 0x55; lcd_result[7] = 0x44; break;  //UD - udrziav
        case 1: lcd_result[6] = 0x53; lcd_result[7] = 0x4D; break;  //SM - smd
        case 2: lcd_result[6] = 0x4E; lcd_result[7] = 0x4F; break;  //NO - normal
        case 3: lcd_result[6] = 0x48; lcd_result[7] = 0x49; break;  //HI - vysoka
    }
    lcd_result[3] = 0xDF;   //stupen z tabuliek graf. kontroleru
    lcd_result[4] = 0x43;   //C - celsia
    if(!svietiLCD){ //ak nie je nastaveny priznak tak prazdna medzera
        lcd_result[5] = 0x20;   //medzera
    }
    else{   //ak je priznak nastaveny tak znak <<
        lcd_result[5] = 0xFD;   //znak <<
    }
    if(zapis) lcd_result[5] = 0x23;   //znak zapisu #
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
    nobusy_send_instr(0x02);    //nastav na zaciatok displaya
    for(i=0; i<8; i++){
        byte = lcd_result[i];
        nobusy_send_data(byte);
        if(i<7) nobusy_send_instr(0x06);    //posun display - entry mode set
    }
}

u_short povol_prerus(u_short *p_priz_enc){
    priz_enc = 0;   //aby som zbytocne neskakal do rutiny a nemenil rezim
    povol_prerus_rucka = 1;
    povol_prerus_enkoder = 1; //potom povolim prerusenie
    return(priz_enc);
}
/*
void zapis_eeprom(u_short rezim, u_short res_eeprom){
    GIE_bit = 0;    //zakaz prerusenie pocas zapisu
    EEADR = rezim;
    EEDATA = res_eeprom;
    EEPGD_bit = 0;
    CFGS_bit = 0;
    WREN_bit = 1;
    EECON2 = 0x55;
    EECON2 = 0xaa;
    WR_bit = 1;
    WREN_bit = 0;
    GIE_bit = 1;
    blinkdisp = 0;  //zastav blikanie
} */