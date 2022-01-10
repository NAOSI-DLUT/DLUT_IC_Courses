#include <stdio.h>
int main()
{
int a[10],i,j,k,t;
for(i=0;i<10;i++)
{
	scanf("%d",&a[i]);
}
for(i=1;i<10;i++)
{
k=i;
for(j=i+1;j<10;j++)
{
	if(a[j]<a[k])
	{
	k=j;
	}
}
if(k!=i)
{
t=a[i];
a[i]=a[k];
a[k]=t;
}
}
for(i=0;i<10;i++)
{
	printf("%d\t",a[i]);
}
return 0;	
} 
