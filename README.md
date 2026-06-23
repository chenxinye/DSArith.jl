# DSArith.jl

[![CI](https://github.com/chenxinye/DSArith2.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/chenxinye/DSArith2.jl/actions/workflows/CI.yml)
[![Documentation](https://github.com/chenxinye/DSArith.jl/actions/workflows/Documentation.yml/badge.svg)](https://github.com/chenxinye/DSArith.jl/actions/workflows/Documentation.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)


**Control and Stochastic Estimation of Rounding Errors (CESTAC, from french - Contrôle et Estimation STochastique des Arrondis de Calculs)** is a numerical stability check method based on repeated stochastic evaluations and confidence-based significant-digit estimate. The **Discrete Stochastic Arithmetic (DSA)**  is an synchronous CESTAC lanes + computational zero + stochastic relations/diagnostics for numerically unstable control flow.

``DSArith.jl`` implements DSA in Julia with synchronous CESTAC lanes.

## What it is - features
- Synchronous multi-lane stochastic floating-point arithmetic (`DSFloat{T,N}`)
- Directed random rounding (`RoundDown`/`RoundUp`) per lane per operation
- CESTAC significant-digit estimates and computational zero (`@.0`)
- Stochastic relations (`s_eq`, `s_gt`, ...)
- CADNA-inspired diagnostics
- Common elementary-function coverage on `DSFloat` (roots, trig/inverse trig, hyperbolic/inverse hyperbolic, exp/log families)





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
