#include <stdio.h>
char* stract(char *to,char *from)
{
	char*p1=to,*p2=from;
	while(*p1!='\0')
	p1++;
	while(*p2!='\0')
	*p1++=*p2++;
	*p1++='\0';
	return to;
}
int main()
{
	char str1[20]="china ";
	char *str2="is my motherland";
	printf("%s\n",stract(str1,str2));
	return 0;
}
