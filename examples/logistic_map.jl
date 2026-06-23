using DSArith

function main()
    r = ds(4.0)
    x = ds(0.6)
    println("== Logistic map ==")
    for n in 1:60
        x = r * x * (1 - x)
        if n % 5 == 0
            println("n=$n mean=$(mean_value(x)) sig=$(significant_digits(x)) acc=$(accuracy(x))")
        end
        if iscomputedzero(x) || accuracy(x) == 0
            println("Stopping at n=$n due to loss of significance")
            break
        end
    end
    println("Diagnostics: ", diagnostic_counts())
end

main()
