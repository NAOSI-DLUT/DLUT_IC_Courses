#ifndef __I2C_H_
#define __I2C_H_
#include <reg52.h>
#include "MyDefine.h"

sbit SCL = P2 ^ 1;
sbit SDA = P2 ^ 0;

void I2cStart(void);
void I2cStop(void);
uint8_t I2cSendByte(uint8_t dat);
uint8_t I2cReadByte();
void At24c02Write(uint8_t addr, uint8_t dat);
uint8_t At24c02Read(uint8_t addr);

void write_eeprom(unsigned char add,unsigned char val);
unsigned char read_eeprom(unsigned char add);
void write_l_eeprom(unsigned char add,unsigned char *val,int num);
void read_l_eeprom(unsigned char add,unsigned char *dat,int num);

#endif
