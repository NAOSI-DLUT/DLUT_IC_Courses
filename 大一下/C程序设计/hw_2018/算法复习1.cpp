#include <stdio.h>
int swap1(int *x,int *y)
{
	int t;     /*t不能是指针变量，如果t是指针变量，则*t代表t所指向的变量，由于没有赋值，因此可能会导致系统蓝屏错误*/
	t=*x;
	*x=*y;
	*y=t;
}
int main()
{
    int max(int x,int y);      /*函数声明的正确形式*/
	int a=1,b=2,c;
	int *m,*n;
	m=&a;
	n=&b;
	swap1(&a,&b);      /*这里主要就是注意要用地址交换，指针变量本身的之不会被改变但是指针变量指向的值已经被改变了*/
	/*swap1(m,n);*/              /*这样也可以*/
	printf("%d\n%d\n",a,b);
	c=a;
	a=b;
	b=c;
	printf("%d\n%d\n",a,b);
	max(a,b);
	return 0;
}
int max(int x,int y) 
{
	int z;
	z=x>y?x:y;
	printf("max=%d\n",z);              /*这个句子不能出现在主函数中，因为z是在max函数中定义的，主函数中出现会报错*/
	return z;                            /*解决问题的主要问题就是*/
}
