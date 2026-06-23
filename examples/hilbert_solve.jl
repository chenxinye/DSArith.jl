using LinearAlgebra
using DSArith

function hilbert(n)
    [1/(i+j-1) for i in 1:n, j in 1:n]
end

function gauss_solve(A, b)
    n = length(b)
    M = [ds(A[i,j]) for i in 1:n, j in 1:n]
    v = [ds(b[i]) for i in 1:n]

    for k in 1:n-1
        for i in k+1:n
            f = M[i,k] / M[k,k]
            for j in k:n
                M[i,j] = M[i,j] - f * M[k,j]
            end
            v[i] = v[i] - f * v[k]
        end
    end

    x = [ds(0.0) for _ in 1:n]
    for i in n:-1:1
        s = ds(0.0)
        for j in i+1:n
            s += M[i,j] * x[j]
        end
        x[i] = (v[i] - s) / M[i,i]
    end
    x
end

n = 5
A = hilbert(n)
b = A * ones(n)
xf = A \ b
xd = gauss_solve(A, b)
println("== Hilbert solve ==")
println("Float64 residual: ", norm(A * xf - b))
means = [mean_value(xi) for xi in xd]
println("DSArith residual: ", norm(A * means - b))
println("DSArith first component: ", stochastic_string(xd[1]), " ", report(xd[1]))
