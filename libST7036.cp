#line 1 "C:/aplikace/milan/mikroC PRO for PIC/Projects/pajka/libST7036.c"
#line 10 "C:/aplikace/milan/mikroC PRO for PIC/Projects/pajka/libST7036.c"
sbit lcd_RS at LATA1_bit;
sbit lcd_RW at LATA2_bit;
sbit lcd_E at LATA3_bit;
sbit lcd_busy at RC7_bit;
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
 nobusy_send_instr(0x31);
 nobusy_send_instr(0x31);

 nobusy_send_instr(0x14);
 nobusy_send_instr(0x51);
 nobusy_send_instr(0x6a);
 nobusy_send_instr(0x74);

 nobusy_send_instr(0x30);
 nobusy_send_instr(0x0c);
 nobusy_send_instr(0x01);
 Delay_ms(2);
 nobusy_send_instr(0x06);
}
