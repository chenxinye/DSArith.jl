struct DSFloat{T<:AbstractFloat,N} <: Real
    samples::NTuple{N,T}
end

const DSFloat64 = DSFloat{Float64,3}
const DSFloat32 = DSFloat{Float32,3}

struct DSAConfig
    beta::Float64
    use_diagnostics::Bool
    max_display_digits::Int
    backend::Symbol
    bigfloat_precision::Int
end

@enum DiagnosticEvent begin
    unstable_multiplication
    unstable_division
    unstable_branching
    unstable_cancellation
    domain_error
    invalid_operation
end

mutable struct DSAReport
    counters::Dict{DiagnosticEvent,Int}
end

mutable struct DSAContext{N,RNG<:AbstractRNG}
    rngs::NTuple{N,RNG}
    config::DSAConfig
    report::DSAReport
end

DSAReport() = DSAReport(Dict(evt => 0 for evt in instances(DiagnosticEvent)))

Base.broadcastable(x::DSFloat) = Ref(x)
Base.eltype(::Type{DSFloat{T,N}}) where {T,N} = T
Base.length(::DSFloat{T,N}) where {T,N} = N

samples(x::DSFloat) = x.samples
lanes(x::DSFloat) = x.samples

DSFloat{T,N}(x::Real) where {T<:AbstractFloat,N} = DSFloat{T,N}(ntuple(_ -> convert(T, x), N))

Base.zero(::Type{DSFloat{T,N}}) where {T,N} = DSFloat{T,N}(zero(T))
Base.zero(x::DSFloat{T,N}) where {T,N} = DSFloat{T,N}(zero(T))
Base.one(::Type{DSFloat{T,N}}) where {T,N} = DSFloat{T,N}(one(T))
Base.one(x::DSFloat{T,N}) where {T,N} = DSFloat{T,N}(one(T))

Base.convert(::Type{DSFloat{T,N}}, x::Real) where {T<:AbstractFloat,N} = DSFloat{T,N}(x)
Base.convert(::Type{DSFloat{T,N}}, x::DSFloat{S,N}) where {T<:AbstractFloat,S<:AbstractFloat,N} =
    DSFloat{T,N}(ntuple(i -> convert(T, x.samples[i]), N))

Base.promote_rule(::Type{DSFloat{T,N}}, ::Type{S}) where {T<:AbstractFloat,S<:Real,N} = DSFloat{promote_type(T, float(S)),N}
Base.promote_rule(::Type{S}, ::Type{DSFloat{T,N}}) where {T<:AbstractFloat,S<:Real,N} = DSFloat{promote_type(T, float(S)),N}

function dsfloat(x::Real; T::Type{<:AbstractFloat}=Float64, N::Union{Nothing,Int}=nothing)
    n = isnothing(N) ? context_lanes() : N
    return DSFloat{T,n}(x)
end

ds(x::Real; kwargs...) = dsfloat(x; kwargs...)
dsa(x::Real; kwargs...) = dsfloat(x; kwargs...)

Base.float(x::DSFloat{T,N}) where {T,N} = mean_value(x)
Base.real(x::DSFloat) = x
Base.abs2(x::DSFloat) = x * x
