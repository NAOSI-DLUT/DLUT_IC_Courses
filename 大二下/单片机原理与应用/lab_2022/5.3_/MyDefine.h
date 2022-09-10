#ifndef __MY_DEFINE_H
#define __MY_DEFINE_H

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

#define IT_UART_RX_ENABLE ES=1
#define IT_UART_RX_DISABLE ES=0

#define UART_RX_IT_FLAG_CLEAR RI=0
#define UART_TX_FLAG_CLEAR TI=0

#endif
