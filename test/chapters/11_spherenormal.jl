using Images, ImageView, BenchmarkTools
using RayTracingWeekend
import RayTracingWeekend.⋅ # Images has \cdot so specifying which one to use


# Create a sphere 
function hit_sphere(center::Point{Float32}, radius::Float32, ray::Ray)
  oc = to_vec(ray.origin - center)
  a = ray.direction ⋅ ray.direction
  b = 2.0 * (oc ⋅ ray.direction)
  c = (oc ⋅ oc) - (radius*radius)
  discriminant = b*b - 4.0*a*c
  if (discriminant < 0)
    return -1.0f0;
  else
    return Float32((-b - sqrt(discriminant)) / (2.0*a))
  end
end


# Normal map color
function ray_color_sphere_normal(r::Ray)
  t = hit_sphere(Point{Float32}(0.0, 0.0, -1.0), 0.5f0, r)
  if t > 0.0 
    surface_normal = to_vec(at(r, t)) - Vec{Float32}(0.0, 0.0, -1.0)
    N = surface_normal / len(surface_normal) # normalized
    return 0.5*RGB(N.x+1, N.y+1, N.z+1)
  else
    sky_color(r) # sky color 
  end
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

  # col-major, u is col, v is row
  for col in 1:image_width 
    for row in 1:image_height 
      u = Float32(col / image_width)
      v = Float32((image_height-row) / image_height) # we start at the top left
      # ray direction is lower_left_corner + component in x + component in y - origin(reference point)
      # we need to create a vec to store the new direction, as its calculated as a difference in 2 points
      ray = Ray(origin, lower_left_corner + u*horizontal + v*vertical)
      img[row, col] = ray_color_sphere_normal(ray)
    end
  end
  img
end

@btime render()
save("imgs/11_spherenormal.png", render())