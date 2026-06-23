using Test
using DSArith

@testset "arithmetic" begin
    ctx1 = DSAContext(seed=123)
    ctx2 = DSAContext(seed=123)
    ctx3 = DSAContext(seed=124)

    r1 = with_context(ctx1) do
        ds(1.0) / ds(10.0) + ds(1.0) / ds(3.0)
    end
    r2 = with_context(ctx2) do
        ds(1.0) / ds(10.0) + ds(1.0) / ds(3.0)
    end
    r3 = with_context(ctx3) do
        ds(1.0) / ds(10.0) + ds(1.0) / ds(3.0)
    end
    r4 = with_context(DSAContext(seed=125)) do
        ds(1.0) / ds(10.0) + ds(1.0) / ds(3.0)
    end

    @test samples(r1) == samples(r2)
    @test samples(r1) != samples(r3) || samples(r1) != samples(r4)

    a = ds(2.0)
    b = ds(5.0)
    @test mean_value(a + b) ≈ 7.0
    @test mean_value(b - a) ≈ 3.0
    @test mean_value(a * b) ≈ 10.0
    @test mean_value(b / a) ≈ 2.5
    @test mean_value(a^3) ≈ 8.0
    @test mean_value(a^-1) ≈ 0.5

    @test (a + 1.0) isa DSFloat
    @test (1.0 + a) isa DSFloat

    @test sqrt(ds(4.0)) isa DSFloat
    @test exp(ds(1.0)) isa DSFloat
    @test log(ds(2.0)) isa DSFloat
    @test sin(ds(0.1)) isa DSFloat
end
