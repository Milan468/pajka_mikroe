/*
    Ak posielas adresu do AC :
        CGRAM(adresa) - RS a RW = 0 , DB7 = 0 , DB6 = 1 ostatne je adresa
        DDRAM(adresa) - RS a RW = 0, DB7 = 1 ostatne je adresa
    Ak posielas data a AC sa inkrementuje automaticky:
        DDRAM(data) - RS = 1, RW = 0 a DBx su data podla tabulky
    Ak tetujes BUSY:
        BUSY(DB7) - RS = 0, RW = 1 a DB7 je testovany BUSY
*/
sbit lcd_RS at  LATA1_bit;
sbit lcd_RW at  LATA2_bit;
sbit lcd_E  at  LATA3_bit;
sbit lcd_busy   at RC7_bit;
sbit lcd_busy_dir at TRISC7_bit;
unsigned char byte; 

void nobusy_send_instr(unsigned char byte){
        lcd_RS = 0;
        lcd_RW = 0;
        lcd_E = 1;
        LATC = byte;
        lcd_E = 0;
        Delay_us(100);        
}

void nobusy_send_data(unsigned char byte){
        lcd_RS = 1;
        lcd_RW = 0;
        lcd_E = 1;
        LATC = byte;
        lcd_E = 0;
        Delay_us(100);    
}

void init(void){
        Delay_ms(40);
        nobusy_send_instr(0x31);     //8bit, 1 line, 5*8 font, instr. table 1
        nobusy_send_instr(0x31);        //8bit, 1 line, 5*8 font, instr. table 0
//-----------------------------------------------
        nobusy_send_instr(0x14);        //set bias
        nobusy_send_instr(0x51);        //power, icon off, booster o
        nobusy_send_instr(0x6a);        //set follower
        nobusy_send_instr(0x74);        //set contrast
//------------------------------------------------
        nobusy_send_instr(0x30);        //8bit, 1 line, 5*8 font, instr. table 0
        nobusy_send_instr(0x0c);       //display on, cursor off
        nobusy_send_instr(0x01);      //clear display
        Delay_ms(2);
        nobusy_send_instr(0x06);      //entry mode, autoincrement
}

/*
void busy_send_instr(unsigned char byte){
        lcd_busy_dir = 1;   //vstup BUSY
        lcd_RS = 0;
        lcd_RW = 1;
        while(lcd_busy);
        lcd_busy_dir = 0;   //BUSY je datovy vystup
        lcd_RW = 0;
        lcd_E = 1;
        LATC = byte;
        lcd_E = 0;
        lcd_busy_dir = 0;
        Delay_us(100);
}
*/