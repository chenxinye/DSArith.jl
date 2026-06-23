# DSArith.jl

[![CI](https://github.com/chenxinye/DSArith2.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/chenxinye/DSArith2.jl/actions/workflows/CI.yml)
[![Documentation](https://github.com/chenxinye/DSArith.jl/actions/workflows/Documentation.yml/badge.svg)](https://github.com/chenxinye/DSArith.jl/actions/workflows/Documentation.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)


``DSArith.jl`` implements **Discrete Stochastic Arithmetic (DSA)** in Julia with synchronous **Control and Stochastic Estimation of Rounding Errors (CESTAC, from french - Contrôle et Estimation STochastique des Arrondis de Calculs)** lanes. CESTAC is a numerical stability check method based on repeated stochastic evaluations and confidence-based significant-digit estimate. DSA method is an synchronous CESTAC lanes + computational zero + stochastic relations/diagnostics for numerically unstable control flow.



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


## References


[1] Avot-Chotin, R. and Mehrez, H. (2004) ‘Hardware implementation of discrete stochastic arithmetic’, *Numerical Algorithms*, 37(1–4), pp. 21–33. doi: 10.1023/B:NUMA.0000049455.07441.ee.

[2]  Chen, X., Hilaire, T. and Jézéquel, F. (2026) ‘Floating-point autotuning with customized precisions’. arXiv:2606.08339 [cs.MS]. Available at: https://arxiv.org/abs/2606.08339.

[3]  Chesneaux, J.-M. and Vignes, J. (1992) ‘Les fondements de l’arithmétique stochastique’, *Comptes Rendus de l’Académie des Sciences, Paris, Série I*, 315, pp. 1435–1440.

[4]  La Porte, M. and Vignes, J. (1974) ‘Étude statistique des erreurs dans l’arithmétique des ordinateurs; application au contrôle des résultats d’algorithmes numériques’, *Numerische Mathematik*, 23, pp. 63–72. doi: 10.1007/BF01409991.

[5]  Vignes, J. (1978) ‘New methods for evaluating the validity of the results of mathematical computations’, *Mathematics and Computers in Simulation*, 20(4), pp. 227–249. doi: 10.1016/0378-4754(78)90016-2.

[6] Vignes, J. (1987) ‘Zéro mathématique et zéro informatique’, *La Vie des Sciences, Comptes Rendus de l’Académie des Sciences, Série générale*, 4(1), pp. 1–13.

[7] Vignes, J. (1993) ‘A stochastic arithmetic for reliable scientific computation’, *Mathematics and Computers in Simulation*, 35(3), pp. 233–261. doi: 10.1016/0378-4754(93)90003-D.

[8] Vignes, J. (2004) ‘Discrete stochastic arithmetic for validating results of numerical software’, *Numerical Algorithms*, 37(1–4), pp. 377–390. doi: 10.1023/B:NUMA.0000049483.75679.ce.

[9] Vignes, J. and La Porte, M. (1974) ‘Error analysis in computing’, in Rosenfeld, J.L. (ed.) *Information Processing 74: Proceedings of IFIP Congress 74, Stockholm, Sweden, 5–10 August 1974*. Amsterdam: North-Holland, pp. 610–614.
