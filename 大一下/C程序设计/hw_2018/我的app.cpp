#include <stdio.h>
void f1(int a[5][5])
{
int i,j;
for(i=0;i<=4;i++)
 for(j=0;j<=4;j++)
 {
  printf("请输入数组中元素的值\n");
  scanf("%d",&a[i][j]);
 }
}
void f2(int a[5][5])
{
int i,j;
int b[5][5];
for(i=0;i<=4;i++)
 for(j=0;j<=4;j++)
  b[i][j]=a[j][i];
for(i=0;i<=4;i++)
{
 for(j=0;j<=4;j++)
  printf("%5d",b[i][j]);
printf("\n");
}
}
void f3(int a[5][5])
{
int i,j;
for(i=0;i<=4;i++)
 for(j=1+i;j<=4;j++)
  a[i][j]=0;
for(i=0;i<=4;i++)
{
 for(j=0;j<=4;j++)
  printf("%5d",a[i][j]);
printf("\n");
}
}
int f4(int a[5][5])
{
int i,j=0,k=0;
for(i=0;i<=4;i++)
 j=a[i][i]+j;
k=j/5;
printf("主对角线平均值为%d\n",k);
return k;
}
int main()
{
 int c=1,a[5][5];                      /*对c赋予初值1，使其能够进入到循环体之中显示功能界面*/ 
 while(c)
 {
 printf("     =====功能选项=====\n");
 printf("     1---给5*5的矩阵赋初值\n");
 printf("     2---对矩阵进行转置\n");
 printf("     3---将矩阵的上三角元素变为0\n");
 printf("     4---求主对角线元素的平均值\n"); 
 printf("     请您从1,2,3,4中选择一个功能\n");
 scanf("%d",&c);
 switch(c)
 {
 case 1: f1(a);break;
 case 2: f2(a);break;
 case 3: f3(a);break;
 case 4: f4(a);break;
 default:printf("输入错误，请重试\n");
 }
 }
return 0;
}
