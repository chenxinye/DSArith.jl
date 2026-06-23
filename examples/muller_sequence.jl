using DSArith

function muller_float(n)
    x0, x1 = 11/2, 61/11
    for _ in 1:n
        x0, x1 = x1, 111 - 1130/x1 + 3000/(x1*x0)
    end
    x1
end

function muller_ds(n)
    x0, x1 = ds(11/2), ds(61/11)
    for k in 1:n
        x0, x1 = x1, 111 - 1130/x1 + 3000/(x1*x0)
        if k % 5 == 0
            println("n=$k mean=$(mean_value(x1)) acc=$(accuracy(x1))")
        end
    end
    x1
end

println("== Muller sequence ==")
println("Float64 n=25: ", muller_float(25))
xd = muller_ds(25)
println("DSArith: ", stochastic_string(xd))
println("Report: ", report(xd))
println("Diagnostics: ", diagnostic_counts())
