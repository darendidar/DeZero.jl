#step45
#使模型的创建与参数更新便捷

using Random
using Plots
include("../src/core.jl")
include("../src/utils.jl")
Random.seed!(0)

const lr = 0.2#学习率
const iters = 10000#学习次数

function lineral_simple(x,W,b=nothing)
    t=matmul(x,W)
    b===nothing&&return t
    return t+b
end

sigmoid_simple(x) = 1/(1+exp(-x))

struct Model
    layers
    activations
end

function Model(Layer::NTuple, Act::NTuple)
    layers = []
    activations = []
    for i in 1:length(Layer)-1#到倒数第二项就可以，每次用到i和i+1作为输入输出层数
        W = Var(0.01 * randn(Layer[i], Layer[i+1]))
        b = Var(zeros(Layer[i+1])')
        push!(layers, W)
        push!(layers, b)#[W1,b1,W2,b2,W3,b3...]
        i<=length(Act)&&push!(activations, Act[i])#[Act1,Act2...]
    end
    return Model(layers, activations)
end

function predict(model::Model, x::Var)
    result = x
    for i in 1:div(length(model.layers), 2)#layers元素数量总是偶数，div保证结果是整数以便使用索引
        W = model.layers[2*i-1]
        b = model.layers[2*i]
        if i<= length(model.activations)
            activation_function = model.activations[i]
            temp = lineral_simple(result, W, b)
            result = activation_function(temp)
        else
            result = lineral_simple(result, W, b)
        end
    end
    return result
end


function clgrs!(model::Model)
    for layer in model.layers
        clgr!(layer)
    end
end

function update_parameters!(model::Model, learning_rate::Float64)
    for layer in model.layers
        if typeof(layer) == Var  # 确保是包含参数的层
            layer.data -= learning_rate * layer.grad.data  # 根据梯度下降更新参数
        end
    end
end

function main() 
    x = rand(100)
    y = sin.(x.*pi.*2).+rand(100,1)
    x,y=Var(x),Var(y)
    model = Model((1,10,1), (sigmoid_simple,))
    for i in 1:iters
        y_pred = predict(model,x)
        loss = mse(y, y_pred)
        @show loss.data
        clgrs!(model)
        backward!(loss)
        update_parameters!(model,lr)
    end
    #Plot
    scatter(x.data, y.data, label="random_points")
    pre_x=0:0.01:1
    plot!(pre_x, predict(model,Var(pre_x)).data, label="predict_line")
    xlabel!("X")
    ylabel!("Y")
    title!("shenjingwangluo")
    savefig("images/s45_sjwl.png")
end


@time main();
