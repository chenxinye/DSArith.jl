# DSArith.jl

DSArith.jl is a Julia implementation of **Discrete Stochastic Arithmetic (DSA)** with CESTAC-style significance estimation.

It helps you evaluate whether floating-point results are numerically trustworthy, not only whether code runs.

## Software overview

DSArith executes each floating-point expression over multiple synchronized stochastic lanes (`DSFloat{T,N}`), then estimates result quality from lane dispersion.

Core ideas:

- random directed rounding at each lane and operation,
- confidence-based significant digit estimation,
- computational zero detection (`@.0`),
- numerical instability diagnostics (cancellation, branching, division, multiplication).

## Implemented functionality

- **DS floating-point type**: `DSFloat` with lane-level samples.
- **Execution context**: `DSAContext` / `DSAConfig` for lane count, seeds, and diagnostics.
- **Statistical quality metrics**: `mean_value`, `std_value`, `significant_digits`, `accuracy`.
- **Numerical status checks**: `iscomputedzero`, `stochastic_string`, `report`.
- **Stochastic relations**: `s_eq`, `s_gt`, `s_ge`, `s_lt`, `s_le`.
- **Diagnostics**: event counters and instability detection helpers.
- **Data uncertainty helpers**: uncertain input construction and perturbation utilities.

## Installation

```julia
import Pkg
Pkg.add(url="https://github.com/chenxinye/DSArith.jl")  # source install
# Pkg.add("DSArith")  # use this if DSArith is available in your registry setup
```

## Quick start

```julia
using DSArith

x = ds(10864.0)
y = ds(18817.0)
r = 9x^4 - y^4 + 2y^2

println(stochastic_string(r))
println(report(r))
```

## Documentation map

- **Theory**: formulas and interpretation of significance.
- **Examples**: representative instability and robustness cases.
- **API Reference**: full exported interface index.
- **References**: key literature behind CESTAC/CADNA and Rump benchmark.
