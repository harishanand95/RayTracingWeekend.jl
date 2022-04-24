using Images, ImageView, BenchmarkTools

include("camera.jl")
include("hittable.jl")

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

# Ray color
function ray_color(ray::Ray, world::Vector{<:Hittable})
  rec = get_hit_record()
  if hit(world, ray, Float32(0.0), typemax(Float32), rec)
    return 0.5 * RGB(rec.normal.x+1, rec.normal.y+1, rec.normal.z+1)
  end

  unit_direction = ray.direction / len(ray.direction)
  t = 0.5*(unit_direction.y + 1.0)
  return (1.0-t)*RGB(1.0, 1.0, 1.0) + t*RGB(0.5, 0.7, 1.0)
end

img = rand(RGB{Float32}, image_height, image_width)

function render()
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
end

@btime render()
img