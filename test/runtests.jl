using Test
using DSArith

@testset "DSArith" begin
    include("test_types.jl")
    include("test_rounding.jl")
    include("test_arithmetic.jl")
    include("test_stats.jl")
    include("test_relations.jl")
    include("test_diagnostics.jl")
    include("test_examples.jl")
    include("test_aqua.jl")
end
