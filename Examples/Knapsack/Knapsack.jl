using JuMP, GLPK


 function example_knapsack(nitems, profit, weight, capacity)

    model = Model(GLPK.Optimizer)
    @variable(model, x[1:nitems], Bin)
    # Objective: maximize profit
    @objective(model, Max, profit' * x)
    # Constraint: can carry all
    @constraint(model, weight' * x <= capacity)
    # Solve problem using MIP solver
    JuMP.optimize!(model)
        println("Objective is: ", JuMP.objective_value(model))
        println("Solution is:")
        for i in 1:nitems
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

    nitems  = parse(Int64, readline(file))

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

nitems, profit, weight, capacity = get_data("path to input file here")
example_knapsack(nitems, profit, weight, capacity)
