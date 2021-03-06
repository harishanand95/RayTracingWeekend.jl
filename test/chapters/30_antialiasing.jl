using Images, ImageView, BenchmarkTools
using RayTracingWeekend
import RayTracingWeekend.⋅ # Images has \cdot so specifying which one to use
using Random
Random.seed!(1234)

# Ray color
function ray_color(ray::Ray, world::Vector{<:Hittable})
  rec = get_hit_record()
  if hit(world, ray, Float32(0.0), typemax(Float32), rec)
    return 0.5f0 * RGB{Float32}(rec.normal.x+1, rec.normal.y+1, rec.normal.z+1)
  end

  unit_direction = unit_vector(ray.direction)
  t = Float32(0.5f0*(unit_direction.y + 1.0f0))
  return (1.0f0-t)*RGB{Float32}(1.0, 1.0, 1.0) + t*RGB{Float32}(0.5, 0.7, 1.0)
end


function render()
  # Image
  aspect_ratio = Float32(16/9)
  image_width  = Int32(400)
  image_height = Int32(image_width / aspect_ratio)
  samples_per_pixel = Int32(100)

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
        pixel += ray_color(ray, world)
      end
      img[row, col] = get_sampled_color(pixel, samples_per_pixel)
    end
  end
  img
end

print(@__FILE__)
@btime render() # old time 9.802 s, new 896.789 ms (set float to FP32)
save("imgs/30_antialiasing.png", render())