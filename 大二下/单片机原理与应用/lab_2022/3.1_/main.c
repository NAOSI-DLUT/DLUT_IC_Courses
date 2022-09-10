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

#define GLOBAL_INT_ENABLE EA=1
#define GLOBAL_INT_DISABLE EA=0
#define INT0_ENABLE EX0=1
#define INT0_DISABLE EX0=0
#define INT1_ENABLE ET1=1
#define INT1_DISABLE ET1=0

#define TIM0_ENABLE TR0=1
#define TIM0_DISABLE TR0=0
#define IT_TIM0_ENABLE ET0=1
#define IT_TIM0_DISABLE ET0=0

#define TIM1_ENABLE TR1=1
#define TIM1_DISABLE TR1=0
#define IT_TIM1_ENABLE ET1=1
#define IT_TIM1_DISABLE ET1=0

uint8_t BUTTON_DELAY_FLAG = 0;
uint8_t START_FLAG = 0;

uint32_t systick = 0;

sbit LSA = P2 ^ 0;
sbit LSB = P2 ^ 1;
sbit LSC = P2 ^ 2;

sbit BUTTON = P3 ^ 2;
sbit BEEP = P1 ^ 1;

uint8_t code smgduan[17] = { 0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,
                    0x7f,0x6f,0x77,0x7c,0x39,0x5e,0x79,0x71 };

void seg_display(uint8_t seg_bit_select, uint8_t seg_num_show);
void BSP_Init(void);

void regular_display(void)
{
    switch (systick)
    {
    case 0:
        seg_display(0, 0);
        break;
    case 1:
        seg_display(1, 1);
        break;
    case 2:
        seg_display(2, 2);
        break;
    case 3:
        seg_display(3, 3);
        break;
    case 4:
        seg_display(4, 4);
        break;
    case 5:
        seg_display(5, 5);
        break;
    case 6:
        seg_display(6, 6);
        break;
    case 7:
        seg_display(7, 7);
        break;
    default:
        seg_display(7, 7);
        break;
    }
}

int main(void)
{
    BSP_Init();

    while (1)
    {
        if (BUTTON_DELAY_FLAG)
        {
            TIM1_DISABLE;
            if (BUTTON == 0)
            {
                START_FLAG = 1;
                TIM0_ENABLE;
            }
        }

        while (START_FLAG)
        {
            regular_display();
        }
    }
}

void BSP_Init(void)
{
    GLOBAL_INT_ENABLE;

    /* setup TIM0 */
    TMOD |= 0x01; //function select
    TH0 = 0xFC; //T=1ms
    TL0 = 0x18;

    IT_TIM0_ENABLE;
    TIM0_DISABLE;

    /* setup TIM1 */
    TMOD |= 0X10; //function select
    TH1 = 0XFC; //T=1ms
    TL1 = 0X18;

    IT_TIM1_ENABLE;
    TIM1_DISABLE;

    /* setup INT0 */
    IT0 = 1; //negedge trigger
    INT0_ENABLE;
}

/**
 * @brief seg-code display
 */
void seg_display(uint8_t seg_bit_select, uint8_t seg_num_show)
{
    P0 = smgduan[seg_num_show]; //seg-code sending
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
}

void Int0_IRQHandler() interrupt 0
{
    TIM1_ENABLE;
}

void TIM0_IRQHandler() interrupt TIM0_VECTOR
{
    TH0 = 0xFC; //1ms
    TL0 = 0x18;

    systick++;
    if (systick > 7)
    {
        systick = 0;
    }
}

void TIM1_IRQHandler() interrupt TIM1_VECTOR
{
    static uint8_t counter = 0;

    TH1 = 0XFC; //1ms
    TL1 = 0X18;

    counter++;
    if (counter >= 10) //10ms
    {
        counter = 0;
        BUTTON_DELAY_FLAG = 1;
    }
}