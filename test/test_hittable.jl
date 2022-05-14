using RayTracingWeekend
using Test

@testset "Tests: hittable.jl" begin
    @testset "HitRecord types" begin
        hr = get_hit_record()
        @test hr.p == Point{Float32}(0.0, 0.0, 0.0)
        @test hr.normal == Vec{Float32}(0.0, 0.0, 0.0)
        @test hr.t == Float32(0.0)
        @test hr.front_face == false
    end
end

@testset "Tests: hittable.jl" begin
    @testset "Hittable tests" begin
        world = Vector{Hittable}()
        add!(world, Sphere(Point{Float32}(0, 0, -1), 0.5))
        add!(world, Sphere(Point{Float32}(0, 0, -1), 0.5))
        @test size(world) == (2,)
        clear!(world)
        add!(world, Sphere(Point{Float32}(0, 0, -1), 0.5))
        @test size(world) == (1,)
    end
end