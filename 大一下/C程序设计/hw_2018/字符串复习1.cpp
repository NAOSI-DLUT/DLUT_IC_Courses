#include <stdio.h>
#include <string.h> 
int main()
{
	char c[10];
	int i;
	printf("请输入\n");
	scanf("%s",c);            /*scanf里面如果要用到%s的话，不用加&*/
	printf("%s\n",c);
	for(i=0;i<10;i++)       /*小写转换成大写,大写转换成小写*/
	{
		if(c[i]>='a'&&c[i]<='z')
		c[i]=c[i]-32;
		else if(c[i]>='A'&&c[i]<='Z')
		c[i]=c[i]+32;
		/*else 
		c[i]=c[i];*/
	}
	for(i=0;i<9;i++)
	{
		printf("%c\n",c[i]);
	}                          /*结尾为什么会出现一个正方形呢？*/
	/*printf("%s",c);*/
	return 0;
}
