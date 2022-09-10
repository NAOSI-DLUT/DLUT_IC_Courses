#include "reg52.h"
#include "MyDefine.h"
#include "i2c.h"
#include <stdio.h>

#define UART_FIFO_SIZE 12

 /* FLAGs */
uint8_t FIFO_FULL_FLAG = 0;
uint8_t FIFO_EMPTY_FLAG = 0;

uint8_t EEPROM_WRITE_FLAG = 0;
uint8_t EEPROM_READ_FLAG = 0;

/* Data Control */
uint8_t dev_null = 0;
uint8_t FIFO_POINT = 0;
uint8_t UART_FIFO[UART_FIFO_SIZE] = { 0 };

uint8_t read_data[12] = { 0 };

void UART_Send_Byte(uint8_t dat);
void Uart_Send_String(uint8_t* dat, uint8_t size);
void UART0_Init(void);
void BSP_Init(void);

//!< STDIO PRINTF SUPPORT
/**
 * @brief redirect printf() function to UART0 output
 * @param  c                putchar data
 * @return char putchar res
 */
char putchar(char c)
{
    if (c == '\n')
    {
        SBUF = '\r';
        while (!TI);
        UART_TX_FLAG_CLEAR;
    }
    SBUF = c;
    while (!TI);
    UART_TX_FLAG_CLEAR;
    return c;
}
//!< STDIO PRINTF SUPPORT


void WriteData(void)
{
    uint8_t i = 0;
    if (EEPROM_WRITE_FLAG)
    {
        EEPROM_WRITE_FLAG = 0;
        for (i = 0;i < 12;i++)
        {
            At24c02Write(i, UART_FIFO[i]);
        }
    }
}

int main(void)
{
    uint8_t i = 0;
    BSP_Init();

    printf("EEPROM: 24C02 on Board\r\n");
    printf("Reading last EEPROM data...\r\n");

    for (i = 0;i < 12;i++)
    {
        read_data[i] = At24c02Read(i);
    }

    printf("Last EEPROM data: ");
    Uart_Send_String(read_data, 12); //send last eeprom data via UART0
    printf("\r\n");

    while (1)
    {
        WriteData();
    }
}

void UART0_Init(void)
{
    SCON = 0X50;
    PCON = 0X80; //double baud rate

    TMOD |= 0X20; //function select:UART
    TH1 = 0XF3; //baud rate:4800
    TL1 = 0XF3;

    IT_UART_RX_ENABLE;
    TIM1_ENABLE; //!ENABLE
}

void BSP_Init(void)
{
    GLOBAL_INT_ENABLE;

    /* setup UART0 */
    UART0_Init();

    printf("UART0 init done\r\n");
    printf("STC51 Startup\r\n");
}


/**
 * @brief send one byte via UART0
 * @param  data             MyParamdoc
 */
void UART_Send_Byte(uint8_t dat)
{
    SBUF = dat;
    while (!TI); //wait for transmit complete
    UART_TX_FLAG_CLEAR;
}

/**
 * @brief send one string via UART0
 * @param  data             send buffer
 * @param  size             buffer size
 */
void Uart_Send_String(uint8_t* dat, uint8_t size)
{
    uint8_t i = 0;
    for (i = 0;i < size;i++)
    {
        UART_Send_Byte(dat[i]);
    }
}

void UART0_IRQHandler(void) interrupt UART0_VECTOR
{
    if (RI == 1)
    {
        if (FIFO_POINT < UART_FIFO_SIZE)
        {
            UART_FIFO[FIFO_POINT++] = SBUF; //read data from UART0
        }
        else if (FIFO_POINT == UART_FIFO_SIZE)
        {
            FIFO_POINT = UART_FIFO_SIZE + 1;
            FIFO_FULL_FLAG = 1; //FIFO full
            EEPROM_WRITE_FLAG = 1; //write first 12 bytes to eeprom
        }
        else if (FIFO_POINT > UART_FIFO_SIZE)
        {
            dev_null = SBUF; //invalid data
        }

        UART_RX_IT_FLAG_CLEAR;
    }
}
