#step42
#添加函数msg，完成线性回归预测，出图
using Random
using Plots
include("../src/core.jl")
include("../src/utils.jl")
Random.seed!(0)

const lr = 0.1
const iters = 100

function main() 
    x = rand(100)
    y = 5 .+ 2x + rand(100)
    x,y=Var(x),Var(y)
    W = Var(zeros(1,1))
    b = Var(zeros(1))
    predict(x) = matmul(x,W) + b

    for i in 1:iters
        y_pred = predict(x)
        loss = mse(y, y_pred)
        clgr!(W)
        clgr!(b)

        backward!(loss)
        W.data -= lr * W.grad.data
        b.data -= lr * b.grad.data
        @show i,W.data, b.data, loss.data
    end
    scatter(x.data, y.data, label="random_points")
    plot!(x.data, W.data .* x.data .+ b.data, label="predict_line")
    xlabel!("X")
    ylabel!("Y")
    title!("Hui Gui")
    savefig("images/s42_huiui.png")
end

@time main();
