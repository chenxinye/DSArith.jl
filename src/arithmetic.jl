import Base: +, -, *, /, ^, inv, abs, sqrt

function _map_binary(op::Function, x::DSFloat{T,N}, y::DSFloat{T,N}) where {T<:AbstractFloat,N}
    ctx = _context_for_lanes(N)
    vals = ntuple(i -> begin
        rnd = choose_rounding(rand(ctx.rngs[i], Bool))
        _directed_binary_lane(op, x.samples[i], y.samples[i], rnd)
    end, N)
    return DSFloat{T,N}(vals)
end

function _check_cancellation!(x::DSFloat, y::DSFloat, z::DSFloat)
    ctx = _context_for_lanes(length(z.samples))
    !ctx.config.use_diagnostics && return nothing

    xz = iscomputedzero(x)
    yz = iscomputedzero(y)
    zz = iscomputedzero(z)

    if zz && !xz && !yz
        _log_event!(ctx, unstable_cancellation)
        return nothing
    end

    sx = significant_digits(x)
    sy = significant_digits(y)
    sz = significant_digits(z)
    if isfinite(sx) && isfinite(sy) && isfinite(sz)
        if min(sx, sy) - sz >= 3 && min(sx, sy) > 0
            _log_event!(ctx, unstable_cancellation)
        end
    end

    return nothing
end

+(x::DSFloat{T,N}, y::DSFloat{T,N}) where {T<:AbstractFloat,N} = begin
    z = _map_binary(+, x, y)
    _check_cancellation!(x, y, z)
    z
end

-(x::DSFloat{T,N}, y::DSFloat{T,N}) where {T<:AbstractFloat,N} = begin
    z = _map_binary(-, x, y)
    _check_cancellation!(x, y, z)
    z
end

*(x::DSFloat{T,N}, y::DSFloat{T,N}) where {T<:AbstractFloat,N} = begin
    z = _map_binary(*, x, y)
    ctx = _context_for_lanes(N)
    if (iscomputedzero(x) || accuracy(x) == 0) && (iscomputedzero(y) || accuracy(y) == 0)
        _log_event!(ctx, unstable_multiplication)
    end
    z
end

/(x::DSFloat{T,N}, y::DSFloat{T,N}) where {T<:AbstractFloat,N} = begin
    ctx = _context_for_lanes(N)
    if iscomputedzero(y)
        _log_event!(ctx, unstable_division)
    end
    _map_binary(/, x, y)
end

-(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = DSFloat{T,N}(ntuple(i -> -x.samples[i], N))

for op in (:+, :-, :*, :/)
    @eval begin
        ($op)(x::DSFloat{T,N}, y::Real) where {T<:AbstractFloat,N} = ($op)(x, convert(DSFloat{T,N}, y))
        ($op)(x::Real, y::DSFloat{T,N}) where {T<:AbstractFloat,N} = ($op)(convert(DSFloat{T,N}, x), y)
    end
end

inv(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = one(x) / x
abs(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = DSFloat{T,N}(ntuple(i -> abs(x.samples[i]), N))

function ^(x::DSFloat{T,N}, n::Integer) where {T<:AbstractFloat,N}
    if n == 0
        return one(x)
    elseif n < 0
        return inv(x ^ (-n))
    end
    r = one(x)
    b = x
    k = n
    while k > 0
        if isodd(k)
            r *= b
        end
        k >>= 1
        k == 0 && break
        b *= b
    end
    return r
end

Base.muladd(x::DSFloat, y::DSFloat, z::DSFloat) = x * y + z
Base.fma(x::DSFloat, y::DSFloat, z::DSFloat) = x * y + z
