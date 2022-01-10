#include<stdio.h>
int main()
{ 
float p=9.43;
int j=0;                                      /*float 占四个字节，double占8个*/
printf("%8.2f\n",p);
printf("%-8.2f\n",p);                                   /*前面那个所谓的符号代表左对齐*/
char *a[3]={"ABCD","bcdf","ACDS"};                    /*字符串数组只有这么定义才是合法的*/
puts(a[1]);
putchar(*a[1]);
printf("\n");
int i=0;
for(j=0;j<=10;j++)                                     /*这一块内容主要是分析break和continue的区别，break直接跳出当前所在循环，一般不能跳出多次循环*/
{
	i++;
	break;
}
printf("%d\n",i);
i=0;
for(j=0;j<=10;j++)                                    /*continue是指回到循环判断时，但是在本例中continue并不会造成死循环，因为j++可以被执行*/                            
{
continue;
	i++;
}
printf("i=%d\n",i);
printf("j=%d\n",j);
return 0;
}
