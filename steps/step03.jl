#step03

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

# main
x=Var([0.5])
a=Square(x)
b=Exp(a)
y=Square(b)
println(y.data)
