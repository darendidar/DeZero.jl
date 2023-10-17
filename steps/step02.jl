#step02
#用自定义数据类型实现平方函数

mutable struct Var
    data
end
Var()=Var(nothing)

#平方函数
square(x)=x.^2
struct Square end
Square()=Var()
Square(x::Var)=Var(square(x.data))

# main
x = Var([10])
y = Square(x)
print(typeof(y),"\n", y.data)