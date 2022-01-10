#include <stdio.h>
int main()
{
	char str1[209],str2[20];
	int i=0,j=0;

	scanf("%s",str1);
	printf("go on\n");
	scanf("%s",str2);

	while(str1[i]!='\0')
		i++; 
	while(str2[j]!='\0')
		str1[i++]=str2[j++];

	str2[i++]='\0';
	puts(str1);
	
	return 0;
}
