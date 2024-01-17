#step43
#lineral_simple和sigmoid_simple函数的创建
#神经网络的实现,生成sin(2pi*x+b)随机点并预测,出图
#过程中遇到问题,发现core.jl中sum_to函数的问题并完善

using Random
using Plots
include("../src/core.jl")
include("../src/utils.jl")
Random.seed!(0)

const lr = 0.3
const iters = 10000

function lineral_simple(x,W,b=nothing)
    t=matmul(x,W)
    b===nothing&&return t
    return t+b
end

sigmoid_simple(x) = 1/(1+exp(-x))

function main() 
    x = rand(100)
    y = sin.(x.*pi.*2).+rand(100,1)
    x,y=Var(x),Var(y)
    I,H,O = 1,10,1
    W1 = Var(0.01*randn(I,H))
    b1 = Var(zeros(H)')
    W2 = Var(0.01*randn(H,O))
    b2 = Var(zeros(O)')
    function predict(x)
        py=lineral_simple(x,W1,b1)
        py=sigmoid_simple(py)
        py=lineral_simple(py,W2,b2)
        return py
    end
    for i in 1:iters
        y_pred = predict(x)
        loss = mse(y, y_pred)
        clgr!(W1)
        clgr!(b1)
        clgr!(W2)
        clgr!(b2)
        backward!(loss)
        W1.data -= lr * W1.grad.data
        b1.data -= lr * b1.grad.data     #b1.grad.data
        W2.data -= lr * W2.grad.data
        b2.data -= lr * b2.grad.data
        # @show i, loss.data
    end
    # Plot
    scatter(x.data, y.data, label="random_points")
    pre_x=0:0.01:1
    plot!(pre_x, predict(Var(pre_x)).data, label="predict_line")
    xlabel!("X")
    ylabel!("Y")
    title!("shenjingwangluo")
    savefig("images/s43_sjwl.png")
end

@time main();
