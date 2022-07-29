const int spi_CK = 10;
const int spi_MI = 11;
const int spi_CS = 9;

uint16_t spi_MCP3201_transfer(void){
  /*
   * returns 12 bit data from device
   * assumes:
   * spi_CK = clock pin
   * spi_MI = master input pin
   * spi_CS = device select pin
   */

  noInterrupts();
  uint16_t retVal = 0;

  digitalWrite(spi_CK, LOW);
  digitalWrite(spi_CS, LOW); // select chip
  digitalWrite(spi_CK, HIGH); // 2 clocks for sample time
  //delayMicroseconds(1); // only needed for fast MCU
  digitalWrite(spi_CK, LOW);
  //delayMicroseconds(1);
  digitalWrite(spi_CK, HIGH);
  //delayMicroseconds(1);
  digitalWrite(spi_CK, LOW); // end sample
  //delayMicroseconds(1);
  digitalWrite(spi_CK, HIGH); // null bit
  //delayMicroseconds(1);
  digitalWrite(spi_CK, LOW);
  //delayMicroseconds(1);

  for(uint8_t i=0;i<12;i++) {
    digitalWrite(spi_CK, HIGH);
  //delayMicroseconds(1);
    retVal <<= 1;
    retVal |= (digitalRead(spi_MI) & 0x1);
    digitalWrite(spi_CK, LOW);
  //delayMicroseconds(1);
  }// for

  digitalWrite(spi_CS,HIGH); // deselect chip
  interrupts();
  return retVal;
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(spi_CK, OUTPUT);
  pinMode(spi_MI, INPUT);
  pinMode(spi_CS, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  delay(500);
  uint16_t value = spi_MCP3201_transfer();
  Serial.println(value);
}
