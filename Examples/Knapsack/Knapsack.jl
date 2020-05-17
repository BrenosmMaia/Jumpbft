using JuMP, GLPK


 function example_knapsack(nitens, profit, weight, capacity)

    model = Model(GLPK.Optimizer)
    @variable(model, x[1:nitens], Bin)
    # Objective: maximize profit
    @objective(model, Max, profit' * x)
    # Constraint: can carry all
    @constraint(model, weight' * x <= capacity)
    # Solve problem using MIP solver
    JuMP.optimize!(model)
        println("Objective is: ", JuMP.objective_value(model))
        println("Solution is:")
        for i in 1:nitens
            print("x[$i] = ", JuMP.value(x[i]))
            println(", p[$i]/w[$i] = ", profit[i] / weight[i])
        end
end



function get_data(file)

    file = open(file, "r")
    if !(isfile(file))
        println("Erro na abertura do arquivo")
        exit(1)
    end

    nitens  = parse(Int64, readline(file))

    profit = readline(file)
    profit = split(profit, " ")
    profit = map(i -> parse(Int64, i), profit)

    weight = readline(file)
    weight = split(weight, " ")
    weight = map(j -> parse(Int64, j), weight)

    capacity = parse(Int64, readline(file))

    println("Input data:")
    println(nitens)
    println(profit)
    println(weight)
    println(capacity)
    print("\n")
    close(file)

    return nitens, profit, weight, capacity
end

nitens, profit, weight, capacity = get_data("C:\\Users\\BrenoMaia\\Documents\\Julia\\input.txt")
example_knapsack(nitens, profit, weight, capacity)
