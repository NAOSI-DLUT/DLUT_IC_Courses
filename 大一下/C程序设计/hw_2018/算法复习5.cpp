#include <stdio.h>
#define x 4
#define y 5
#define p 2
#define q 3
int main()
{
	int a[x][x],i,j,t,sum=0;
	for(i=0;i<x;i++)
	{
		for(j=0;j<x;j++)
		{
		printf("请输入数组的元素\n"); 
		scanf("%d",&a[i][j]);
		}
	}
	for(i=0;i<x;i++)
	{
	sum=sum+a[i][i];
	}
	printf("%d",sum/x);
	printf("下面开始输出上三角\n");
	for(i=0;i<x;i++)
	{
		for(j=0;j<x;j++)
		{
			if(j<=i)
			printf(" ");
			else
			printf("%d",a[i][j]);
		}
	printf("\n");
    }
    for(i=0;i<x;i++)              /*正方形矩阵的转置可以这么写，如果是一般的矩阵转置就需要用2个矩阵*/
    {
    	for(j=0;j<x;j++)
    	if(j<i)
    	{
    	t=a[i][j];
    	a[i][j]=a[j][i];
    	a[j][i]=t;
		}
	}
	for(i=0;i<x;i++)
	{
		for(j=0;j<x;j++)
		{
			printf("%d\t",a[i][j]);
		}
		printf("\n");
	}
	for(i=0;i<x;i++)
	{
		printf("%d\n",a[i][x-1-i]);        /*输出所有的副对角线，注意几何关系*/
	}
	return 0;
}
