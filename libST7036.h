void init();
void nobusy_send_instr(unsigned char byte);
void nobusy_send_data(unsigned char byte);
/*
  *nekontroloujem busy lebo mam dlhy delay na konci instrukcie
void busy_send_instr(unsigned char byte);
*/