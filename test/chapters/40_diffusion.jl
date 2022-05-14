using Images, ImageView, BenchmarkTools
using RayTracingWeekend
import RayTracingWeekend.⋅ # Images has \cdot so specifying which one to use
using Random
Random.seed!(1234)


# Ray color with recursion depth
function ray_color(ray::Ray, world::Vector{<:Hittable}, depth::Int32)
  # If we've exceeded the ray bounce limit, no more light is gathered.
  if (depth <= 0)
    return RGB{Float32}(0,0,0)
  end

  rec = get_hit_record()
  if hit(world, ray, Float32(0.001), typemax(Float32), rec)
    target = rec.p + rec.normal + random_in_unit_sphere(true)
    return 0.5f0 * ray_color(Ray(rec.p, to_vec(target - rec.p)), world, Int32(depth-1))
  end

  unit_direction = unit_vector(ray.direction)
  t = 0.5f0*(unit_direction.y + 1.0f0)
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
  add!(world, Sphere(Point{Float32}(0, 0, -1), 0.5))
  add!(world, Sphere(Point{Float32}(0, -100.5, -1), 100))

  # Camera
  cam = get_camera()

  img = rand(RGB{Float32}, image_height, image_width)

  # col-major
  for col in 1:image_width 
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
@btime render()  # old 7.794s, new 899.270 ms
save("imgs/40_diffusion.png", render())