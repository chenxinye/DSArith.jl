using DSArith

function naive_sum(v)
    s = ds(0.0)
    for x in v
        s += ds(x)
    end
    s
end

function kahan_sum(v)
    s = ds(0.0)
    c = ds(0.0)
    for x in v
        y = ds(x) - c
        t = s + y
        c = (t - s) - y
        s = t
    end
    s
end

v = [1.0; fill(1e-10, 20_000)...; -1.0]
println("== Summation ==")
ns = naive_sum(v)
ks = kahan_sum(v)
println("Naive DSArith: ", stochastic_string(ns), " ", report(ns))
println("Kahan DSArith: ", stochastic_string(ks), " ", report(ks))
