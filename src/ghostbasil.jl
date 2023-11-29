module ghostbasil

using CxxWrap
using ghostbasil_jll

@wrapmodule(ghostbasil_jll.get_libghostbasil_wrap_path)

function __init__()
    @initcxx
end

function block_group_ghostbasil(
    Ci::Matrix{Float64}, 
    Si_scaled::Matrix{Float64}, 
    r::Vector{Float64}, 
    lambda_path::Vector{Float64};
    m::Int = 5,
    max_n_lambdas::Int = 100,
    lambdas_iter::Int = 5,
    use_strong_rule::Bool = false,
    do_early_exit::Bool = true,
    delta_strong_size::Int = 500,
    max_strong_size::Int = (m+1)*size(Ci, 1),
    max_n_cds::Int = 100000,
    thr::Float64 = 1e-7,
    min_ratio::Float64 = 1e-2,
    n_threads::Int = 1,
    )
    # check for errors
    p = size(Ci, 1)
    size(Ci) == size(Si_scaled) || error("Expected size(Ci) == size(Si_scaled)")
    length(r) == (m+1)*p || error("Expected length(r) == $((m+1)*p)")
    issorted(lambda_path, rev=true) || 
        error("lambda_path should be sorted from largest to smallest")
    isapprox(Ci, Ci', atol=1e-8) || error("Ci is not symmetric")
    isapprox(Si_scaled, Si_scaled', atol=1e-8) || 
        error("Si_scaled is not symmetric")
    (m > 0) && (max_n_lambdas > 0) && (lambdas_iter > 0) && 
        (max_n_cds > 0) && (thr > 0) && (min_ratio > 0) || 
        error("Expected m, max_n_lambdas, lambdas_iter, max_n_cds, thr, min_ratio all to be > 0")

    return block_group_ghostbasil(Ci, Si_scaled, r, lambda_path, 
        m, p, max_n_lambdas, lambdas_iter, use_strong_rule, do_early_exit, 
        delta_strong_size, max_strong_size, max_n_cds, thr, min_ratio, n_threads)
end

export block_group_ghostbasil

datadir(parts...) = joinpath(@__DIR__, "..", "data", parts...)

end
