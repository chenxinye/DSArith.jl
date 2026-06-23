using Test
using DSArith

@testset "types" begin
    x = ds(1.25)
    @test x isa DSFloat
    @test length(samples(x)) == 3
    @test samples(x) == (1.25, 1.25, 1.25)

    y = convert(DSFloat{Float32,3}, 1.0)
    @test y isa DSFloat{Float32,3}

    z = DSFloat{Float64,3}(2.0)
    @test z isa DSFloat64

    w = DSFloat{Float32,3}(2.0)
    @test w isa DSFloat32

    @test promote_type(DSFloat{Float64,3}, Float32) == DSFloat{Float64,3}
end
