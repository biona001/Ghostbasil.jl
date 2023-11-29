using ghostbasil
using Test

@testset "block_group_ghostbasil" begin
    p = 10 # number of features
    m = 5  # number of knockoffs
    x = randn(p, p)
    y = randn(p, p)
    Ci = x'*x
    Si = y'*y
    r = randn(6p)
    lambda_path = [0.1, 0.05, 0.01, 0.001]
    beta_i = ghostbasil.block_group_ghostbasil(Ci, Si, r, lambda_path, m=m)

    @test length(beta_i) == (m+1)*p
end
