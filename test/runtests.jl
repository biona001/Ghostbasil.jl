using ghostbasil
using DelimitedFiles
using Test

@testset "block_group_ghostbasil" begin
    # basic test to make sure block_group_ghostbasil does not crash
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

    # Test correctness with a specific region from Pan-UKBB. 
    # The true answer is obtained from running the ghostbasil R package on
    # the given data. Note these data are based on LD summary statistics, 
    # which can be freely distributed
    datadir = normpath(ghostbasil.datadir())
    C = readdlm(joinpath(datadir, "C.txt"))
    S = readdlm(joinpath(datadir, "S.txt"))
    r = readdlm(joinpath(datadir, "r.txt")) |> vec
    lambda_path = readdlm(joinpath(datadir, "lambda_path.txt")) |> vec
    beta_i = block_group_ghostbasil(C, S, r, lambda_path)
    @test count(!iszero, beta_i) == 14
    non_zero_idx = findall(!iszero, beta_i)
    @test non_zero_idx == [215, 340, 341, 431, 559, 560, 763, 878,
        1085, 1528, 1770, 2726, 3157, 3387]
    @test all(beta_i[non_zero_idx] .≈ 
        [-0.0005451576807477974, -0.0002947665358369119, -0.014810108231841996, 
        -0.00043238505905553924, -0.006856782960094195, 0.0016850133196618926, 
        -0.00019274743491070077, -0.0003841629682186662, -0.0005758897376517483, 
        -0.0016095272344540995, 0.0020146776266541312, -0.001666736964454875, 
        0.0004269118551173737, 0.00010746291189108347]
    )
end
