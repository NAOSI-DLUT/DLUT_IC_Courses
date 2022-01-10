#include <stdio.h> 
#include <string.h>
#include <conio.h>      /*getch的头文件*/
int main()
{
	char c,d[20];
	int i;
	printf("please input a sentence\n");
	for(i=0;i<5;i++)                         /*利用getchar进行相应的输入*/
	{
	c=getchar();
   /*c=getch();*/
	printf("%c",c);                        /*两个语句是等价的*/
	/*putchar(c);*/	                         /*表面上看，似乎是c存储了一串字母。如果想要把之前的字母全部存起来，必须要用数组*/ 
	}
	printf("\n");
	printf("%c",c);                     /*仔细一看，才发现只有最后的字符保存在c中*/
	return 0;
}
