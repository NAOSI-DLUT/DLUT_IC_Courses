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