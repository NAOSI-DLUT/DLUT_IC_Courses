#include <stdio.h>
#include <math.h>
int jiecheng(int x)
{
	int i=1,sum=1;
	for(i=1;i<=x;i++)
	{
		sum=sum*i;
	}
	printf("%d\n",sum);
	return sum;
}
int main()
{
	int a;
	scanf("%d",&a);           /*scanf里面不要加一个反斜杠n*/
	jiecheng(a);
	printf("%d",a);
	/*printf("%d",sum);*/     /*不能写sum，否则直接报错了*/         
	return 0;
}
