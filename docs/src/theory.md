# Theory

For a stochastic result with lanes \(R_i\), DSArith computes:

\[
\bar{R} = \frac{1}{N}\sum_i R_i, \quad
\sigma^2 = \frac{1}{N-1}\sum_i (R_i-\bar{R})^2
\]

\[
C_R = \log_{10}\left(\frac{\sqrt{N}|\bar{R}|}{\sigma\tau_\beta}\right)
\]

Where:

- \(N\): number of stochastic lanes,
- \(\tau_\beta\): Student-\(t\) quantile for confidence level \(1-\beta\),
- \(C_R\): estimated number of significant decimal digits.

## Interpretation

- Larger \(C_R\) means more reliable digits.
- `accuracy(x)` is the clamped integer form of \(C_R\).
- `iscomputedzero(x)` indicates results interpreted as computational zero.

## Computational zero criterion

DSArith marks a result as computational zero when:

1. all lanes are exactly zero, or
2. significance is negative / insufficient under the DSA estimate.

This is the mechanism behind `@.0` output in unstable cancellation scenarios.
