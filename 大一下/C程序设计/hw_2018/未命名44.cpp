#include <stdio.h>
int main()
{
	int a[10];
	int i=0,j=0,k,t;
	for(i=0;i<10;i++)
	{
	scanf("%d",&a[i]);
	}
	for(i=0;i<10-1;i++)
	{
		k=i;
		for(j=i+1;j<10;j++)
		{
			if(a[k]>a[j])
			{
			k=j;
			}
		}	
		if(k!=i)
		{
			t=a[k];
			a[k]=a[i];
			a[i]=t;
		}
	}
	for(i=0;i<10;i++)
	printf("%d\t",a[i]);
	return 0;
}
