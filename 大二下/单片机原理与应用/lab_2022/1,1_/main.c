#include "reg52.h"

typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
typedef unsigned long uint32_t;

typedef signed char int8_t;
typedef signed int int16_t;
typedef signed long int32_t;

#define EXT0_VECTOR 0  /* 0x03 external interrupt 0 */
#define TIM0_VECTOR 1  /* 0x0b timer 0 */
#define EXT1_VECTOR 2  /* 0x13 external interrupt 1 */
#define TIM1_VECTOR 3  /* 0x1b timer 1 */
#define UART0_VECTOR 4 /* 0x23 serial port 0 */

#define TIM0_ENABLE TR0=1
#define TIM0_DISABLE TR0=0

uint16_t count = 0;

sbit LED = P0 ^ 0;
sbit BEEP = P1 ^ 5;

void delay_10us(uint16_t i);
void delay_ms(uint16_t i);

void main()
{
    uint16_t i = 0;
    LED = 0;
    BEEP = 0;

    while (1)
    {
        for (i = 0;i < 6;i++)
        {
            LED = ~LED;
            delay_ms(400);
        }

        for (i = 0;i < 500;i++)
        {
            BEEP = ~BEEP;
            delay_10us(100);
        }
        BEEP = 0;
    }
}

void delay_10us(uint16_t i)
{
    while (i--);
}

void delay_ms(uint16_t i)
{
    while (i--)
    {
        delay_10us(100);
    }
}

void TIM0_InterruptHandler() interrupt 1
{
	TH0=0XFC; //1ms
	TL0=0X18;

	count++;
	if(count>=500) //0.5s
	{
		count=0;
		TIM0_DISABLE;
	}	
}
