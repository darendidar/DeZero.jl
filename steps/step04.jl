#step04
#实现数值微分,复合函数求导

mutable struct Var
    data
end
Var()=Var(nothing)

#x^2函数
square(x)=x.^2
struct Square end
Square()=Var()
Square(x::Var)=Var(square(x.data))

#e^x函数
struct Exp end
Exp()=Var()
Exp(x::Var)=Var(exp.(x.data))

# 数值微分
function numerical_diff(f,x::Var,eps=1e-4)
    x0=Var(x.data.-eps)
    x1=Var(x.data.+eps)
    y0=f(x0)
    y1=f(x1)
    return (y1.data.-y0.data)./2eps 
end

f(x)=x|>Square|>Exp|>Square

# main
x=Var([0.5])
dy=numerical_diff(f,x)
println(dy)
