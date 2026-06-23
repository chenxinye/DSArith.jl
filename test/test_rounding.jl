using Test
using DSArith

@testset "rounding" begin
    @test DSArith.exact_rational(0.0) == 0//1
    @test DSArith.exact_rational(-0.0) == 0//1
    @test DSArith.exact_rational(Float64(1.5)) == 3//2
    @test_throws DomainError DSArith.exact_rational(Inf)
    @test_throws DomainError DSArith.exact_rational(NaN)

    q = BigInt(1)//BigInt(10)
    d = DSArith.directed_convert(Float64, q, RoundDown)
    u = DSArith.directed_convert(Float64, q, RoundUp)
    @test DSArith.exact_rational(d) <= q <= DSArith.exact_rational(u)

    q2 = BigInt(1)//BigInt(8)
    d2 = DSArith.directed_convert(Float64, q2, RoundDown)
    u2 = DSArith.directed_convert(Float64, q2, RoundUp)
    @test d2 == u2 == 0.125

    @test DSArith.directed_convert(Float32, q, RoundDown) <= DSArith.directed_convert(Float32, q, RoundUp)
end
