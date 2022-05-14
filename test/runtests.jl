using RayTracingWeekend
using Test
using Random

@testset "RayTracingWeekend.jl" begin
    Random.seed!(1234)
    include("test_xyz.jl")
    include("test_ray.jl")
    include("test_hittable.jl")
    include("test_chapters.jl")
end
