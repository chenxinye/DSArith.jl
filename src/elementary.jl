import Base: sqrt, sin, cos, tan, exp, log

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
sin(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(sin, x)
cos(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(cos, x)
tan(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(tan, x)
exp(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(exp, x)
log(x::DSFloat{T,N}) where {T<:AbstractFloat,N} = _map_unary_big(log, x; domain=v->(isnan(v) || v > 0))
