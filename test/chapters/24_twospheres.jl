using Images, ImageView, BenchmarkTools
using RayTracingWeekend
import RayTracingWeekend.⋅ # Images has \cdot so specifying which one to use


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

  # Camera
  viewport_height   = Float32(2.0)
  viewport_width    = Float32(viewport_height * aspect_ratio)
  focal_length      = Float32(1.0)
  origin            = Point{Float32}(0, 0, 0)
  horizontal        = Vec{Float32}(viewport_width, 0, 0) # h direction
  vertical          = Vec{Float32}(0, viewport_height, 0) # veritcal direction
  shift_in_z_axis   = Vec{Float32}(0.0, 0.0, -focal_length)
  lower_left_corner = shift_in_z_axis - horizontal/2 - vertical/2

  # World
  world = Vector{Hittable}()
  add!(world, Sphere(Point{Float32}(0, 0, -1), 0.5f0))
  add!(world, Sphere(Point{Float32}(0, -100.5, -1), 100.0f0))

  img = rand(RGB{Float32}, image_height, image_width)

  # col-major
  for col in 1:image_width 
    for row in 1:image_height 
      u = Float32(col / image_width)
      v = Float32((image_height-row) / image_height) # we start at the top left
      # ray direction is lower_left_corner + component in x + component in y - origin(reference point)
      # we need to create a vec to store the new direction, as its calculated as a difference in 2 points
      ray = Ray(origin, lower_left_corner + u*horizontal + v*vertical)
      img[row, col] = ray_color(ray, world)
    end
  end
  img
end

print(@__FILE__)
@btime render()
save("imgs/24_twospheres.png", render())