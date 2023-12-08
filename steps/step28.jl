#step28
#实现梯度下降法并应用在rosebrocken函数中
#用plots包画出(x0,x1)点的轨迹

using Plots
include("../src/core_simple.jl")
include("../src/utils.jl")

rosenbrock(a, b) = 100 * (b - a^2)^2 + (a - 1)^2

function main()
    x0 = Var([0.0])
    x1 = Var([2.0])
    lr = 0.001
    iters = 10000

    x0_points = Float64[]
    x1_points = Float64[]

    for i in 1:iters
        push!(x0_points, x0.data[1])
        push!(x1_points, x1.data[1])
        y = rosenbrock(x0, x1)
        clgr!(x0)
        clgr!(x1)
        backward!(y)
        x0.data -= lr .* x0.grad
        x1.data -= lr .* x1.grad
    end

    scatter(x0_points, x1_points, legend=false, xlabel="X0", ylabel="X1", title="Scatter Plot")
    xlims!(-2, 2)  # 设置横坐标范围为 0 到 10
    ylims!(-1, 3)
    savefig("images/rosebrock_10000.png")

end

main()
