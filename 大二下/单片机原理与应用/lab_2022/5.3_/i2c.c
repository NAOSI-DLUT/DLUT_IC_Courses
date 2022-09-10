#include"i2c.h"
#include "intrins.h"
#include "MyDefine.h"

 /**
  * @brief delay for us
  */
void I2cDelay(uint8_t i)
{
	do
	{
		_nop_();
	} while (i--);
}

/**
 * @brief long delay
 */
void I2cLongDelay(uint8_t t)
{
	uint8_t i;
	while (t--)
	{
		for (i = 0;i < 112;i++);
	}
}

/**
 * @brief start i2c transmission
 */
void I2cStart(void)
{
	SDA = 1;
	SCL = 1;
	I2cDelay(5); //setup time > 4.7us
	SDA = 0;
	I2cDelay(5); //hold time > 4us
	SCL = 0;
}

/**
 * @brief stop i2c transmission
 */
void I2cStop(void)
{
	SDA = 0;
	SCL = 1;
	I2cDelay(5); //setup time > 4.7us
	SDA = 1;
	I2cDelay(5);
}

/**
 * @brief send i2c ack
 * @param  ackbit 0:ack; 1:no ack
 */
void I2cSendAck(uint8_t ackbit)
{
	SCL = 0;
	SDA = ackbit;
	I2cDelay(5);
	SCL = 1;
	I2cDelay(5);
	SCL = 0;
	SDA = 1;
	I2cDelay(5);
}

/**
 * @brief receive i2c ack
 * @return uint8_t is ack?
 */
uint8_t I2cWaitAck(void)
{
	uint8_t ack;

	SCL = 1;
	I2cDelay(5);
	ack = SDA;
	SCL = 0;
	I2cDelay(5);
	return ack;
}

/**
 * @brief send one byte via i2c
 * @param  dat              data to send
 * @return uint8_t 1:success 0:fail
 */
uint8_t I2cSendByte(uint8_t dat)
{
	uint8_t i = 0;

	for (i = 0; i < 8; i++)
	{
		SCL = 0;
		I2cDelay(5);
		if (dat & 0x80)
		{
			SDA = 1;
		}
		else
		{
			SDA = 0;
		}
		I2cDelay(5);
		SCL = 1;
		dat <<= 1;
		I2cDelay(5);
	}
	SCL = 0;

	return 1;
}

/**
 * @brief read one byte via i2c
 * @return uint8_t read data
 */
uint8_t I2cReadByte(void)
{
	uint8_t i = 0;
	uint8_t dat = 0;

	SDA = 1;
	I2cDelay(5);
	for (i = 0;i < 8;i++) //recv 8 byte
	{
		SCL = 1;
		I2cDelay(5);
		dat <<= 1;
		if (SDA)
		{
			dat |= 0x01;
		}
		SCL = 0;
		I2cDelay(5);
	}
	return dat;
}

/**
 * @brief write one byte to w24c02
 * @param  addr             address to write
 * @param  dat              data to write
 */
void At24c02Write(uint8_t addr, uint8_t dat)
{
	I2cStart();
	I2cSendByte(0xA0); //send w24c02 addr
	I2cWaitAck();
	I2cSendByte(addr); //send reg addr
	I2cWaitAck();
	I2cSendByte(dat); //send data
	I2cWaitAck();
	I2cStop();
	I2cLongDelay(10);
}

/**
 * @brief read one byte from w24c02
 * @param  addr             reg addr
 * @return uint8_t read data
 */
uint8_t At24c02Read(uint8_t addr)
{
	uint8_t num;
	I2cStart();
	I2cSendByte(0xA0); //send master addr
	I2cWaitAck();
	I2cSendByte(addr); //send reg addr
	I2cWaitAck();

	I2cStart();
	I2cSendByte(0xA1); //send slave(w24c02) addr
	I2cWaitAck();
	num = I2cReadByte(); //read data
	I2cSendAck(1);
	I2cStop();
	return num;
}

void At24c02Write_Array(uint8_t addr, uint8_t* val, int16_t num)
{
	I2cStart();
	I2cSendByte(0xA0);
	I2cWaitAck();
	I2cSendByte(addr);
	I2cWaitAck();

	while (num--)
	{
		I2cSendByte(*val++);
		I2cWaitAck();
	}
	I2cStop();
	I2cLongDelay(10);
}

void At24c02Read_Array(unsigned char addr, unsigned char* dat, int num)
{
	I2cStart();
	I2cSendByte(0xA0);
	I2cWaitAck();
	I2cSendByte(addr);
	I2cWaitAck();

	I2cStart();
	I2cSendByte(0xA1);
	I2cWaitAck();
	while (num--)
	{
		*dat = I2cReadByte();
		if (num)
		{
			I2cWaitAck();
		}
	}
	I2cStop();
}
