#step40
#修改+-*/函数使其支持广播

include("../src/core.jl")
include("../src/utils.jl")

function main()
    x0=Var([1,2,3])
    x1=Var([10])
    y=x0+x1
    @show y.data

    backward!(y)
    @show x1.grad.data 
end

main()
