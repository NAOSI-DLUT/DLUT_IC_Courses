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

/* System Soft-Tick */
uint32_t systick = 0; //for seg-code
uint32_t flash_cnt = 0;
uint32_t pwm_cnt = 0;
uint32_t key_cnt = 0;

/* FLAGs */
uint8_t BUTTON_DELAY_FLAG = 0;
uint8_t FLASH_FLAG = 0;
uint8_t SET_BIT_FLAG = 0;
uint8_t NUM_PLUS_FLAG = 0;
uint8_t SHOW_DELAY_FLAG = 0;
uint8_t BEEP_FLAG = 0;

enum {
    IDLE = 0,
    READY,
    CHECK_DOUBLE_CLICK,
    SHORT_PRESS, // <500ms
    LONG_PRESS, // >1000ms 
    DOUBLE_CLICK, // 500~900ms space
};
uint8_t BUTTON_STATUS = IDLE;

enum {
    MACHINE_STOP = 0,
    MACHINE_RUN,
    MACHINE_PAUSE,
};
uint8_t MACHINE_STATUS = MACHINE_STOP;

/* Data Control */
uint8_t SHOW_ONE_NUM = 0;
uint8_t SHOW_TEN_NUM = 0;
uint8_t SHOW_HUN_NUM = 0;

/* IO pins */
sbit LSA = P2 ^ 0;
sbit LSB = P2 ^ 1;
sbit LSC = P2 ^ 2;

sbit BUTTON = P3 ^ 2;
sbit BEEP = P1 ^ 1;

/* Seg-Code LUT */
uint8_t code smgduan[17] = { 0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,
                    0x7f,0x6f,0x77,0x7c,0x39,0x5e,0x79,0x71 };

void BSP_Init(void);
void seg_display(uint8_t seg_bit_select, uint8_t seg_num_show);
void seg_clear(uint8_t seg_bit_select);


/**
 * @brief flash_cnt to control seg-code flashing
 */
void SoftTimer_Flash(void)
{
    static uint32_t show_delay_cnt = 0;
    static uint32_t flash_time = 0;

    switch (MACHINE_STATUS)
    {
    case MACHINE_RUN:
        if (flash_cnt >= 500) //500ms
        {
            flash_cnt = 0;
            if (SHOW_DELAY_FLAG)
            {
                show_delay_cnt++;
                FLASH_FLAG = 0;
                if (show_delay_cnt == 1) //0.5s
                {
                    BEEP_FLAG = 0;
                }

                if (show_delay_cnt == 3) //1.5s
                {
                    SHOW_DELAY_FLAG = 0;
                    BEEP_FLAG = 0;
                    show_delay_cnt = 0;
                }
            }
            else
            {
                FLASH_FLAG = ~FLASH_FLAG;
                flash_time++;
            }
        }

        if (flash_time >= 6)
        {
            flash_time = 0;
            NUM_PLUS_FLAG = 1;
            SHOW_DELAY_FLAG = 1;
            BEEP_FLAG = 1;
        }
        break;
    case MACHINE_PAUSE:
        break;
    case MACHINE_STOP:
        break;
    default:
        break;
    }

}

/**
 * @brief control abstract button press activity
 */
void Task_ButtonControl(void)
{
    switch (BUTTON_STATUS)
    {
    case SHORT_PRESS:
        BUTTON_STATUS = IDLE;
        switch (MACHINE_STATUS)
        {
        case MACHINE_PAUSE:
            MACHINE_STATUS = MACHINE_RUN;
            break;
        case MACHINE_RUN:
            MACHINE_STATUS = MACHINE_PAUSE;
            break;
        default:
            break;
        }
        break;
    case LONG_PRESS:
        BUTTON_STATUS = IDLE;
        switch (MACHINE_STATUS)
        {
        case MACHINE_STOP:
            TIM0_ENABLE;
            MACHINE_STATUS = MACHINE_RUN;
            break;
        case MACHINE_RUN:
            FLASH_FLAG = 0;
            SET_BIT_FLAG = 0;
            NUM_PLUS_FLAG = 0;
            SHOW_DELAY_FLAG = 0;
            BEEP_FLAG = 0;
            TIM0_DISABLE;
            MACHINE_STATUS = MACHINE_STOP;
            break;
        case MACHINE_PAUSE:
            FLASH_FLAG = 0;
            SET_BIT_FLAG = 0;
            NUM_PLUS_FLAG = 0;
            SHOW_DELAY_FLAG = 0;
            BEEP_FLAG = 0;
            TIM0_DISABLE;
            MACHINE_STATUS = MACHINE_STOP;
            break;
        default:
            break;
        }
        break;
    case DOUBLE_CLICK:
        BUTTON_STATUS = IDLE;
        switch (MACHINE_STATUS)
        {
        case MACHINE_RUN:
            SET_BIT_FLAG++;
            if (SET_BIT_FLAG > 2)
            {
                SET_BIT_FLAG = 0;
            }
            break;
        default:
            break;
        }
        break;
    default:
        break;
    }
}

/**
 * @brief analysis button long press and short press
 */
void Task_ButtonDecode(void)
{
    switch (BUTTON_STATUS)
    {
    case IDLE: //debounce
        if (key_cnt >= 10) //10ms
        {
            key_cnt = 0;
            TIM1_DISABLE;
            if (BUTTON == 0) //we can sure button has been down
            {
                BUTTON_STATUS = READY; //press time > 10ms, valid press
                TIM1_ENABLE;
            }
            else
            {
                BUTTON_STATUS = IDLE; //invalid press
            }
        }
        break;
    case READY:
        if ((key_cnt <= 300) && (BUTTON == 1)) //button press a bit and up
        {
            key_cnt = 0;
            TIM1_DISABLE;
            BUTTON_STATUS = CHECK_DOUBLE_CLICK;
            TIM1_ENABLE;
        }
        else if ((key_cnt >= 1000) && (BUTTON == 0)) //long press > 1s
        {
            key_cnt = 0;
            TIM1_DISABLE;
            BUTTON_STATUS = LONG_PRESS;
        }
        break;
    case CHECK_DOUBLE_CLICK:
        if ((key_cnt >= 400) && (BUTTON == 1)) //300+400 == 700
        {
            key_cnt = 0;
            TIM1_DISABLE;
            BUTTON_STATUS = SHORT_PRESS;
        }
        else if (BUTTON == 0)
        {
            key_cnt = 0;
            TIM1_DISABLE;
            BUTTON_STATUS = DOUBLE_CLICK;
        }
        break;
    default:
        break;
    }
}

/**
 * @brief Seg-code display
 */
void Task_Display(void)
{
    switch (MACHINE_STATUS)
    {
    case MACHINE_STOP:
        seg_clear(0);
        seg_clear(1);
        seg_clear(2);
        seg_clear(3);
        seg_clear(4);
        seg_clear(5);
        seg_clear(6);
        seg_clear(7);
        break;
    case MACHINE_PAUSE:
        switch (systick % 8)
        {
        case 0:
            seg_display(0, SHOW_HUN_NUM);
            break;
        case 1:
            seg_display(1, SHOW_TEN_NUM);
            break;
        case 2:
            seg_display(2, SHOW_ONE_NUM);
            break;
        case 3:
            seg_display(3, 0);
            break;
        case 4:
            seg_display(4, 0);
            break;
        case 5:
            seg_display(5, 0);
            break;
        case 6:
            seg_display(6, 0);
            break;
        case 7:
            seg_display(7, 0);
            break;
        default:
            seg_display(7, 0);
            break;
        }
        break;
    case MACHINE_RUN:
        switch (systick % 8)
        {
        case 0:
            if ((FLASH_FLAG) && (SET_BIT_FLAG == 2))
            {
                seg_clear(0);
            }
            else
            {
                seg_display(0, SHOW_HUN_NUM);
            }
            break;
        case 1:
            if ((FLASH_FLAG) && (SET_BIT_FLAG == 1))
            {
                seg_clear(1);
            }
            else
            {
                seg_display(1, SHOW_TEN_NUM);
            }
            break;
        case 2:
            if ((FLASH_FLAG) && (SET_BIT_FLAG == 0))
            {
                seg_clear(2);
            }
            else
            {
                seg_display(2, SHOW_ONE_NUM);
            }
            break;
        case 3:
            seg_display(3, 0);
            break;
        case 4:
            seg_display(4, 0);
            break;
        case 5:
            seg_display(5, 0);
            break;
        case 6:
            seg_display(6, 0);
            break;
        case 7:
            seg_display(7, 0);
            break;
        default:
            seg_display(7, 0);
            break;
        }
    default:
        break;
    }
}

/**
 * @brief generate PMW
 */
void Task_BeepControl(void)
{
    if (MACHINE_STATUS == MACHINE_RUN)
    {
        if (BEEP_FLAG)
        {
            if (pwm_cnt % 2 == 0)
                BEEP = 1;
            else
                BEEP = 0;
        }
    }
    else
    {
        BEEP = 0;
    }
}

/**
 * @brief calculate the number
 */
void App_NumControl(void)
{
    switch (MACHINE_STATUS)
    {
    case MACHINE_RUN:
        if (NUM_PLUS_FLAG)
        {
            NUM_PLUS_FLAG = 0;

            if (SET_BIT_FLAG == 0)
            {
                SHOW_ONE_NUM++;
            }
            else if (SET_BIT_FLAG == 1)
            {
                SHOW_TEN_NUM++;
            }
            else if (SET_BIT_FLAG == 2)
            {
                SHOW_HUN_NUM++;
            }

            if (SHOW_ONE_NUM > 9)
            {
                SHOW_ONE_NUM = 0;
                SHOW_TEN_NUM++;
            }
            else if (SHOW_TEN_NUM > 9)
            {
                SHOW_TEN_NUM = 0;
                SHOW_HUN_NUM++;
            }
            else if (SHOW_HUN_NUM > 9)
            {
                SHOW_HUN_NUM = 0;
            }
        }
        break;
    case MACHINE_STOP:
        SHOW_ONE_NUM = 0;
        SHOW_TEN_NUM = 0;
        SHOW_HUN_NUM = 0;
        break;
    default:
        break;
    }
}

int main(void)
{
    BSP_Init();

    while (1)
    {
        /* soft-timers */
        SoftTimer_Flash();

        /* tasks */
        Task_Display();
        Task_ButtonDecode();
        Task_ButtonControl();
        Task_BeepControl();

        /* software application */
        App_NumControl();
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
    TIM0_DISABLE; //!DISABLE

    /* setup TIM1 */
    TMOD |= 0X10; //function select
    TH1 = 0XFC; //T=1ms
    TL1 = 0X18;

    IT_TIM1_ENABLE;
    TIM1_DISABLE; //!DISABLE

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

/**
 * @brief seg-code clear
 */
void seg_clear(uint8_t seg_bit_select)
{
    P0 = 0x00; //seg-code clear
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

void Int0_IRQHandler() interrupt EXT0_VECTOR
{
    TIM1_ENABLE;
}

void TIM0_IRQHandler() interrupt TIM0_VECTOR
{
    TH0 = 0xFC; //1ms
    TL0 = 0x18;

    systick++;
    flash_cnt++;
    pwm_cnt++;
}

void TIM1_IRQHandler() interrupt TIM1_VECTOR
{
    TH1 = 0XFC; //1ms
    TL1 = 0X18;

    key_cnt++;
}
