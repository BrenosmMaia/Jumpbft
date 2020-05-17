using JuMP, GLPK
const MOI = JuMP.MathOptInterface

"""
m is number of items (have profits -> c)
c {10, 20, 30}
n is number of elements (have weights -> a)
a {3, 3, 3, 3}
b is capacity
Ni is array of sets: item0 -> elements{0, 1, 2}, item1 ->
elements{1, 2, 3}, item 2-> elements {0, 2},
"""


function extended_kanpsack(m, c, n, a, b, Ni)

    M = 1:m
    N = 1:n
    model = Model(GLPK.Optimizer)

    @variable(model, x[M], Bin)
    @variable(model, y[N], Bin)

    @objective(model, Max, sum(c[i]*x[i] for i=M))

    @constraint(model, sum(a[j]*y[j] for j=N) <=b)

    for p in M, q in Ni[p]
        @constraint(model, x[p] <= y[q])
    end

    JuMP.optimize!(model)

    print("\n")
    println("Solution is:")
    for i in 1:m
        println("x[$i] = ", JuMP.value(x[i]))
    end
    print("\n")
    for j in 1:n
        println("y[$j] = ", JuMP.value(y[j]))
    end
    println("Objective is: ", JuMP.objective_value(model))
end



function get_data(file)

    file = open(file, "r")
       if !(isfile(file))
           println("Erro na abertura do arquivo")
           exit(1)
       end

    m = parse(Int64, readline(file))
    c = readline(file)
    c = split(c," ")
    c = map(i -> parse(Int64, i), c)

    n = parse(Int64, readline(file))

    a = readline(file)
    a = split(a, " ")
    a = map(j -> parse(Int64, j), a)

    b = parse(Int64, readline(file))

    Ni = []
    for i = 1:m
        x = readline(file)
        x = split(x, " ")
        x = map(k -> parse(Int64, k), x)
        x=Set(x)
        push!(Ni, x)

    end
    println("Input Data:\n", m, "\n", c, "\n", n, "\n", a, "\n", b, "\n", Ni)
    close(file)

    return m, c, n, a, b, Ni
end


m, c, n, a, b, Ni = get_data("C:\\Users\\BrenoMaia\\Documents\\Julia\\input2.txt")
extended_kanpsack(m, c, n, a, b, Ni)
