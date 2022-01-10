#include <stdio.h>
struct date
{
	int year;
	int month;
	int day;
};
struct student
{
	int number;
	char name[20];
	struct date;
};
int main()
{
	struct student stu[3];
	union u
	{
		char *name;
		int age;
		int income;
	}s;
	s.name="licongrui";
	s.age=19;
	s.income=10000;
	printf("%c\n",s.name);
	return 0;
}
