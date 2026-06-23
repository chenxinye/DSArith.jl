function reset_report!(rep::DSAReport)
    for evt in keys(rep.counters)
        rep.counters[evt] = 0
    end
    return rep
end

clear_diagnostics!() = reset_report!(default_context().report)
clear_diagnostics!(ctx::DSAContext) = reset_report!(ctx.report)

report() = default_context().report
report(ctx::DSAContext) = ctx.report

function report(x::DSFloat)
    return (
        mean = mean_value(x),
        sigma = std_value(x),
        significant_digits = significant_digits(x),
        accuracy = accuracy(x),
        computed_zero = iscomputedzero(x),
        samples = samples(x),
    )
end

diagnostics() = report()
diagnostics(ctx::DSAContext) = report(ctx)
diagnostic_counts() = copy(report().counters)
diagnostic_counts(ctx::DSAContext) = copy(report(ctx).counters)

function has_instability(rep::DSAReport)
    return any(rep.counters[evt] > 0 for evt in (
        unstable_multiplication,
        unstable_division,
        unstable_branching,
        unstable_cancellation,
    ))
end

function _log_event!(ctx::DSAContext, evt::DiagnosticEvent)
    ctx.config.use_diagnostics || return nothing
    ctx.report.counters[evt] = get(ctx.report.counters, evt, 0) + 1
    return nothing
end
