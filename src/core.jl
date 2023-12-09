import Base:  + ,-,*,/ ,^,sin,cos# 导入加减乘除和幂运算运算符

mutable struct Var
    data#用来存储数据
    pre#该变量的前一个变量
    creator#通过调用哪个类型获得
    grad#导数值
    generation#辈分
    name#起名
end
Var() = Var(nothing, nothing, nothing, nothing, 1,nothing)
Var(x::AbstractArray) = Var(x, nothing, nothing, nothing, 1,nothing)#只能传入数组

#x^2函数
square(x) = x .^ 2
struct Square end
Square(x::Var) = Var(square(x.data), [x], Square, nothing, x.generation + 1,nothing)

#加法
struct Add end
Add(a::Var, b::Var) = Var(a.data .+ b.data, [a, b], Add, nothing, max(a.generation, b.generation) + 1,nothing)

#减法
struct Neg end
Neg(x::Var) = Var(x.data .* -1, [x], Neg, nothing, x.generation + 1,nothing)

#乘法
struct Mul end
Mul(a::Var, b::Var) = Var(a.data .* b.data, [a, b], Mul, nothing, max(a.generation, b.generation) + 1,nothing)

#除法
struct Div end
Div(a::Var, b::Var) = Var(a.data ./ b.data, [a, b], Div, nothing, max(a.generation, b.generation) + 1,nothing)

#e^x函数
struct Exp end
Exp(x::Var) = Var(exp.(x.data), [x], Exp, nothing, x.generation + 1,nothing)

#幂运算
struct Pow end
Pow(x::Var, c::Number) = Var(x.data .^ c, [x,c], Pow, nothing, x.generation + 1,nothing)

#sin函数
struct Sin end
Sin(x::Var) = Var(sin.(x.data), [x], Sin, nothing, x.generation + 1,nothing)

#cos函数
struct Cos end
Cos(x::Var) = Var(cos.(x.data), [x], Cos, nothing, x.generation + 1,nothing)



#一个通用的求父变量的导数值的函数，输入（父变量，子变量）
function gradient(x::Var, y::Var)
    if y.creator === Add
        return y.grad
    elseif y.creator === Neg
        return -y.grad
    elseif y.creator === Mul
        return y.grad * (x === y.pre[1] ? (y.pre[2]) : (y.pre[1]))
    elseif y.creator === Div
        return y.grad * (x === y.pre[1] ? (1 / y.pre[2]) : (y.pre[1] / y.pre[2] ^ 2) * -1)
    elseif y.creator === Square
        return 2 * x * y.grad
    elseif y.creator === Exp
        return exp.x * y.grad
    elseif y.creator === Pow
        return x^(y.pre[2]-1)*y.grad*y.pre[2]#y的父变量中1是底数2是幂c
    elseif y.creator === Sin
        return cos(x) * y.grad
    elseif y.creator === Cos
        return -sin(x) * y.grad
    else
        return nothing
    end
end

#循环的方式实现backward!函数
function backward!(v::Var)
    v.grad === nothing && (v.grad = Var(ones(eltype(v.data), size(v.data))))#根据数据规模创建相应导数值1
    list = [v]#待处理列表
    while length(list) > 0#列表中有变量时
        generations = [v.generation for v in list]
        index = findmax(generations)[2]#返回（值，索引），用[2]索引定位
        y = list[index]#通过求generation最大值的方法确定辈分最小的会比排序快
        if y.pre !== nothing#如果有父变量
            for x in y.pre#对于每一个父变量
                if typeof(x)!=Var
                    continue
                end#有父级包含非Var类的情况比如幂函数
                gr = gradient(x, y)#储存该父变量的导数值
                if x.grad === nothing#如果父变量没有导数值
                    x.grad = gr#储存父变量
                else
                    x.grad = x.grad + gr#否则在原来导数值基础上加（适用于重复利用变量的情况）
                end
                if !(x in list)#防止重复加入同一个父变量
                    push!(list, x)#父变量加入列表中
                end
            end
        end
        splice!(list, index)#求出这个变量所有父变量导数值后从列表删除这个变量
    end
end

function clgr!(v::Var)
    v.grad = nothing
end

#运算符重载
+(a::Var, b::Var) = Add(a, b)
+(a::Var, b::Number) = Add(a, Var([b]))
+(a::Number, b::Var) = Add(Var([a]), b)
-(v::Var) = Neg(v)#以下借助负号完成减法
-(a::Var, b::Var) = Add(a, Neg(b))
-(a::Var, b::Number) = Add(a, Var([b * -1]))
-(a::Number, b::Var) = Add(Var([a]), -b)
*(a::Var, b::Var) = Mul(a,b)
*(a::Var, b::Number) = Mul(a, Var([b]))
*(a::Number, b::Var) = Mul(Var([a]), b)
/(a::Var, b::Var) = Div(a,b)
/(a::Var, b::Number) = Div(a, Var([b]))
/(a::Number, b::Var) = Div(Var([a]), b)
^(v::Var, n::Number) = Pow(v, n)
sin(v::Var)=Sin(v)
cos(v::Var)=Cos(v)
