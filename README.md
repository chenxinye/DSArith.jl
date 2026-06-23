# DSArith.jl

DSArith.jl implements **Discrete Stochastic Arithmetic (DSA)** in Julia with synchronous CESTAC lanes.

## What it is
- Synchronous multi-lane stochastic floating-point arithmetic (`DSFloat{T,N}`)
- Directed random rounding (`RoundDown`/`RoundUp`) per lane per operation
- CESTAC significant-digit estimates and computational zero (`@.0`)
- Stochastic relations (`s_eq`, `s_gt`, ...)
- CADNA-inspired diagnostics

## What it is not
- Not ordinary Monte-Carlo random perturbation of whole program runs
- Not simple stochastic rounding only
- Not a guarantee of exact correctness; significance estimates are probabilistic

## DSA vs CESTAC vs stochastic rounding
- **Stochastic rounding**: randomized rounding rule for individual operations.
- **CESTAC**: repeated stochastic evaluations and confidence-based significant-digit estimate.
- **DSA**: synchronous CESTAC lanes + computational zero + stochastic relations/diagnostics for numerically unstable control flow.

## Installation
```julia
import Pkg
Pkg.add(url="https://github.com/chenxinye/DSArith.jl")
```

## Quick start
```julia
using DSArith

x = ds(10864.0)
y = ds(18817.0)
r = 9*x^4 - y^4 + 2*y^2

println(stochastic_string(r))
println(report(r))
```

## Important comparison warning
Stochastic equality is not transitive under numerical noise; avoid using `DSFloat` values as `Dict`/`Set` keys when stochastic equality semantics are active. Prefer explicit `s_eq`, `s_gt`, `s_ge`, etc. in DSA-sensitive logic.

## Examples
Run any example with:
```bash
julia --project=. examples/rump.jl
```

## Documentation
```julia
julia --project=docs docs/make.jl
```
