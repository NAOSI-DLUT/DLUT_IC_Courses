y=seq(1,1000,1)
n=1

# regenerate vectors
repeat{
	m=rpois(100,2)
	y[n]=mean(m)
	n=n+1
	if(n>1000)
	{
		break
	}
}

hist(y)

sy=(y-2)/sqrt(2)

m=mean(sy)

print(m)

v=var(sy)
print(v)

# Problem-4
hist(sy)
