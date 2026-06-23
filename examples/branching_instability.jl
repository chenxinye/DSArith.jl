using DSArith

x = uncertain(1.0; ulps=3, seed=1)
y = uncertain(1.0; ulps=3, seed=2)

println("== Branching instability ==")
println("x: ", report(x))
println("y: ", report(y))
println("x > y (stochastic): ", s_gt(x, y))
println("x >= y (stochastic): ", s_ge(x, y))
println("x == y (stochastic): ", s_eq(x, y))
println("compare_stochastic: ", compare_stochastic(x, y))
println("Diagnostics: ", diagnostic_counts())
