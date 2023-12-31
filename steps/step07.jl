#step07
#实现反向传播并自动化
#递归方式实现backward方法

mutable struct Var
    data#用来存储数据
    pre#该变量的前一个变量
    creator#通过调用哪个类型获得
end
Var()=Var(nothing,nothing,nothing)
Var(x)=Var(x,nothing,nothing)

#x^2函数
square(x)=x.^2
struct Square end
Square(x::Var)=Var(square(x.data),x,Square)

#e^x函数
struct Exp end
Exp(x::Var)=Var(exp.(x.data),x,Exp)

#一个通用的求！！！前一个！！！变量的导数值的函数，输入（变量，导数值）
function gradient(x::Var,gy)
    if x.creator==Square return 2 .*x.pre.data .*gy
    elseif x.creator==Exp return exp.(x.pre.data) .*gy
    else return nothing
    end
end

#递归的方式实现backward函数
function backward(x::Var,gx)
    if x.pre!==nothing
        backward( x.pre , gradient(x,gx) )
    else return gx
    end
end

# main
x=Var([0.5])
a=Square(x)
b=Exp(a)
y=Square(b)
@assert y.creator == Square
@assert y.pre == b
@assert y.pre.creator == Exp
@assert y.pre.pre == a
@assert y.pre.pre.creator == Square
@assert y.pre.pre.pre == x
println(backward(y,[1]))
