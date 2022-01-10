#include <stdio.h>
#define num 10
int main()
{
	int a[num],i,j,t,k;/*这里是典型的冒泡法排序，关键是要理解相应的机制*/
	for(i=0;i<num;i++)
	{
	scanf("%d",&a[i]);
    }
    for(i=0;i<num-1;i++) /*循环在这里十分重要，主要是数学关系*/ 
    {
    	for(j=0;j<num-i-1;j++)    /*在这里解释一下为什么要num-i-1，因为第一次循环10个数，只用两两比较9次，并且由于最大的数已经到底，于是就需要-i*/
    	{                         /*i是一个用来控制次数的变量*/
    		if(a[j]>a[j+1])
    		{
    		t=a[j];
    		a[j]=a[j+1];
    		a[j+1]=t;
			}
		}
	}
	for(i=0;i<num;i++)
	{
	printf("%d\t",a[i]);
	}
	printf("\n");
	printf("选择法排序\n");
	for (i=0;i<num;i++)
	{
       scanf("%d", &a[i]);
    }
   for (i=0;i<num-1;i++)
    { 
       k=i;                               /*首先以第一个数为基准*/
       for(j=i+1;j<num;j++)       /*在进行完一次循环之后，第一个数已经确定是最小的数，不用再参与比较了*/
	   {                         /*假如比第一个数小，那么更换基准，遍历一遍之后找到的就是最小的数的位置*/ 
        if(a[j]<a[k])  
		k=j;      
	   }      
       if (k!=i)                 /*跳出第一步内层循环之后，一次性把最小的数给第一个数，第一次循环中i=0，此时数列的第一项就已经是0了，其余的以此类推*/                 
      {  
	  t=a[i]; 
	  a[i]=a[k]; 
	  a[k]=t; 
	  }              
    }
    printf("The sorted numbers:\n");
    for (i=0;i<num;i++)
	printf ("%d\t",a[i]);
    return 0;
}
