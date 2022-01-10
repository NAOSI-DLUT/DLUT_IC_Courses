#include <stdio.h>
int max(int x,int y)       /*在里面必须规定形参的类型*/       
{
	int z;
	z=x>y?x:y;
	return z;
}
int main()
{   
    int a,b,c;
    scanf("%d%d",&a,&b);
    c=max(a,b);
    printf("%d\n",c);
	return 0;
}
