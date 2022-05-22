using Images, ImageView, BenchmarkTools
using RayTracingWeekend
using Base.Threads
import RayTracingWeekend.⋅ # Images has \cdot so specifying which one to use
using Random
Random.seed!(1234)


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


function render()
  # Image
  aspect_ratio      = Float32(16/9)
  image_width       = Int32(400)
  image_height      = Int32(image_width / aspect_ratio)
  samples_per_pixel = Int32(100)
  max_depth         = Int32(50)

  # World
  world = Vector{Hittable}()

  # Materials
  material_ground = Lambertian(RGB{Float32}(0.8, 0.8, 0.0))
  material_center = Lambertian(RGB{Float32}(0.7, 0.3, 0.3))
  material_left   = Metal(RGB{Float32}(0.8, 0.8, 0.8), Float32(0.5))
  material_right  = Metal(RGB{Float32}(0.8, 0.6, 0.2), Float32(1.0))

  add!(world, Sphere2(Point{Float32}(0.0, -100.5, -1.0), 100.0, material_ground))
  add!(world, Sphere2(Point{Float32}(0.0, 0.0, -1.0), 0.5, material_center))
  add!(world, Sphere2(Point{Float32}(-1.0, 0.0, -1.0), 0.5, material_left))
  add!(world, Sphere2(Point{Float32}(1.0, 0.0, -1.0), 0.5, material_right))

  # Camera
  cam = get_camera()

  img = rand(RGB{Float32}, image_height, image_width)
  # col-major
  @threads for col in 1:image_width 
    for row in 1:image_height 
      pixel = RGB{Float32}(0, 0, 0)
      for s in 1:samples_per_pixel
        u = Float32((col + rand()) / image_width)
        v = Float32(((image_height-row) + rand()) / image_height) 
        ray = get_ray(cam, u, v)
        pixel += ray_color(ray, world, max_depth)
      end
      img[row, col] = get_sampled_color(pixel, samples_per_pixel)
    end
  end
  img
end

print(@__FILE__)
@btime render()  # 4.748 s
save("imgs/50_metal.png", render())
