using RayTracingWeekend
import Images.RGB
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

println("sky_color()")
@btime sky_color(ray)
@test_no_allocs sky_color(ray)
@assert typeof(sky_color(ray)) == RGB{Float32}


println("get_camera()")
@btime get_camera()
@test_no_allocs get_camera()
@assert typeof(get_camera()) == Camera

println("get_camera(;aspect_ratio=Float32(16/9), viewport_height=Float32(2.0), focal_length=Float32(1.0))")
@btime get_camera(;aspect_ratio=2.0f0, viewport_height=10.0f0, focal_length=1.0f0)
@test_no_allocs get_camera()
@assert typeof(get_camera()) == Camera

c=get_camera()
println("get_ray()")
@btime get_ray(c, 10.0f0, 5000.0f0)
@test_no_allocs get_ray(c, 10.0f0, 5000.0f0)
@assert typeof(get_ray(c, 10.0f0, 5000.0f0)) == Ray

println("get_sampled_color()")
@btime get_sampled_color(RGB{Float32}(rand()), Int32(10))
@test_no_allocs get_sampled_color(RGB{Float32}(rand()),  Int32(10))
@assert typeof(get_sampled_color(RGB{Float32}(rand()),  Int32(10))) == RGB{Float32}


println("get_camera(vfov::Float32, aspect_ratio::Float32)")
@btime get_camera(10.0f0, 50.0f0)
@test_no_allocs get_camera(10.0f0, 50.0f0)
@assert typeof(get_camera(10.0f0, 50.0f0)) == Camera

println("get_camera(lookfrom::Point{Float32}, lookat::Point{Float32}, vup::Vec{Float32}, vfov::Float32, aspect_ratio::Float32)")
@btime get_camera(p1, at(ray, t), v1, 10.0f0, 50.0f0)
# @test_no_allocs get_camera(p1, at(ray, t), v1, 10.0f0, 50.0f0) # some allocation occur


# Camera
lookfrom = Point{Float32}(13,2,3)
lookat = Point{Float32}(0,0,0)
vup = Vec{Float32}(0,1,0)
dist_to_focus = 10.0f0
aperture = 0.1f0

cam = get_camera(lookfrom, lookat, vup, 20.0f0, Float32(16/9), aperture, dist_to_focus)

@btime get_camera(lookfrom, lookat, vup, 20.0f0, Float32(16/9), aperture, dist_to_focus)
@test_no_allocs get_camera(lookfrom, lookat, vup, 20.0f0, Float32(16/9), aperture, dist_to_focus)



@btime get_ray(cam, 1.0f0, 10.0f0)
@test_no_allocs get_ray(cam, 1.0f0, 10.0f0)


@btime get_hit_record(Lambertian(0.0f0)) 
# @test_no_allocs get_hit_record(Lambertian(0.0f0)) # some allocation occur
