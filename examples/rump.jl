using DSArith

rump(x, y) = 9*x^4 - y^4 + 2*y^2

println("== Rump polynomial ==")
for (x, y) in ((10864.0, 18817.0), (1/3, 2/3))
    println("inputs: x=$x y=$y")
    rf = rump(x, y)
    rd = rump(ds(x), ds(y))
    println("Float64: ", rf)
    println("DSArith: ", stochastic_string(rd))
    println("Report: ", report(rd))
    println()
end
