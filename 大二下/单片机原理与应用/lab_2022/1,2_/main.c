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
uint8_t COUNT_DONE = 0;

sbit LED = P0 ^ 0;
sbit BEEP = P1 ^ 5;

void delay_10us(uint16_t i);
void delay_ms(uint16_t i);

void main()
{
    uint16_t i = 0;
    uint16_t j = 0;

    LED = 0;
    BEEP = 0;

    TMOD |= 0X01; //TIM0 mode

    TH0 = 0XFC; //1ms
    TL0 = 0X18;

    ET0 = 1; //enable TIM0 interrupt

    EA = 1; //global interrupt enable
    TIM0_DISABLE;


    while (1)
    {
        for (i = 0; i < 4; i++)
        {
            LED = ~LED;
            delay_ms(250);
        }

        TIM0_ENABLE;
        while (COUNT_DONE != 1)
        {
            BEEP = ~BEEP;
            delay_10us(100);
        }
        COUNT_DONE = 0;
        BEEP = 0;

        delay_ms(1000);

        for (i = 0; i < 4; i++)
        {
            LED = ~LED;
            delay_ms(250);
        }

        TIM0_ENABLE;
        while (COUNT_DONE != 1)
        {
            BEEP = ~BEEP;
            delay_10us(1);
        }
        COUNT_DONE = 0;
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
    TH0 = 0XFC; //1ms
    TL0 = 0X18;

    count++;
    if (count >= 1000) //1s
    {
        count = 0;
        COUNT_DONE = 1;
        TIM0_DISABLE;
    }
}
