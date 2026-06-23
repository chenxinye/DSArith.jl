# Contributing

## Setup
```julia
import Pkg
Pkg.activate(".")
Pkg.instantiate()
Pkg.test()
```

## Style
- Keep API changes documented in README and docs.
- Add deterministic tests for stochastic behavior by setting explicit seeds.
- Use explicit `s_eq`, `s_gt`, etc. in DSA-sensitive logic.

## Pull requests
- Include tests for all functional changes.
- Keep changes focused and small.
