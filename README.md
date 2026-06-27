# DSArith.jl

[![Registry](https://img.shields.io/badge/Julia%20General-registered-success.svg)](https://github.com/JuliaRegistries/General/tree/master/D/DSArith)
[![CI](https://github.com/chenxinye/DSArith2.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/chenxinye/DSArith2.jl/actions/workflows/CI.yml)
[![Documentation](https://github.com/chenxinye/DSArith.jl/actions/workflows/Documentation.yml/badge.svg)](https://github.com/chenxinye/DSArith.jl/actions/workflows/Documentation.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)


``DSArith.jl`` is an efficient Julia library for the implementation of **Discrete Stochastic Arithmetic (DSA)**, based on the synchronous use of **CESTAC (Contrôle et Estimation Stochastique des Arrondis de Calculs, i.e., Control and Stochastic Estimation of Round-off Errors)**. CESTAC is a stochastic arithmetic method for assessing the numerical accuracy of computed results. Its principle relies on repeated stochastic evaluations and confidence-based estimation of significant digits. DSA extends synchronous CESTAC evaluations with the notion of computational zero and stochastic relations, providing diagnostics for numerically unstable comparisons and control flow.

## What it is - features

- Synchronous multi-lane stochastic floating-point arithmetic (`DSFloat{T,N}`)
- CADNA-inspired diagnostics
- Common elementary-function coverage on `DSFloat` (roots, trig/inverse trig, hyperbolic/inverse hyperbolic, exp/log families)
- Directed random rounding (`RoundDown`/`RoundUp`) per lane per operation
- CESTAC significant-digit estimates and computational zero (`@.0`)
- Stochastic relations (`s_eq`, `s_gt`, ...)



## Installation

 Install via 
```julia
Pkg.add("DSArith")
```

 or install with
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


## References


[1]  Chen, X., Hilaire, T. and Jézéquel, F. (2026) ‘Floating-point autotuning with customized precisions’. arXiv:2606.08339 [cs.MS]. Available at: https://arxiv.org/abs/2606.08339.

[2] Vignes, J. (2004) ‘Discrete stochastic arithmetic for validating results of numerical software’, *Numerical Algorithms*, 37(1–4), pp. 377–390. doi: 10.1023/B:NUMA.0000049483.75679.ce.

[3]  Chesneaux, J.-M. and Vignes, J. (1992) ‘Les fondements de l’arithmétique stochastique’, *Comptes Rendus de l’Académie des Sciences, Paris, Série I*, 315, pp. 1435–1440.

[4]  La Porte, M. and Vignes, J. (1974) ‘Étude statistique des erreurs dans l’arithmétique des ordinateurs; application au contrôle des résultats d’algorithmes numériques’, *Numerische Mathematik*, 23, pp. 63–72. doi: 10.1007/BF01409991.
