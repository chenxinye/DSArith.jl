const _TLS_CONTEXT_KEY = :__DSARITH_CONTEXT__

function _default_max_digits(T::Type{<:AbstractFloat})
    return T == Float32 ? 7 : 16
end

function DSAConfig(; beta::Float64=0.05, use_diagnostics::Bool=true,
    max_display_digits::Int=16, backend::Symbol=:exact_rational,
    bigfloat_precision::Int=256)
    return DSAConfig(beta, use_diagnostics, max_display_digits, backend, bigfloat_precision)
end

function DSAContext(; N::Int=3, seed::Integer=0,
    config::DSAConfig=DSAConfig(max_display_digits=16),
    rng_type::Type{R}=MersenneTwister) where {R<:AbstractRNG}
    rngs = ntuple(i -> rng_type(seed + i - 1), N)
    return DSAContext{N,R}(rngs, config, DSAReport())
end

const _default_context_ref = Ref{Any}(DSAContext())

function _tls_context()
    try
        return task_local_storage(_TLS_CONTEXT_KEY)
    catch
        return nothing
    end
end

default_context() = something(_tls_context(), _default_context_ref[])

function set_default_context!(ctx::DSAContext)
    _default_context_ref[] = ctx
    return ctx
end

context_lanes() = length(default_context().rngs)

function _context_for_lanes(N::Int)
    ctx = default_context()
    length(ctx.rngs) == N || throw(ArgumentError("active DSAContext lane count $(length(ctx.rngs)) does not match DSFloat lanes $N"))
    return ctx
end

function with_context(f::Function, ctx::DSAContext)
    prev = _tls_context()
    task_local_storage(_TLS_CONTEXT_KEY, ctx)
    try
        return f()
    finally
        if isnothing(prev)
            try
                delete!(task_local_storage(), _TLS_CONTEXT_KEY)
            catch
                task_local_storage(_TLS_CONTEXT_KEY, _default_context_ref[])
            end
        else
            task_local_storage(_TLS_CONTEXT_KEY, prev)
        end
    end
end

with_context(ctx::DSAContext, f::Function) = with_context(f, ctx)
