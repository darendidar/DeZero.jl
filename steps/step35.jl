#step35
#编写Tanh函数并重载tanh()
#计算tanh函数一到八阶导数并画出关系图

include("../src/core.jl")
include("../src/utils.jl")

function main()
    x = Var([1.0])
    y = tanh(x)
    x.name='x'
    y.name = "y"
    backward!(y)

    iters = 7
    for i in 1 : iters
        @show i
        gx = x.grad
        clgr!(x)
        backward!(gx)
    end
    gx = x.grad
    gx.name = "gx$(iters)"

    cd("images")
    println("plotting graph, please waiting...")
    plot_dot_graph(gx, file="tanh$(iters).png")
    cd("..")
    println("done!")
end

@time main()
