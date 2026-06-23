# Examples

The repository includes executable examples under `examples/`:

- `rump.jl` — Rump polynomial instability benchmark
- `catastrophic_cancellation.jl` — cancellation amplification
- `muller_sequence.jl` — recurrence sensitivity
- `logistic_map.jl` — chaotic iteration with significance decay
- `branching_instability.jl` — stochastic branch divergence
- `summation_kahan.jl` — naive vs Kahan summation under DSA
- `hilbert_solve.jl` — linear-system conditioning stress test

Run any example:

```bash
julia --project=. examples/rump.jl
```

## Typical usage pattern

```julia
using DSArith

val = (ds(1.0) + ds(1e-16)) - ds(1.0)
println(stochastic_string(val))
println(report(val))
```

Typical workflow:

1. replace key `Float64` values with `ds(...)`,
2. compute as usual,
3. inspect `report(...)` and diagnostics,
4. use low significance / `@.0` as a trigger for algorithmic improvements.
