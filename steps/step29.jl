#step29
#使用牛顿法实现优化（手动计算）并画图保存

using Plots
include("../src/core_simple.jl")
include("../src/utils.jl")

f(x) = x^4 - 2 * x^2
gx2(x) = 12 * x^2 - 4 # 二阶导数是手动计算的

function main()
    x = Var([2.0])
    iters = 10
    x0_points = Float64[]
    x1_points = Float64[]
    for i in 1:iters
        push!(x0_points, x.data[1])
        push!(x1_points, f(x.data[1]))
        @show i, x.data
        clgr!(x)
        y = f(x)
        backward!(y)
        x.data -= x.grad ./ gx2.(x.data)
    end 
    x_p = -2:0.1:2
    y_p = x_p.^4 - 2 .* x_p.^2
    p1 = plot(x_p, y_p, label="f(x) = x^4 - 2 * x^2")
    scatter_points = [(x0_points[i], x1_points[i]) for i in 1:length(x0_points)]
    scatter!(p1, scatter_points, label="Newton iterations", legend=:topleft, xlabel="X", ylabel="Y", title="Newton's Method")
    xlims!(-3, 3)  
    ylims!(-2, 10)
    savefig("images/newton_hand.png")
end

@time main()
