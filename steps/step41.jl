#step41
#实现matmul函数与其反向传播

include("../src/core.jl")
include("../src/utils.jl")

function main()
    x=Var(rand(2,3))
    W=Var(rand(3,4))
    y=matmul(x,W)
    backward!(y)
    @show size(x.grad.data)
    @show size(W.grad.data)
end

main()
