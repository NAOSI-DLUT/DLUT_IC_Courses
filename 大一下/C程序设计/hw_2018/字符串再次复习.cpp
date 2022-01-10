#include <stdio.h>
#include <string.h>
int main()
{
	char s[100],x[100],c[10];
	int i;
	printf("please input the string\n");
	scanf("%s",s);
	printf("please input the char you want to delete\n");
	scanf("%s",c);
	for(i=0;i<strlen(s);i++)
	{
	if(s[i]!=c[0])	
	{
		x[i]=s[i];
	}
	}
	printf("%s",x);
	return 0;
}
