#step39
#编写broadcast_to(),sum_to(),sum()函数
#sum_to中先假设不同类型矩阵合并时只有标量、行向量和列向量三种，后续遇到问题需要修改(写得稀烂)

include("../src/core.jl")
include("../src/utils.jl")

function main()
    x1 = Var([1, 2, 3, 4, 5, 6])
    y1 = sum(x1)
    backward!(y1)
    println(y1.data)
    println(x1.grad.data)

    x2 = Var([1 2 3;4 5 6])
    y2 = sum(x2,axis=1)
    println(y2.data)
    println(size(x2.data), " -> ", size(y2.data))
end

main()
