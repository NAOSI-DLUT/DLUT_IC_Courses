#include <stdio.h>
int main()
{
int a[8],*p=a,i,j=0,k=0;
for(i=0;i<8;i++)
{
printf("请输入第%d个数组元素\n",i+1);
scanf("%d",(p+i));
}
for(i=0;i<8;i++)
{
 if(*(p+i)%2==0)
 {
 j++;
 *(p+i)=*(p+i)-1;
 }
 else
 {
 k++;
 *(p+i)=*(p+i)+1;
 }
}
for(i=0;i<8;i++)
 printf("%d\t",*(p+i));
printf("\n");
printf("奇数的个数是%d\n",k);
printf("偶数的个数为%d\n",j);
return 0;
}
