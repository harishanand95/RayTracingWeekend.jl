using Images, ImageView, BenchmarkTools
using RayTracingWeekend
using Distributions
import RayTracingWeekend.⋅ # Images has \cdot so specifying which one to use
using Random
Random.seed!(1234)
using Base.Threads

# Ray color with recursion depth
function ray_color(ray::Ray, world::Vector{<:Hittable}, depth::Int32)
  # If we've exceeded the ray bounce limit, no more light is gathered.
  if (depth <= 0)
    return RGB{Float32}(0,0,0)
  end

  rec = get_hit_record(Metal(0.0f0, 0.0f0))
  if hit(world, ray, Float32(0.001), typemax(Float32), rec)
    result, attenuation, scattered = scatter(rec.material, ray, rec)
    if result
      r_color = ray_color(scattered, world, Int32(depth-1))
      return RGB{Float32}(attenuation.r*r_color.r, attenuation.g*r_color.g, attenuation.b*r_color.b)
    end
    return RGB{Float32}(0,0,0)
  end

  unit_direction = unit_vector(ray.direction)
  t = Float32(0.5*(unit_direction.y + 1.0))
  return (1.0f0-t)*RGB{Float32}(1.0, 1.0, 1.0) + t*RGB{Float32}(0.5, 0.7, 1.0)
end


function random_scene()
  world = Vector{Hittable}()

  # Materials
  material_ground = Lambertian(RGB{Float32}(0.5, 0.5, 0.5))
  add!(world, Sphere2(Point{Float32}(0, -1000, 0), 1000.0f0, material_ground))

  for a in -11:10
    for b in -11:10
      choose_mat = rand(Float32)
      center = Point{Float32}(a + 0.9*rand(Float32), 0.2, b + 0.9*rand(Float32))
      if (len(center - Point{Float32}(4, 0.2, 0)) > 0.9)
        # diffuse
        if (choose_mat < 0.8)
          add!(world, Sphere2(center, 0.2, Lambertian(RGB{Float32}(rand(Float32),rand(Float32),rand(Float32)))))
        elseif (choose_mat < 0.95)
          albedo = RGB(Float32(rand(Uniform(0.5f0, 1.0f0))))
          fuzz = Float32(rand(Uniform(0.0f0, 0.5f0)))
          add!(world, Sphere2(center, 0.2, Metal(albedo, fuzz)))
        else
          add!(world, Sphere2(center, 0.2, Dielectric(RGB{Float32}(1.0, 1.0, 1.0), 1.5)))
        end
      end
    end
  end

  material₁ = Dielectric(RGB{Float32}(1.0, 1.0, 1.0), 1.5)
  material₂ = Lambertian(RGB{Float32}(0.4, 0.2, 0.1))
  material₃ = Metal(RGB{Float32}(0.7, 0.6, 0.5), Float32(0.0))

  add!(world, Sphere2(Point{Float32}(0, 1, 0), 1.0f0, material₁))
  add!(world, Sphere2(Point{Float32}(-4, 1, 0), 1.0f0, material₂))
  add!(world, Sphere2(Point{Float32}(4, 1, 0), 1.0f0, material₃))

end


function render(image_width::Int32, samples_per_pixel::Int32, max_depth::Int32)
  # Image
  aspect_ratio = Float32(16/9)
  image_height = Int32(image_width / aspect_ratio)

  # World
  world = random_scene()

  # Camera
  lookfrom = Point{Float32}(13,2,3)
  lookat = Point{Float32}(0,0,0)
  vup = Vec{Float32}(0,1,0)
  dist_to_focus = 10.0f0
  aperture = 0.1f0
  cam = get_camera(lookfrom, lookat, vup, 20.0f0, aspect_ratio, aperture, dist_to_focus)

  img = rand(RGB{Float32}, image_height, image_width)
  # col-major
  @threads for col in 1:image_width 
    for row in 1:image_height 
      pixel = RGB{Float32}(0, 0, 0)
      for s in 1:samples_per_pixel
        u = Float32((col + rand(Float32)) / image_width)
        v = Float32(((image_height-row) + rand(Float32)) / image_height) 
        ray = get_ray(cam, u, v)
        pixel += ray_color(ray, world, max_depth)
      end
      img[row, col] = get_sampled_color(pixel, samples_per_pixel)
    end
  end
  img
end

print(@__FILE__)

# Tests
# @btime render(Int32(400), Int32(2), Int32(5))
# @time render(Int32(400), Int32(2), Int32(5))
#
# Original
# 6.570 s (663598297 allocations: 13.28 GiB)
# 6.411634 seconds (657.03 M allocations: 13.157 GiB, 9.34% gc time)
#
# after fixing random_vector
# 6.181 s (644298950 allocations: 12.82 GiB)
# 6.312652 seconds (656.51 M allocations: 13.067 GiB, 8.83% gc time)

@btime render(Int32(400), Int32(2), Int32(5))
@time render(Int32(400), Int32(2), Int32(5))

save("imgs/70_final_scene.png", render(Int32(400), Int32(1), Int32(16)))