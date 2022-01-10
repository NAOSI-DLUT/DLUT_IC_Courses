#include <stdio.h>
#include <stdlib.h>

int main()
{
int j=1;
FILE *fp;
printf("其中平均分80分以上的有%d个人\n",j);
if ((fp=fopen("homework.txt","w"))==NULL)           /*检查一下确保不会出现空内容*/
{
	printf("file open failed");
	exit(0);
}
fprintf(fp,"平均分超过80分的有%d人",j);
fclose(fp);
return 0;
}
