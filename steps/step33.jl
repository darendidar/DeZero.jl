#step33
#src文件夹中添加core.jl文件，修改gradient函数和backward!函数，使Var对象的grad属性成为Var类
#添加Cos函数并重载cos()
#自动计算二阶导数并用牛顿法优化+画图保存

using Plots
include("../src/core.jl")
include("../src/utils.jl")

f(x) = x^4 - 2 * x^2

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
        clgr!(x)
        backward!(y)

        gx=x.grad
        clgr!(x)
        backward!(gx)
        gx2=x.grad
        x.data -= gx.data ./ gx2.data
    end 
    x_p = -2:0.1:2
    y_p = x_p.^4 - 2 .* x_p.^2
    p1 = plot(x_p, y_p, label="f(x) = x^4 - 2 * x^2")
    scatter_points = [(x0_points[i], x1_points[i]) for i in 1:length(x0_points)]
    scatter!(p1, scatter_points, label="Newton iterations", legend=:topleft, xlabel="X", ylabel="Y", title="Newton's Method")
    xlims!(-3, 3)  
    ylims!(-2, 10)
    savefig("images/newton_auto.png")
end

main()
