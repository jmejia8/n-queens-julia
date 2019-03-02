import Random: randperm

mutable struct Indiv
    f::Real
    x::Vector{Int}
end

function gen_population(f, n, pop_size)
    population = Indiv[]

    for i ∈ 1:pop_size
        x = randperm(n)
        push!(population, Indiv(f(x), x))
    end

    return population
end

function choose_parents(population)
    deepcopy(population)
end

function crossover(parents; p=0.5)
    pop_size = length(parents)
    n = length(parents[1].x)

    i = randperm(pop_size)
    parents = parents[i]

    children = Indiv[]

    for i ∈ 1:div(pop_size, 2)
        child1 = deepcopy(parents[2i-1])
        child2 = deepcopy(parents[2i])

        gens = rand(n) .< p

        tmp = child1.x[gens]
        child1.x[gens] = child2.x[gens]
        child2.x[gens] = tmp

        push!(children, child1)
        push!(children, child2)

    end
    
    return children
end

function swap!(x)
    i, j = randperm(length(x))[1:2]
    tmp = x[i]
    x[i] = x[j]
    x[j] = tmp
end

function mutate!(children; p = 0.1)
    for child ∈ children
        rand() < p && swap!(child.x)  
    end
end

function selection(children, parents)
    sort!(children, lt = (a, b) -> a.f < b.f)
    sort!(parents, lt = (a, b) -> a.f > b.f)

    j = 1
    for i = 1:length(children)
        if children[i].f < parents[j].f
            parents[j] = children[i]
            j+=1
        end
    end

    return parents
end

function evaluate_pop!(population, f)
    for i = 1:length(population)
        population[i].f = f(population[i].x)
    end
end


function genetic_algorithm(f; n = 8, iters = 1000n)
    pop_size = 10n
    stop = false

    # initial population
    population = gen_population(f, n, pop_size)

    # convergency
    sequence = Indiv[ population[1] ]

    # main loop
    for gen = 1:iters
        # choose parents
        parents = choose_parents(population)

        # display(parents)

        children = crossover(parents)
        # display(children)
        
        mutate!(children)
        # display(children)

        evaluate_pop!(children, f)

        # survivers
        population = selection(children, parents)

        if population[1].f < sequence[end].f
            println("gen: ", gen, "\t" , population[1].f)
            push!(sequence, population[1])
        end

        population[1].f == 0 && break
    end

    return population[1], sequence
end

function queen_atacks(chessboard)
    n = length(chessboard)

    s = n - length(Set(chessboard))
    for i = 1:n
        Δrows = i + chessboard[i]
        Δcols = i - chessboard[i]
        for j = (i+1):n
            s +=  j + chessboard[j] == Δrows ? 1 : 0
            s +=  j - chessboard[j] == Δcols ? 1 : 0
        end
    end
    2s
end

function test_ga()
    f(chessboard) = queen_atacks(chessboard)

    best, _ = genetic_algorithm(f; iters = 1000)
    best
end

# test_ga()
