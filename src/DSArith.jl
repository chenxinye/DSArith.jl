module DSArith

using Random
using Statistics
using Distributions

include("types.jl")
include("diagnostics.jl")
include("context.jl")
include("rounding.jl")
include("stats.jl")
include("arithmetic.jl")
include("elementary.jl")
include("relations.jl")
include("display.jl")
include("data_uncertainty.jl")

export DSFloat, DSFloat64, DSFloat32, DSAContext, DSAConfig, DSAReport, DiagnosticEvent
export ds, dsa, dsfloat, samples, lanes, mean_value, std_value, significant_digits, accuracy
export iscomputedzero, is_computed_zero, stochastic_string, report, reset_report!
export with_context, default_context, set_default_context!
export s_eq, s_ne, s_gt, s_ge, s_lt, s_le, compare_stochastic
export uncertain, perturb_data
export diagnostics, diagnostic_counts, has_instability, clear_diagnostics!

end
