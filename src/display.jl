using Printf

function stochastic_string(x::DSFloat; sci::Bool=true)
    if iscomputedzero(x)
        return "@.0"
    end

    m = mean_value(x)
    sig = max(1, accuracy(x))

    if sci
        return @sprintf("%.*e", sig - 1, m)
    else
        return @sprintf("%.*g", sig, m)
    end
end

function Base.show(io::IO, x::DSFloat)
    print(io, stochastic_string(x))
end
