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

    @testset "elementary unary family" begin
        cases = [
            (:sqrt, 4.0),
            (:cbrt, 8.0),
            (:sin, 0.3),
            (:cos, 0.3),
            (:tan, 0.3),
            (:sec, 0.3),
            (:csc, 0.3),
            (:cot, 0.3),
            (:asin, 0.3),
            (:acos, 0.3),
            (:atan, 0.3),
            (:asec, 2.0),
            (:acsc, 2.0),
            (:acot, 2.0),
            (:sinh, 0.3),
            (:cosh, 0.3),
            (:tanh, 0.3),
            (:sech, 0.3),
            (:csch, 2.0),
            (:coth, 2.0),
            (:asinh, 0.3),
            (:acosh, 2.0),
            (:atanh, 0.3),
            (:asech, 0.5),
            (:acsch, 2.0),
            (:acoth, 2.0),
            (:exp, 0.3),
            (:exp2, 0.3),
            (:exp10, 0.3),
            (:expm1, 0.3),
            (:log, 2.0),
            (:log2, 2.0),
            (:log10, 2.0),
            (:log1p, 0.3),
        ]

        for (fname, x) in cases
            f = getfield(Base, fname)
            y = f(ds(x))
            @test y isa DSFloat
            @test mean_value(y) ≈ f(x) atol=1e-10 rtol=1e-10
        end
    end

    @testset "elementary domain diagnostics" begin
        ctx = DSAContext(seed=2026)
        with_context(ctx) do
            clear_diagnostics!(ctx)
            invalid_cases = [
                (:sqrt, -1.0),
                (:asin, 2.0),
                (:acos, 2.0),
                (:asec, 0.5),
                (:acsc, 0.5),
                (:acosh, 0.5),
                (:atanh, 1.0),
                (:asech, 0.0),
                (:acsch, 0.0),
                (:acoth, 0.5),
                (:log, -1.0),
                (:log2, -1.0),
                (:log10, -1.0),
                (:log1p, -2.0),
            ]

            for (fname, x) in invalid_cases
                y = getfield(Base, fname)(ds(x))
                @test all(isnan, samples(y))
            end

            c = diagnostic_counts(ctx)
            @test c[DSArith.domain_error] >= length(invalid_cases)
        end
    end
end
