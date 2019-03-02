import Random: randperm
using Plots
gr(legend=false, size=(500, 500))

include("n-queens.jl")

y(x, c, i) = x .+ c .- i

function plot_chessboard(x=zeros(8))
    n = length(x)
    n2 = round(Int, n/2)

    chessboard = repeat([1 0; 0 1], outer=(n2,n2))

    p = heatmap(chessboard, xlim=[0.5, n+0.5], ylim=[0.5, n+0.5], title="Ataques: $(queen_atacks(x[ x .!= 0 ]))")

    
    for i = 1:n
        x[i] == 0 && continue
        c = x[i]
        plot!(0:n+1, y(0:n+1, c, i), lw=4, color=:blue, alpha=0.3)
        plot!(0:n+1, -y(0:n+1, -c, i), lw=4, color=:blue, alpha=0.3)
    end

    # Queens
    scatter!( 1:n, x, markersize=12, marker=:star6, markercolor=:red)

    p
end

function main()
    f(chessboard) = queen_atacks(chessboard)

    best, sequence = genetic_algorithm(f)
    best

    a = @animate for i = 1:length(sequence)
        plot_chessboard(sequence[i].x)
    end

    g = gif(a, fps=1)
    println(g)
end

# main()