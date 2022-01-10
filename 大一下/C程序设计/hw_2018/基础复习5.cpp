#include <stdio.h>
int main()
{
unsigned short int a;
unsigned long int b;
unsigned int c;                            /*可以存储负数*/
int d=011;                                 /*各种进制的数字一定要分清*/
int e=0x18;
int g=6;
int h=0;
int k[][4]={1,2,3,4,5,6,7,8,9,10,11,12,13},i,j;/*这么定义的话(13个) 系统会自动生成- -个4*4的数组, 不用担心*/
int k1[][4]={{1,2,3},{1,2,3}};
float f;
/*scanf("%d",&f);*/                   /* 如果只写%d的话就会导致输出f的值变为.000，所以不能写百分之d*/
scanf("%f",&f);
a=-1;
b=-1;
c=-65536;
a=a-1;
b--;
c--;	
/*g+=g-=g*g;
g=g+(g=g-g*g);
g=g+(g=6-6*6);	/*中间的时候g的值发生了改变，不是之前的6而变成了-30,所以不要算成-24*/
h=g++,b++,c++; /* 不是说h等于这个逗号表达式的值，而是说h=g++本身成为了一个表达式 得出一个值,所以如果想要达到刚才的效果应当整体加括号*/ 
printf("a=%d\nb=%d\nc=%d\nd=%d\nd=%o\ne=%d\ne=%x\nf=%3.4f\ng=%d\nh=%d\n",a,b,c,d,d,e,e,f,g,h);
printf("%d\n",k[3][3]);
printf("%d\n",k[2][2]);/*如果只对11个元素赋值的话，最后一个元素认为是0*/
printf("%d",k1[0][3]);
return 0;
}
