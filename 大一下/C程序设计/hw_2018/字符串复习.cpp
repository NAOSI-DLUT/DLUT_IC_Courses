#include <stdio.h>
#include <string.h>
int main()
{
	int i,j=0;
	char c[1000]="China";                   
	/*char c[]="china";*/                   /*这么定义的话，相当于系统已经默认c的长度为5，不能在加入别的了，否则就会出现越界的情况*/
	char d[]={'m','y'};                    /*加上单引号的话是合法的,并且系统会认为d数组的长度为2*/
	char e[]=" is my motherland ";            /*char e[4]="chi"; 这个语句是非法的，系统没有办法加反斜杠0，编译不会通过*/
	printf("%s\n",c);
	printf("%s\n",d);
	printf("%s\n",e);
	/*for(i=0;c[i]!='0';i++);*/
	char str1[20],str2[20];                   /*字符串的连接问题*/ 
	gets(str1);
	printf("再次输入\n");
	gets(str2);
	while(str1[i]!='\0')
	i++;
	while((str1[i++]=str2[j++])!='\0');
	puts(str1);
	i=j=0;
	while(c[i]!='\0')                              /*这一部分在刚才的问题是没有给c预留足够的空间*/
	i++;  
	while((c[i++]=e[j++])!='\0');
	c[i++]='\0';
	puts(c);
	printf("%d",strlen(d));           
	return 0;
}
