using Test
using Aqua
using DSArith

@testset "Aqua" begin
    # ambiguities=false: Real interoperability overloads trigger noisy ambiguity reports.
    # unbound_args=false: DSArith intentionally uses parametric constructor/context signatures.
    Aqua.test_all(DSArith; ambiguities=false, unbound_args=false)
end
