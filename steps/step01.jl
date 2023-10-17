#step01
#实现variable类
#没有引入ndarray实例

mutable struct Var
    data
end
Var()=Var(nothing)

data=[1.0]
x=Var(data)
println(x)

x.data=[2.0]
println(x)

#Julia中dims()用来查看数组维度
a=ndims([1])
b=ndims([1 2 3])
println(a,b)