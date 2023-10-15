#step04

mutable struct Var
    data
end
Var()=Var(nothing)

#利用抽象类型Func类作为各种函数的父类，利用可调用数据类型一般调用方法可以把实例当作函数使用
abstract type Fun end 
(f::Fun)(x::Var)::Var=f(x.data)#相当于利用data创建一个Fun实例（之后会配合Fun类的构造函数实现函数功能）

#x^2函数
square(x)=x.^2
mutable struct Square<:Fun end
Square()=Var()
Square(x::Var)=Var(square(x.data))

#e^x函数
square(x)=x.^2
mutable struct Exp<:Fun end
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

