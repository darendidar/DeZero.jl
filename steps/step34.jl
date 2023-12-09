#step34
#求sin函数的高阶导数，用Plots包画图保存

using Plots
include("../src/core.jl")
include("../src/utils.jl")

x = Var(collect(range(-7, 7, length=200)))
y = sin(x)
backward!(y)
logs = [vec(y.data)]
function main()
    for _ in 1:3
        push!(logs, vec(x.grad.data))
        gx = x.grad
        clgr!(x)
        backward!(gx)
        @show x.grad.data
    end
    labels = ["y=sin(x)", "y′", "y′′", "y′′′"]
    plt = plot()
    for (i, v) in enumerate(logs)
        plt = plot!(x.data, v, label=labels[i])
    end
    cd("images")
    savefig(plt, "sin")
end


main()

