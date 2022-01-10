#include <stdio.h>
#include <string.h>
int main()
{
  union b
  {
  	int k;
  	char c[2];
  }a;
  a.k=-2;
  printf("%d\n%d\n",a.c[0],a.c[1]);	
  return 0;
}
