import Base
using RayTracingWeekend
using Test

@testset "Tests: hittable.jl" begin
    @testset "HitRecord2 types" begin
        s1 = Sphere2(Point{Float32}(0.0, 0.0, 0.0), 1.0f0, Metal(1.0f0, 0.0f0))
        s2 = Sphere2(Point{Float32}(0.0, 0.0, 0.0), 1.0f0, Lambertian(1.0f0))
    end
end