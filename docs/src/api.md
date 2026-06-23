# API Reference

## Core types

- `DSFloat`, `DSFloat64`, `DSFloat32`
- `DSAContext`, `DSAConfig`, `DSAReport`, `DiagnosticEvent`

## Constructors and context

- `ds`, `dsa`, `dsfloat`
- `with_context`, `default_context`, `set_default_context!`

## Statistics and reporting

- `samples`, `lanes`, `mean_value`, `std_value`
- `significant_digits`, `accuracy`
- `iscomputedzero`, `is_computed_zero`
- `stochastic_string`, `report`

## Elementary functions on `DSFloat`

- Roots: `sqrt`, `cbrt`
- Trigonometric: `sin`, `cos`, `tan`, `sec`, `csc`, `cot`
- Inverse trigonometric: `asin`, `acos`, `atan`, `asec`, `acsc`, `acot`
- Hyperbolic: `sinh`, `cosh`, `tanh`, `sech`, `csch`, `coth`
- Inverse hyperbolic: `asinh`, `acosh`, `atanh`, `asech`, `acsch`, `acoth`
- Exponential: `exp`, `exp2`, `exp10`, `expm1`
- Logarithmic: `log`, `log2`, `log10`, `log1p`

## Stochastic relations

- `s_eq`, `s_ne`, `s_gt`, `s_ge`, `s_lt`, `s_le`
- `compare_stochastic`

## Diagnostics and uncertainty helpers

- `diagnostics`, `diagnostic_counts`, `has_instability`
- `clear_diagnostics!`, `reset_report!`
- `uncertain`, `perturb_data`

## Module index

```@autodocs
Modules = [DSArith]
```
