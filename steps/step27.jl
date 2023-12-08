#step27
#core_simple中写入Sin函数
#my_sin中用泰勒展开实现sin函数，可调节精度

include("../src/core_simple.jl")
include("../src/utils.jl")

function my_sin(x, threshold=1e-4)
    y = 0
    for i in 0:100000
        c = (-1)^i / factorial(big(2i + 1))#big()通常用于需要高精度计算或者涉及到超出常规数值范围的数值操作
        t = c * x^(2i + 1)
        y = y + t
        all(abs.(t.data) .< threshold) && break#all()函数判断集合中所有元素是否都满足某个条件
    end
    return y
end 

x=Var([pi/4])
y=my_sin(x)
backward!(y)

println(y.data)
println(x.grad)
x.name='x'
y.name='y'
plot_dot_graph(y, verbose=false, file="images/sin_1e-4.png")
