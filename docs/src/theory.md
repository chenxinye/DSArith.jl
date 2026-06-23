# Theory

For a stochastic result with lanes \(R_i\), DSArith uses:

\[
\bar{R} = \frac{1}{N}\sum_i R_i, \quad
\sigma^2 = \frac{1}{N-1}\sum_i (R_i-\bar{R})^2
\]

\[
C_R = \log_{10}\left(\frac{\sqrt{N}|\bar{R}|}{\sigma\tau_\beta}\right)
\]

Computational zero is detected when all lanes are exactly zero or when \(C_R \le 0\).
