#step26
#为Var类添加name属性
#src中添加utils.jl，编写计算图可视化代码

include("../src/core_simple.jl")
include("../src/utils.jl")

goldstein(x, y) = (1 + (x + y + 1)^2 * (19 - 14 * x + 3 * x^2 - 14 * y + 6 * x * y + 3 * y^2)) * (30 + (2 * x - 3 * y)^2 * (18 - 32 * x + 12 * x^2 + 48 * y - 36 * x * y + 27 * y^2))
x=Var([1.0])
y=Var([1.0])
z=goldstein(x, y)
backward!(z)
x.name='x'
y.name='y'
z.name='z'
plot_dot_graph(z,verbose=false, file="images/goldstein.png")
