using Test
using Aqua
using DSArith

@testset "Aqua" begin
    Aqua.test_all(DSArith; ambiguities=false) # Ambiguities are noisy due to Base method overloading for Real interoperability.
end
