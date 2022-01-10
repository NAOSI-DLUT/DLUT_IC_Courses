#include <stdio.h>
#include <string.h>
int main()
{
	printf("研究指针与数组如有可能研究更高级的\n");
	printf("首先是1维\n");
	printf("请输入\n"); 
	int a[10],*m,i,j;
	m=a;
	for(i=0;i<10;i++)
	{
	/*scanf("%d",&a[i]);*/
	scanf("%d",m+i);                     /*在这里达到了同样的效果，p+i就可以了*/
	}
	for(i=0;i<10;i++)
	{
	printf("%d\t",*(m+i));              /*p+i和a+i*/
	}
	printf("\nthe level improves\n");
	char s1[20],s2[2],*p,*q;
	p=s1;
	q=s2;
	scanf("%s",s1);
	for(;*p!='\0';p++,q++)
	{
	*q=*p;
	}
	/* *q='\0'; */                 /*此时指针的位置指向不同地区了，并且这个句子可有可无*/                    
	printf("%s\n",s2);
	printf("下面是2维数组\n");
	int b[3][3],*t;
	t=b[0];                        /*如何让指针指向二维数组？b[0]而不是b，因为b是第0行元素首地址，不是第0行0列的元素首地址*/
	for(i=0;i<3;i++)
	{
		for(j=0;j<3;j++)
		{
		scanf("%d",*(b+i)+j);           /*地址的表达方式，一定要注意！首先，地址中不能有指针，不要把b+i写成p+i，这一步编译没有报错；其次，地址表达方式是*(b+i)+j，前面的*不要忘了 */
	    }
	}
	for(i=0;i<3;i++)
	{
		for(j=0;j<3;j++)
		{
		/*printf("%4d",*(*(b+i)+j) );*/ 
		printf("%4d",*(b[0]+4*i+j));         
		}
	printf("\n");
	}
	return 0;
}
