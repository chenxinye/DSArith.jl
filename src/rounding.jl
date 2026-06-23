function _float_bits(x::Float64)
    bits = reinterpret(UInt64, x)
    sign = ((bits >> 63) & 0x1) == 1
    expbits = Int((bits >> 52) & 0x7ff)
    frac = bits & 0x000f_ffff_ffff_ffff
    return sign, expbits, frac
end

function _float_bits(x::Float32)
    bits = reinterpret(UInt32, x)
    sign = ((bits >> 31) & 0x1) == 1
    expbits = Int((bits >> 23) & 0xff)
    frac = bits & 0x007f_ffff
    return sign, expbits, frac
end

function exact_rational(x::T) where {T<:Union{Float32,Float64}}
    if isnan(x) || isinf(x)
        throw(DomainError(x, "special floating-point value does not have finite rational representation"))
    end
    x == zero(T) && return zero(BigInt) // one(BigInt)

    if T == Float64
        sign, expbits, frac = _float_bits(Float64(x))
        ebits = 11
        sbits = 52
        bias = 1023
    else
        sign, expbits, frac = _float_bits(Float32(x))
        ebits = 8
        sbits = 23
        bias = 127
    end

    expmax = (1 << ebits) - 1
    expbits == expmax && throw(DomainError(x, "special floating-point value does not have finite rational representation"))

    if expbits == 0
        significand = BigInt(frac)
        exponent = 1 - bias - sbits
    else
        significand = BigInt((UInt64(1) << sbits) + UInt64(frac))
        exponent = expbits - bias - sbits
    end

    numerator = sign ? -significand : significand
    if exponent >= 0
        numerator <<= exponent
        denominator = one(BigInt)
    else
        denominator = one(BigInt) << (-exponent)
    end

    return numerator // denominator
end

function directed_convert(::Type{T}, q::Rational{BigInt}, rnd::RoundingMode) where {T<:AbstractFloat}
    b = BigFloat(q)
    y = convert(T, b)

    !isfinite(y) && return y

    yq = exact_rational(y)
    if yq == q
        return y
    elseif yq < q
        down = y
        up = nextfloat(y)
    else
        down = prevfloat(y)
        up = y
    end

    if rnd === RoundDown
        return down
    elseif rnd === RoundUp
        return up
    else
        throw(ArgumentError("unsupported rounding mode $rnd"))
    end
end

choose_rounding(r::Bool) = r ? RoundUp : RoundDown

function _directed_binary_lane(op::Function, x::T, y::T, rnd::RoundingMode) where {T<:AbstractFloat}
    if !isfinite(x) || !isfinite(y)
        return op(x, y)
    end

    if op === (/) && y == zero(T)
        return x / y
    end

    qx = exact_rational(x)
    qy = exact_rational(y)
    q = op(qx, qy)
    return directed_convert(T, q, rnd)
end

function _directed_unary_big_lane(f::Function, x::T, rnd::RoundingMode, ctx::DSAContext) where {T<:AbstractFloat}
    if !isfinite(x)
        return f(x)
    end

    setprecision(ctx.config.bigfloat_precision) do
        b = f(BigFloat(x))
        if !isfinite(b)
            return convert(T, b)
        end
        q = Rational{BigInt}(b)
        return directed_convert(T, q, rnd)
    end
end
