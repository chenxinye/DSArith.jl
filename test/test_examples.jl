using Test
using DSArith

@testset "examples" begin
    files = [
        "rump.jl",
        "catastrophic_cancellation.jl",
        "muller_sequence.jl",
        "logistic_map.jl",
        "branching_instability.jl",
        "summation_kahan.jl",
        "hilbert_solve.jl",
    ]

    for f in files
        @testset "$f" begin
            include(joinpath(@__DIR__, "..", "examples", f))
            @test true
        end
    end

    r = with_context(DSAContext(seed=7)) do
        9*ds(10864.0)^4 - ds(18817.0)^4 + 2*ds(18817.0)^2
    end
    @test std_value(r) > 0
    @test significant_digits(r) <= 1
    @test iscomputedzero(r) || accuracy(r) <= 1
end
