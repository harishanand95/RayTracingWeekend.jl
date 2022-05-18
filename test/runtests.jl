using RayTracingWeekend
using Test

@testset "RayTracingWeekend.jl" begin
    include("test_xyz.jl")
    include("test_ray.jl")
    include("test_hittable.jl")
    include("test_functions.jl")
    include("test_chapters.jl")
end

