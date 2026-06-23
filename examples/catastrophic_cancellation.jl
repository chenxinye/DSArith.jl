using DSArith

f_bad(x) = (1 - cos(x)) / x^2
f_good(x) = 2 * sin(x / 2)^2 / x^2

x = 1e-8
println("== Catastrophic cancellation ==")
println("Float64 bad: ", f_bad(x))
println("Float64 good: ", f_good(x))
xb = ds(x)
dbad = f_bad(xb)
dgood = f_good(xb)
println("DSArith bad: ", stochastic_string(dbad), " -> ", report(dbad))
println("DSArith good: ", stochastic_string(dgood), " -> ", report(dgood))
println("Diagnostics: ", diagnostic_counts())
