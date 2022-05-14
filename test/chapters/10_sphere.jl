using Images, ImageView

using RayTracingWeekend
using BenchmarkTools
import RayTracingWeekend.⋅ # Images has \cdot so specifying which one to use


# Create a sphere 
function hit_sphere(center::Point{Float32}, radius::Float32, ray::Ray)
  oc = to_vec(ray.origin - center)
  a = ray.direction ⋅ ray.direction
  b = 2.0 * (oc ⋅ ray.direction)
  c = oc ⋅ oc - (radius*radius)
  discriminant = b*b - 4*a*c
  if (discriminant < 0)
    return -1.0;
  end
  return (-b - sqrt(discriminant)) / (2.0*a)
end


function ray_color_sphere(r::Ray)
  t = hit_sphere(Point{Float32}(0.0, 0.0, -1.0), 0.5f0, r)
  if t != -1.0
    return RGB{Float32}(1.0, 0.0, 0.0)
  end
  sky_color(r) # sky color 
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
  
  img = rand(RGB{Float32}, image_height, image_width)
  # col-major
  for col in 1:image_width 
    for row in 1:image_height 
      u = Float32(col / image_width)
      v = Float32((image_height-row) / image_height) # we start at the lower left
      # ray direction is lower_left_corner + component in x + component in y - origin(reference point)
      # we need to create a vec to store the new direction, as its calculated as a difference in 2 points
      ray = Ray(origin, lower_left_corner + u*horizontal + v*vertical)
      img[row, col] = ray_color_sphere(ray)
    end
  end
  img
end

print(@__FILE__)
@btime render()
save("imgs/10_sphere.png", render())