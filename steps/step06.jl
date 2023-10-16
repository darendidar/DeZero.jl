#step06
#直接做第七步了，这一步不看了，代码也看不了
mutable struct Var
    data
    grad
end
Var()=Var(nothing,nothing)
Var(x)=Var(x,nothing)

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
dy=numerical_diff(f,x)
println(dy)
