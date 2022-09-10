X=runif(1000,2,7)
Y=4 * X - 6

mX=mean(X)
print(mX)

mY=mean(Y)
print(mY)

print(var(X))
print(var(Y))

c=cov(X,Y)
print(c)

co=cor(X,Y)
print(co)

Y1=X*exp(2*X^(1-1))
Y2=X*exp(2*X^(2-1))
Y3=X*exp(2*X^(3-1))
print(cor(X,Y1))
print(cor(X,Y2))
print(cor(X,Y3))