#config


#verbose参数是计算机编程领域中一个常见术语,它可以用来控制程序输出信息的准确性和详细程度
function _dot_var(v::Var; verbose=false)
    name = !isnothing(v.name) ? v.name : ""
    if verbose && !isnothing(v.name)
        !isnothing(v.name) && (name *= ": ")
        name *= ": " * string(size(v.data)) * " " * string(eltype(v.data))
    end
    return """$(objectid(v)) [label="{$(v.creator)|$name}", style=filled, fillcolor=lightblue, color=blue]\n"""
end

function get_dot_graph(v;verbose=true)
    txt = """node[fontname = "Courier New", fontsize = 10, shape = record];\n
    edge[fontname = "Courier New", fontsize = 10, arrowhead = "empty"];"""
    list = [v]#数组
    txt *= _dot_var(v, verbose=verbose)
    while length(list) > 0#列表中有变量时
        generations = [v.generation for v in list]
        index = findmax(generations)[2]#返回（值，索引），用[2]索引定位
        y = list[index]#通过求generation最大值的方法确定辈分最小的会比排序快
        if y.pre !== nothing#如果有父变量
            for x in y.pre#对于每一个父变量
                if typeof(x)!=Var
                    continue
                end#有父级包含非Var类的情况比如幂函数
                txt *= """$(objectid(x)) -> $(objectid(y))\n"""# [label="$(y.creator)"]
                if !(x in list)#防止重复加入同一个父变量
                    txt *= _dot_var(x, verbose=verbose)
                    push!(list, x)#父变量加入列表中
                end
            end
        end
        splice!(list, index)#求出这个变量所有父变量导数值后从列表删除这个变量，如果上面
    end
    return "digraph g {\n" * txt * "}"
end

function plot_dot_graph(v; verbose=false, file="graph.png")
    dot_graph = get_dot_graph(v, verbose=verbose)
    graph_path = tempname() * ".dot"
    open(graph_path, "w") do f
        write(f, dot_graph)
    end
    extension = split(file, ".")[end]
    cmd = `dot $graph_path -T $extension -o $file`
    run(cmd)
end
