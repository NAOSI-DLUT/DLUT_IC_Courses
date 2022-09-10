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

sbit LSA = P2 ^ 0;
sbit LSB = P2 ^ 1;
sbit LSC = P2 ^ 2;

uint8_t code smgduan[17] = { 0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,
                    0x7f,0x6f,0x77,0x7c,0x39,0x5e,0x79,0x71 };


void delay_10us(uint16_t i);
void delay_ms(uint16_t i);

/**
 * @brief seg-code display
 */
void seg_display(uint8_t seg_bit_select, uint8_t seg_num_show)
{
    switch (seg_bit_select) //decode
    {
    case(0):
        LSA = 0;
        LSB = 0;
        LSC = 0;
        break; //bit 0
    case(1):
        LSA = 1;
        LSB = 0;
        LSC = 0;
        break;//bit 1
    case(2):
        LSA = 0;
        LSB = 1;
        LSC = 0;
        break; //bit2
    case(3):
        LSA = 1;
        LSB = 1;
        LSC = 0;
        break; //bit3
    case(4):
        LSA = 0;
        LSB = 0;
        LSC = 1;
        break; //bit4
    case(5):
        LSA = 1;
        LSB = 0;
        LSC = 1;
        break; //bit5
    case(6):
        LSA = 0;
        LSB = 1;
        LSC = 1;
        break; //bit6
    case(7):
        LSA = 1;
        LSB = 1;
        LSC = 1;
        break; //bit7	
    }
    P0 = smgduan[seg_num_show]; //seg-code sending
    delay_ms(1); //scan
    P0 = 0x00;
}

int main(void)
{
    uint8_t r = 0;

    while (1)
    {
        seg_display(0, 2);
        for (r = 1;r < 8;r++)
        {
            seg_display(r, 3);
        }
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
