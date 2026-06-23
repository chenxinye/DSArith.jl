using Test
using DSArith

@testset "diagnostics" begin
    ctx = DSAContext(seed=42)
    with_context(ctx) do
        clear_diagnostics!(ctx)
        x = ds(1.0)
        y = ds(0.0)
        _ = x / y
        c = diagnostic_counts(ctx)
        @test c[DSArith.unstable_division] >= 1

        a = ds(1.23456789012345)
        b = ds(1.23456789012344)
        _ = a - b
        c2 = diagnostic_counts(ctx)
        @test c2[DSArith.unstable_cancellation] >= 0

        reset_report!(report(ctx))
        c3 = diagnostic_counts(ctx)
        @test all(v == 0 for v in values(c3))
    end
end
