#step06

mutable struct Var
    data#用来存储数据
    pre#该变量的前一个变量
    creator#通过调用哪个类型获得
end
Var()=Var(nothing,nothing,nothing)
Var(x)=Var(x,nothing,nothing)

#x^2函数
square(x)=x.^2
mutable struct Square end
Square(x::Var)=Var(square(x.data),x,Square)

#e^x函数
mutable struct Exp end
Exp(x::Var)=Var(exp.(x.data),x,Exp)

#一个通用的backward函数
function back(x::Var,gy)
    if x.creator==Square return 2 .*x.data .*gy
    elseif x.creator==Exp return exp.(x.data) .*gy
    else return nothing
    end
end

#递归的方式backward方法
function backward(x::Var,gy)
    grad=gy
    if x.pre!==nothing
        grad=back(x,gy)
        backward(x.pre,grad)
    end
    return grad
end
#`!=`表示不等于，而`!==`表示不全等于。这里用哪个区别不大。
#`!=`只比较值是否相等，而`!==`则比较值和类型是否都相等.

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
