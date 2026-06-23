using Test
using DSArith

@testset "stats" begin
    x = DSFloat{Float64,3}((1.0, 2.0, 3.0))
    @test mean_value(x) ≈ 2.0
    @test std_value(x) ≈ 1.0

    t = DSArith.tau_beta(3, 0.05)
    @test t ≈ 4.302652729911275 atol=1e-12

    m = mean_value(x)
    s = std_value(x)
    c = log10(sqrt(3) * abs(m) / (s * t))
    @test significant_digits(x) ≈ c atol=1e-12

    z = DSFloat{Float64,3}((0.0, 0.0, 0.0))
    @test iscomputedzero(z)

    y = DSFloat{Float64,3}((1.0, 1.0, 1.0))
    @test isinf(significant_digits(y))
    @test accuracy(y) >= 1
end
