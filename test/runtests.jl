using RayTracingWeekend
using Test

@testset "RayTracingWeekend.jl" begin
    include("test_xyz.jl")
    include("test_ray.jl")
end
