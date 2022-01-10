#include <stdio.h> 
int main()
{ 
int a,b,c;  
printf("请输入今天的日期\n");  
scanf("%d%d%d",&a,&b,&c);  
if(b==02 && c==28 && a%4==0)  
{
a=a;  
b=03;  
c=01;
}  
else if(a%4!=0 && b==02 && c==27)  
{
a=a; 
b=03;  
c=01;}  
else if(b==12 && c==31)  
{
a=a+1; 
b=01; 
c=01;
}  
else if((b==1 ||b==3 ||b==5 ||b==7||b==8||b==10)&&c==31) 
{a=a;  b=b+1;  c=01;}  
else if((b==4|| b==6||b==9||b==11)&&c==30)  {a=a;  b=b+1;  c=01;}  
else  {a=a;  b=b;  c=c+1;}  
printf("明天日期为：%d-%d-%d\n",a,b,c);  
return 0;
} 
