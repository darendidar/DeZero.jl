#step13
#!!!Var中添加grad变量用来储存导数值，同时修改相关函数
#重写（大改）backward函数，修改gradient函数，改变求导的操作方式
#添加clgr函数，清零导数值

mutable struct Var
    data#用来存储数据
    pre#该变量的前一个变量
    creator#通过调用哪个类型获得
    grad#导数值
end
Var() = Var(nothing, nothing, nothing, nothing)
Var(x::AbstractArray) = Var(x, nothing, nothing, nothing)#只能传入数组

#x^2函数
square(x) = x .^ 2
struct Square end
Square(x::Var) = Var(square(x.data), [x], Square, nothing)

#e^x函数
struct Exp end
Exp(x::Var) = Var(exp.(x.data), [x], Exp, nothing)

#Add函数
struct Add end
Add(a::Var, b::Var) = Var(a.data .+ b.data, [a, b], Add, nothing)#!!!无法确定前一个变量

#一个通用的求父变量的导数值的函数，输入（父变量，子变量）
function gradient(x::Var, y::Var)
    if y.creator == Square
        return 2 .* x.data .* y.grad
    elseif y.creator == Exp
        return exp.(x.data) .* y.grad
    elseif y.creator == Add
        return y.grad
    else
        return nothing
    end
end

#循环的方式实现backward!函数
function backward!(v::Var)
    v.grad === nothing && (v.grad = ones(eltype(v.data), size(v.data)))#根据数据规模创建相应导数值1
    list = [v]#数组
    while length(list)>0#列表中有变量时
        y=list[1]#首个元素y作为当前对象
        if y.pre !== nothing#如果有父变量
            for x in y.pre#对于每一个父变量
                gr = gradient(x, y)#储存该父变量的导数值
                if x.grad === nothing#如果父变量没有导数值
                    x.grad = gr#储存父变量
                else
                    x.grad = x.grad .+ gr#否则在原来导数值基础上加（适用于重复利用变量的情况）
                end
                push!(list,x)#父变量加入列表中
            end
        end
        splice!(list, 1)#求出这个变量所有父变量导数值后从列表删除这个变量
    end
end

function clgr!(v::Var)
    v.grad=nothing
end

# main
x = Var([3.0])
y=Add(x,x)
backward!(y)
println(x.grad)
clgr!(x)
y=Add(Add(x,x),x)
backward!(y)
println(x.grad)