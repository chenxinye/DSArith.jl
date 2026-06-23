function _as_ds_pair(x::DSFloat{T,N}, y::DSFloat{S,N}) where {T<:AbstractFloat,S<:AbstractFloat,N}
    return promote(x, y)
end

_as_ds_pair(x::DSFloat{T,N}, y::Real) where {T<:AbstractFloat,N} = (x, convert(DSFloat{T,N}, y))
_as_ds_pair(x::Real, y::DSFloat{T,N}) where {T<:AbstractFloat,N} = (convert(DSFloat{T,N}, x), y)

function s_eq(x::Union{DSFloat,Real}, y::Union{DSFloat,Real})
    dx, dy = _as_ds_pair(x, y)
    d = dx - dy
    z = iscomputedzero(d)
    z && _log_event!(_context_for_lanes(length(dx.samples)), unstable_branching)
    return z
end

s_ne(x::Union{DSFloat,Real}, y::Union{DSFloat,Real}) = !s_eq(x, y)

function s_gt(x::Union{DSFloat,Real}, y::Union{DSFloat,Real})
    dx, dy = _as_ds_pair(x, y)
    d = dx - dy
    z = iscomputedzero(d)
    z && _log_event!(_context_for_lanes(length(dx.samples)), unstable_branching)
    return mean_value(dx) > mean_value(dy) && !z
end

function s_ge(x::Union{DSFloat,Real}, y::Union{DSFloat,Real})
    dx, dy = _as_ds_pair(x, y)
    d = dx - dy
    z = iscomputedzero(d)
    z && _log_event!(_context_for_lanes(length(dx.samples)), unstable_branching)
    return mean_value(dx) >= mean_value(dy) || z
end

s_lt(x::Union{DSFloat,Real}, y::Union{DSFloat,Real}) = s_gt(y, x)
s_le(x::Union{DSFloat,Real}, y::Union{DSFloat,Real}) = s_ge(y, x)

function compare_stochastic(x::Union{DSFloat,Real}, y::Union{DSFloat,Real})
    dx, dy = _as_ds_pair(x, y)
    d = dx - dy
    if iscomputedzero(d)
        _log_event!(_context_for_lanes(length(dx.samples)), unstable_branching)
        mx, my = mean_value(dx), mean_value(dy)
        if mx == my
            return :eq_noise
        elseif mx < my
            return :le
        else
            return :ge
        end
    end
    return mean_value(dx) < mean_value(dy) ? :lt : :gt
end

Base.:(==)(x::DSFloat, y::Union{DSFloat,Real}) = s_eq(x, y)
Base.:(==)(x::Real, y::DSFloat) = s_eq(x, y)
Base.isless(x::DSFloat, y::Union{DSFloat,Real}) = s_lt(x, y)
Base.isless(x::Real, y::DSFloat) = s_lt(x, y)
Base.:(<)(x::DSFloat, y::Union{DSFloat,Real}) = s_lt(x, y)
Base.:(<)(x::Real, y::DSFloat) = s_lt(x, y)
Base.:(<=)(x::DSFloat, y::Union{DSFloat,Real}) = s_le(x, y)
Base.:(<=)(x::Real, y::DSFloat) = s_le(x, y)
Base.:(>)(x::DSFloat, y::Union{DSFloat,Real}) = s_gt(x, y)
Base.:(>)(x::Real, y::DSFloat) = s_gt(x, y)
Base.:(>=)(x::DSFloat, y::Union{DSFloat,Real}) = s_ge(x, y)
Base.:(>=)(x::Real, y::DSFloat) = s_ge(x, y)
