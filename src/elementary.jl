import Base: sqrt, cbrt
import Base: sin, cos, tan, sec, csc, cot
import Base: asin, acos, atan, asec, acsc, acot
import Base: sinh, cosh, tanh, sech, csch, coth
import Base: asinh, acosh, atanh, asech, acsch, acoth
import Base: exp, exp2, exp10, expm1
import Base: log, log2, log10, log1p

function _map_unary_big(f::Function, x::DSFloat{T,N}; domain::Function=(v->true)) where {T<:AbstractFloat,N}
    ctx = _context_for_lanes(N)
    vals = ntuple(i -> begin
        xi = x.samples[i]
        if !domain(xi)
            _log_event!(ctx, domain_error)
            return convert(T, NaN)
        end
        rnd = choose_rounding(rand(ctx.rngs[i], Bool))
        yi = _directed_unary_big_lane(f, xi, rnd, ctx)
        if isnan(yi)
            _log_event!(ctx, invalid_operation)
        end
        yi
    end, N)
    return DSFloat{T,N}(vals)
end

sqrt(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(sqrt, x; domain=v->(isnan(v) || v >= 0))
cbrt(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(cbrt, x)

sin(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(sin, x)
cos(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(cos, x)
tan(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(tan, x)
sec(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(sec, x)
csc(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(csc, x)
cot(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(cot, x)

asin(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(asin, x; domain=v->(isnan(v) || (-one(v) <= v <= one(v))))
acos(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(acos, x; domain=v->(isnan(v) || (-one(v) <= v <= one(v))))
atan(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(atan, x)
asec(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(asec, x; domain=v->(isnan(v) || abs(v) >= one(v)))
acsc(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(acsc, x; domain=v->(isnan(v) || abs(v) >= one(v)))
acot(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(acot, x)

sinh(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(sinh, x)
cosh(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(cosh, x)
tanh(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(tanh, x)
sech(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(sech, x)
csch(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(csch, x)
coth(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(coth, x)

asinh(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(asinh, x)
acosh(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(acosh, x; domain=v->(isnan(v) || v >= one(v)))
atanh(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(atanh, x; domain=v->(isnan(v) || abs(v) < one(v)))
asech(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(asech, x; domain=v->(isnan(v) || (zero(v) < v <= one(v))))
acsch(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(acsch, x; domain=v->(isnan(v) || !iszero(v)))
acoth(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(acoth, x; domain=v->(isnan(v) || abs(v) > one(v)))

exp(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(exp, x)
exp2(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(exp2, x)
exp10(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(exp10, x)
expm1(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(expm1, x)

log(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(log, x; domain=v->(isnan(v) || v > 0))
log2(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(log2, x; domain=v->(isnan(v) || v > 0))
log10(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(log10, x; domain=v->(isnan(v) || v > 0))
log1p(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(log1p, x; domain=v->(isnan(v) || v > -one(v)))
