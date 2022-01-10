#include  <stdio.h>
#include <stdlib.h>
int main( )
{
FILE *fp;
int i=3; float t=4.5;
if ((fp=fopen("test.txt","w")) == NULL)
{  
printf ("file open failed");
exit(0);  
}
fprintf(fp,"%d, %6.2f",i, t );
fclose (fp);
return 0;
}


