#step38
#编写reshape函数与transpose函数

include("../src/core.jl")
include("../src/utils.jl")
function main()
    x1 = Var([1 2 3; 4 5 6])
    y1 = reshape(x1, (6,))
    backward!(y1)
    @show x1.grad.data

    x2 = Var(rand(1:9,2, 3))
    @show x2.data
    y2 = transpose(x2)
    @show y2.data
end

main()
