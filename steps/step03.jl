#step03

mutable struct Var
    data
end
Var()=Var(nothing)

#x^2函数
square(x)=x.^2
mutable struct Square<:Fun end
Square()=Var()
Square(x::Var)=Var(square(x.data))

#e^x函数
mutable struct Exp<:Fun end
Exp()=Var()
Exp(x::Var)=Var(exp.(x.data))

# main
x=Var([0.5])
a=Square(x)
b=Exp(a)
y=Square(b)
println(y.data)
