""" 
 This is a version of the Knapsack problem, obtained from https://github.com/JuliaOpt/JuMP.jl/blob/master/examples/knapsack.jl, modified to receive
 its input from a text file
"""

using JuMP, GLPK
const MOI = JuMP.MathOptInterface

"""
    example_knapsack(; verbose = true)
Formulate and solve a simple knapsack problem:
    max sum(p_j x_j)
     st sum(w_j x_j) <= C
        x binary
"""
function example_knapsack(; verbose = true)

    file = open("C:\\Users\\Breno Maia\\Desktop\\test.txt", "r")
    if !(isfile(file))
        println("Erro na abertura do arquivo")
        exit(1)
    end

    line1 = readline(file)
    p= split(line1, "")
    deleteat!(p, findall(x->x==" ", p))
    profit = map(i -> parse(Int, i), p)
    n = size(profit, 1) #quantidade de itens

    line2=readline(file)
    w= split(line2, "")
    deleteat!(w, findall(x->x==" ", w))
    weight = map(i -> parse(Int, i), w)

    line3 = readline(file)
    capacity = parse(Int64, line3)

    model = Model(with_optimizer(GLPK.Optimizer))
    @variable(model, x[1:n], Bin)
    # Objective: maximize profit
    @objective(model, Max, profit' * x)
    # Constraint: can carry all
    @constraint(model, weight' * x <= capacity)
    # Solve problem using MIP solver
    JuMP.optimize!(model)
    if verbose
        println("Objective is: ", JuMP.objective_value(model))
        println("Solution is:")
        for i in 1:n
            print("x[$i] = ", JuMP.value(x[i]))
            println(", p[$i]/w[$i] = ", profit[i] / weight[i])
        end
    end
    #@test JuMP.termination_status(model) == MOI.OPTIMAL
    #@test JuMP.primal_status(model) == MOI.FEASIBLE_POINT
    #@test JuMP.objective_value(model) == 16.0
end

example_knapsack(verbose = true)
