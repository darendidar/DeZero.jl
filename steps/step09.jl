#step09
#使用循环实现backward方法，同时简化
#使Variable创建时只支持data存储数组
#转换为ndarray实例没做

mutable struct Var
    data#用来存储数据
    pre#该变量的前一个变量
    creator#通过调用哪个类型获得
end
Var()=Var(nothing,nothing,nothing)
Var(x::AbstractArray)=Var(x,nothing,nothing)#只能传入数组

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

#循环的方式实现backward函数
function backward(x::Var, gx=nothing)
    gx===nothing&&(gx=ones(eltype(x.data), size(x.data)))#根据数据规模创建相应导数值1
    while x.pre !== nothing#每次检查有没有上一级
        gx = gradient(x, gx)#先算出上一个变量的导数值
        x = x.pre#再跳到上一个变量
    end
    return gx#当跳到最开始的变量后返回这个变量的导数值
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
