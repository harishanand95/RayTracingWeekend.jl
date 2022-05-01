import Base
using RayTracingWeekend
using Test

@testset "Tests: ray.jl" begin
    @testset "Ray types" begin
        o = Point{Float32}(0.0, 0.0, 0.0)
        d = Vec{Float32}(1.0, 1.0, 10.0)
        r = Ray(o, d)
    end
    @testset "at function" begin
        o = Point{Float32}(0.0, 0.0, 0.0)
        d = Vec{Float32}(1.0, 1.0, 10.0)
        r = Ray(o, d)
        out1 = at(r, 1.0)
        @test out1.x == 1.0
        @test out1.y == 1.0
        @test out1.z == 10.0

        out2 = at(r, 10.0)
        @test out2.x == 10.0
        @test out2.y == 10.0
        @test out2.z == 100.0

        out3 = at(r, -10.0)
        @test out3.x == -10.0
        @test out3.y == -10.0
        @test out3.z == -100.0
    end
end