function mean_value(x::DSFloat{T,N}) where {T<:AbstractFloat,N}
    s = zero(Float64)
    @inbounds for i in 1:N
        s += Float64(x.samples[i])
    end
    return s / N
end

function std_value(x::DSFloat{T,N}) where {T<:AbstractFloat,N}
    N == 1 && return 0.0
    m = mean_value(x)
    acc = 0.0
    @inbounds for i in 1:N
        d = Float64(x.samples[i]) - m
        acc += d * d
    end
    return sqrt(acc / (N - 1))
end

function tau_beta(N::Integer, beta::Real)
    if N == 3 && isapprox(beta, 0.05; atol=1e-12)
        return 4.302652729911275
    end
    N <= 1 && return Inf
    return quantile(TDist(N - 1), 1 - beta / 2)
end

function significant_digits(x::DSFloat{T,N}; beta::Real=default_context().config.beta) where {T<:AbstractFloat,N}
    all(iszero, x.samples) && return -Inf

    m = abs(mean_value(x))
    σ = std_value(x)

    if σ == 0.0
        return m == 0.0 ? -Inf : 0.0
    end

    if m == 0.0
        return -Inf
    end

    τ = tau_beta(N, beta)
    return log10(sqrt(N) * m / (σ * τ))
end

function accuracy(x::DSFloat)
    cfg = default_context().config
    d = significant_digits(x)
    if isinf(d)
        return cfg.max_display_digits
    end
    if isnan(d)
        return 0
    end
    return clamp(floor(Int, d), 0, cfg.max_display_digits)
end

function iscomputedzero(x::DSFloat)
    all(iszero, x.samples) && return true
    return significant_digits(x) < 0
end

is_computed_zero(x::DSFloat) = iscomputedzero(x)
