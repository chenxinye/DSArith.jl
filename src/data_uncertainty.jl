function _apply_ulp_offset(x::T, k::Int) where {T<:AbstractFloat}
    y = x
    if k > 0
        for _ in 1:k
            y = nextfloat(y)
        end
    elseif k < 0
        for _ in 1:(-k)
            y = prevfloat(y)
        end
    end
    return y
end

function perturb_data(x::DSFloat{T,N}; rel::Real=0.0, abs::Real=0.0, ulps::Integer=0, seed=nothing) where {T<:AbstractFloat,N}
    ctx = _context_for_lanes(N)
    if isnothing(seed)
        rngs = ctx.rngs
    else
        rngs = ntuple(i -> MersenneTwister(seed + i - 1), N)
    end

    vals = ntuple(i -> begin
        r = rngs[i]
        xi = x.samples[i]
        yi = xi * (one(T) + convert(T, rel) * convert(T, randn(r))) + convert(T, abs) * convert(T, randn(r))
        if ulps > 0
            k = rand(r, -ulps:ulps)
            yi = _apply_ulp_offset(yi, k)
        end
        yi
    end, N)

    return DSFloat{T,N}(vals)
end

function uncertain(x::Real; rel::Real=0.0, abs::Real=0.0, ulps::Integer=0, seed=nothing,
    T::Type{<:AbstractFloat}=Float64, N::Union{Nothing,Int}=nothing)
    base = dsfloat(x; T=T, N=N)
    return perturb_data(base; rel=rel, abs=abs, ulps=ulps, seed=seed)
end

uncertain(x::DSFloat; kwargs...) = perturb_data(x; kwargs...)
