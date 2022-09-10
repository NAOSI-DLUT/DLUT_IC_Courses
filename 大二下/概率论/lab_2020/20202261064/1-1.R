w=rnorm(1000)
hist(w,freq=FALSE)
x=seq(min(w),max(w),by=0.001)
y=dnorm(x,mean(x),sd(w))
lines(x,y,col="red",lwd=2)
ave=mean(w)

print(ave)

vari=var(w)

print(vari)