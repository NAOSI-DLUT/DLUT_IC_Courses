#include <stdio.h> 
int main()
{
	int a=4,b=4,c=4,d,e,f,g,i,j;
	while(a--);                     /*首先，循环语句后边加了分号,因此不存在循环嵌套问题，分析为什么a是-1:当while变成0的时候跳出循环但是仍然要执行a=a-1，a=a-1是a本身的属性*/  
	while(c)                        /*主要辨析的就是自增运算中的问题*/  
	c--;                            /*而这个句子中c--是一个后续语句，因此当c成为0的时候，后续语句不执行，所以C也是0*/ 
	while(--b);                     /*b是0的原因是自减运算已经进行过了，因此在从1变为0的时候直接跳出*/      
	printf("a=%d\n",a);
	printf("b=%d\n",b);
	printf("c=%d\n",c);
	printf("输入三位数d\n");
	scanf("%d",&d);
	/*e=d/100;*/
	e=(d/100)%10;
	f=(d/10)%10;
	g=d%10;
	printf("e=%d\n",e);
	printf("f=%d\n",f);
	printf("g=%d\n",g);
	for(i=0;i<=8;i++)        /*输出了左下方的三角形*/
	{                        /*需要注意的就是i是从0开始，到8结束，一共打印了9行*/ 
	     for(j=0;j<=i;j++)        /*想想一下i和j是横竖坐标，i负责换行纵向，j负责横向打印，并且个数是行数所以j<=i*/ 
	     {
	     printf("*");
	     }
	printf("\n");
	}
	printf("\n");            /*这一行只是为了分割，下面输出的是左上方的三角形，稍微换一下就行了*/
	for(i=0;i<=8;i++)       
	{
		for(j=0;j<=8-i;j++)
		{
		printf("*"); 
		}
		printf("\n");
	}
    for(i=0;i<=8;i++)         /*输入右上方的三角形的时候，我们会发现应当的左下方的位置上输入空格*/
    {
    	for(j=0;j<=8;j++)
    	{
    	if(i>j)                /*所以说需要加一个判断条件，寻找左下方的坐标特征即可，注意是i>j输空格*/          
    	printf(" ");
    	else
    	printf("*");
		}
	printf("\n");
	}
	for(i=0;i<=8;i++)       
    {
    	for(j=0;j<=8;j++)
    	{
    	if(i<8-j)	
    	printf(" ");
    	else
    	printf("*");
		} 
	printf("\n");
	}                          /*综上所述，很明显的能够看出来，主要是找好数学关系,明确i和j的几何含义就简单多了*/
	printf("下面开始输出塔形\n");
	for(i=0;i<=4;i++)
	{
		for(j=0;j<=8;j++)
		{
		if(j<=4+i&&j>=4-i)	
		printf("*");
		else
		printf(" ");
		}
		printf("\n");
	}
	printf("下面输出梯形\n");
	for(i=0;i<=4;i++) 
	{
		for(j=0;j<=12;j++)
		{
			if(j<=4-i)
			printf(" ");
			else
			printf("*");
		}
		printf("\n");
	}
	printf("下面输出平行四边形\n");
	for(i=0;i<=4;i++) 
	{
		for(j=0;j<=17;j++)
		{
			if(j<=4-i||j>17-i)
			printf(" ");
			else
			printf("*");
		}
		printf("\n");
	}
	return 0;
}
