# Based on https://raytracing.github.io/books/RayTracingInOneWeekend.html
using RayTracingWeekend
using Test

@testset "Tests: xyz.jl" begin
    @testset "Point Vec types" begin
        p = Point{Float32}(1.0, 2.0, 3.0)
        minus_p = Point{Float32}(-1.0, -2.0, -3.0)
        @test minus_p == -p

        v = Vec{Float32}(1.0, 2.0, 3.0)
        minus_v = Vec{Float32}(-1.0, -2.0, -3.0)
        @test minus_v == -v

        vtimes3 = 3*v
        @test vtimes3 == Vec{Float32}(3.0, 6.0, 9.0)
        ptimes3 = 3*p
        @test ptimes3 == Point{Float32}(3.0, 6.0, 9.0)

        vdiv3 = vtimes3/3
        @test vdiv3 == Vec{Float32}(1.0, 2.0, 3.0)
        pdiv3 = ptimes3/3
        @test pdiv3 == Point{Float32}(1.0, 2.0, 3.0)
    end
    @testset "len test" begin
        p = Point{Float32}(0,3,4)
        @test len(p) == 5.0
    end
    @testset "len_squared test" begin
        p = Point{Float32}(0,3,4)
        @test len_squared(p) == 25.0
    end
    @testset "× cross product test" begin
        p1 = Vec{Float32}(1.0, 2.0, 3.0)
        p2 = Vec{Float32}(1.0, 2.0, 3.0)
        p3 = p1 × p2
        @test p3 == Vec{Float32}(0.0, 0.0, 0.0)
    end
    @testset "⋅ dot product test" begin
        v1 = Vec{Float32}(0,3,4)
        v2 = Vec{Float32}(0,3,4)
        res = v1 ⋅ v2
        @test res == 25.0f0
    end
    @testset "+ addition test" begin
        p1 = Point{Float32}(1.0, 2.0, 4.0)
        p2 = Point{Float32}(1.0, 2.0, 4.0)
        p3_ = p1 + p2
        @test Point{Float32}(2.0, 4.0, 8.0) == p3_
        
        p1 = Vec{Float32}(1.0, 2.0, 4.0)
        p2 = Vec{Float32}(1.0, 2.0, 4.0)
        p3_ = p1 + p2
        @test Vec{Float32}(2.0, 4.0, 8.0) == p3_
    end
    @testset "- subtraction test" begin
        p1 = Point{Float32}(1.0, 2.0, 4.0)
        p2 = Point{Float32}(1.0, 2.0, 4.0)
        p3_ = p1 - p2
        @test Point{Float32}(0.0, 0.0, 0.0) == p3_
        
        p1 = Vec{Float32}(1.0, 2.0, 4.0)
        p2 = Vec{Float32}(1.0, 2.0, 4.0)
        p3_ = p1 - p2
        @test Vec{Float32}(0.0, 0.0, 0.0) == p3_
    end
    @testset "to_vec, to_point test" begin
        x1 = Point{Float32}(1.0, 2.0, 3.0)
        v1 = to_vec(x1)
        @test Vec{Float32}(1.0, 2.0, 3.0) == v1
        t1 = to_point(v1)
        @test t1 == x1
    end
end
