#step02

mutable struct Var
    data
end
Var()=Var(nothing)

#平方函数
mutable struct Square<:Fun end
Square()=Var()
Square(x::Var)=Var(square(x.data))

# main
x = Var([10.0, 5])
y = Square(x)
print(typeof(y),"\n", y.data)