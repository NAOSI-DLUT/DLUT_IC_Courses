#include <stdio.h> 
struct birthday
{
	int year;
	int month;
	int day;
	int minute;
};
int main()
{   
	struct student
	{
	int num;
	char name[200];
	int score;
	struct birthday;
	}a1,a2;
	printf("%d\n",sizeof(student));
	
	return 0;
	
}
