#step03
#用自定义数据类型实现Exp函数

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

# main
x=Var([0.5])
a=Square(x)
b=Exp(a)
y=Square(b)
println(y.data)
