using RayTracingWeekend

using BenchmarkTools
using StaticArrays
using Test

"Modified from BenchmarkTools @ballocated. Returns number of heap allocations, instead of bytes."
macro ballocs(args...)
    return esc(quote
        $BenchmarkTools.allocs($BenchmarkTools.minimum($BenchmarkTools.@benchmark $(args...)))
    end)
end

"Test passes if `args...` causes no heap allocations."
macro test_no_allocs(args...)
    return esc(quote
        # limit number of samples to 3... since the variance is extremely low
        @test (@ballocs $(args...) samples=3) == 0
    end)
end

println("len_squared()")
p1 = Point{Float32}(0, 0, 1)
@btime len_squared($p1)
@test_no_allocs len_squared($p1)
@assert typeof(len_squared(p1)) == Float32

println("len()")
p1 = Point{Float32}(0, 0, 1)
@btime len($p1)
@test_no_allocs len($p1)
@assert typeof(len(p1)) == Float32

println("to_vec()")
p1 = Point{Float32}(0, 0, 1)
@btime to_vec($p1)
@test_no_allocs to_vec($p1)
@assert typeof(to_vec(p1)) == Vec{Float32}

println("to_point()")
v1 = Vec{Float32}(0, 0, 1)
@btime to_point($v1)
@test_no_allocs to_point($v1)
@assert typeof(to_point(v1)) == Point{Float32}

println("random_vector()")
@btime random_vector(1.0f0, 2.0f0)
@test_no_allocs random_vector(1.0f0, 2.0f0)

println("unit_vector()")
@btime unit_vector(v1)
@test_no_allocs unit_vector(v1)

t = 10.0f0
ray = Ray(p1, v1)
println("at()")
@btime at(ray, t)
@test_no_allocs at(ray, t)

println("pixel_color()")
@btime pixel_color(p1)
@test_no_allocs pixel_color(p1)

println("degrees_to_radians()")
@btime degrees_to_radians($t)
@test_no_allocs degrees_to_radians($t)

println("random_in_unit_sphere()")
@btime random_in_unit_sphere()
@test_no_allocs random_in_unit_sphere()

println("random_in_unit_sphere()")
@btime random_in_unit_sphere(true)
@test_no_allocs random_in_unit_sphere(true)

println("near_zero()")
@btime near_zero(v1)
@test_no_allocs near_zero(v1)

println("reflect()")
@btime reflect(v1, v1)
@test_no_allocs reflect(v1, v1)
@assert typeof(reflect(v1, v1)) == Vec{Float32}

println("random_in_unit_disk()")
@btime random_in_unit_disk()
@test_no_allocs random_in_unit_disk()
@assert typeof(random_in_unit_disk()) == Vec{Float32}