A=runif(2000,0,1)

mA=mean(A)
vA=var(A)

print(mA)
print(vA)

B=(-1)*log(1-A,exp(1))/3

mB=mean(B)
vB=var(B)

print(mB)
print(vB)