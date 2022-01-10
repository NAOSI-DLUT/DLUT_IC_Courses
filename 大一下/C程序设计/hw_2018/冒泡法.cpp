#include <stdio.h>
#include <string.h>
int main()
{
	char *f[5]={"laoyi","laoyifu","laoye","laolao","dayifu"};
	char *t;
	int i,j;
	i=0;
	j=0;
	for(i=1;i<5;i++)
	{
		for(j=0;j<5-i;j++)
		{
			if(strcmp(f[j],f[j+1])>0)
			{
				t=f[j];
				f[j]=f[j+1];
				f[j+1]=t;
			}
		}
	}
	for(i=0;i<5;i++)
	printf("%s\n",f[i]);
	return 0;
}
