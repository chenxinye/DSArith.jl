using Test
using DSArith

@testset "relations" begin
    clear_diagnostics!()
    x = ds(1.0)
    y = ds(1.0)
    @test s_eq(x, y)
    @test !s_ne(x, y)
    @test s_ge(x, y)

    a = ds(2.0)
    b = ds(1.0)
    @test s_gt(a, b)
    @test s_lt(b, a)

    c = compare_stochastic(x, y)
    @test c in (:eq_noise, :le, :ge)

    counts = diagnostic_counts()
    @test counts[DSArith.unstable_branching] >= 1
end
