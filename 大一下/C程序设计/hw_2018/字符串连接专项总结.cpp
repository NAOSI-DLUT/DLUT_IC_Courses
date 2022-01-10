#include <stdio.h> 
int main() 
{   
    char* stract(char *to,char *from);         /*函数声明的形式就是把定义的表头写一遍，加上一个分号就可以了*/
	printf("现在复习字符串的连接的算法\n");
	char str1[20],str2[20];   
	int i=0,j=0;                /*第一种算法是在主函数中实现*/
	gets(str1);                 /*get函数的作用是输入字符，以空格标志着结束*/
	printf("再次输入\n");
	gets(str2);
	while(str1[i]!='\0')       /*这个句子的含义就是找到第一个字符串的结尾*/ 
	i++;
	while((str1[i++]=str2[j++])!='\0'); /*一定要记住中间的不是等于号而是赋值，相当于认为如果不是\0的话，就继续向下进行*/
	str1[i++]='\0';  
	puts(str1);
	
	char str3[20]="china ";
	char *str4="is my motherland";
	printf("%s\n",stract(str3,str4));
	
	char str5[20];
	char str6[20];
	char str7[40];
	printf("please input\n");
	gets(str5);
	printf("please input\n");
	gets(str6);
	for(i=0;str5[i]!='\0';i++)
	{
	str7[i]=str5[i];
	}
	for(j=0;str6[j]!='\0';j++)
	{
	str7[i++]=str6[j];             /*i++不要换成别的，因为我们现在是要把7数组输出，因此i的值已经+1的基础上在进行下一步*/ 
	}                              /*优先级[]高于单目运算符，i++单独用和++i是一样的*/ 
	str7[i]='\0';
	puts(str7);
	return 0;
}
char* stract(char *to,char *from)          /*如果这么写的话，代表一个返回指针的函数*/
{
	char *p1=to,*p2=from;                 /*因为字符数组的代号就是首地址，也就是说相当于四种之一*/
	while(*p1!='\0')
	p1++;
	while(*p2!='\0')
	*p1++=*p2++;
	*p1++='\0';
	return to;                         /*返回值必须是指针变量*/
}

