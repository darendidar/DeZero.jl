#step16
#Var类中添加generation变量，与backward函数中的求导顺序有关
#解决了重复添加到列表和从列表取出顺序错误问题
#跳过了17-19优化部分，先实现功能

mutable struct Var
    data#用来存储数据
    pre#该变量的前一个变量
    creator#通过调用哪个类型获得
    grad#导数值
    generation#辈分
end
Var() = Var(nothing, nothing, nothing, nothing,1)
Var(x::AbstractArray) = Var(x, nothing, nothing, nothing,1)#只能传入数组

#x^2函数
square(x) = x .^ 2
struct Square end
Square(x::Var) = Var(square(x.data), [x], Square, nothing,x.generation+1)

#e^x函数
struct Exp end
Exp(x::Var) = Var(exp.(x.data), [x], Exp, nothing,x.generation+1)

#Add函数
struct Add end
Add(a::Var, b::Var) = Var(a.data .+ b.data, [a, b], Add, nothing,x.generation+1)

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
        generations=[v.generation for v in list]
        index=findmax(generations)[2]#返回（值，索引），用[2]索引定位
        y=list[index]#通过求generation最大值的方法确定辈分最小的会比排序快
        if y.pre !== nothing#如果有父变量
            for x in y.pre#对于每一个父变量
                gr = gradient(x, y)#储存该父变量的导数值
                if x.grad === nothing#如果父变量没有导数值
                    x.grad = gr#储存父变量
                else
                    x.grad = x.grad .+ gr#否则在原来导数值基础上加（适用于重复利用变量的情况）
                end
                if !(x in list)#防止重复加入同一个父变量
                    push!(list,x)#父变量加入列表中
                end
            end
        end
        splice!(list, index)#求出这个变量所有父变量导数值后从列表删除这个变量，如果上面
    end
end

function clgr!(v::Var)
    v.grad=nothing
end

# main
x = Var([2.0])
a=Square(x)
y=Add(Square(a),Square(a))
backward!(y)
println(y.data)
println(x.grad)
