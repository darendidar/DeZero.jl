#step10
#进行一系列测试

using Test
include("step09.jl")
function numerical_diff(f,x::Var,eps=1e-4)
    x0=Var(x.data.-eps)
    x1=Var(x.data.+eps)
    y0=f(x0)
    y1=f(x1)
    return (y1.data.-y0.data)./2eps 
end

#Square函数测试
x1=Var([2.0])
y1=Square(x1)
@test y1.data==[4.0]

#反向传播测试
x2=Var([3.0])
y2=Square(x2)
@test backward(y2)==[6.0]

#通过梯度检验来自动测试
x3=Var([rand()])
y3=Square(x3)
gy3=backward(y3)
gy3_num=numerical_diff(Square,x3)
diff3=abs(gy3[1]-gy3_num[1])#只有一个元素暂且直接提取
@test diff3<=1e-8