using Images, ImageView
using BenchmarkTools
using RayTracingWeekend


function render()
  # Image
  aspect_ratio = Float32(16/9)
  image_width  = Int32(400)
  image_height = Int32(image_width / aspect_ratio)

  # Camera geometry
  # (0,0,0) is the origin of the Camera
  # positive x-axis is (right-side) width 
  # positive y-axis is upwards height
  # negative z-axis points towards the imageplane (viewport)
  # aspect ratio is 16:9
  # viewport height = 2; width = 4
  # bottom left (-2, -1, -1) 
  viewport_height   = Float32(2.0)
  viewport_width    = Float32(viewport_height * aspect_ratio)
  focal_length      = Float32(1.0)
  origin            = Point{Float32}(0, 0, 0)
  horizontal        = Vec{Float32}(viewport_width, 0, 0) # h direction
  vertical          = Vec{Float32}(0, viewport_height, 0) # veritcal direction
  shift_in_z_axis   = Vec{Float32}(0.0, 0.0, -focal_length)
  lower_left_corner = shift_in_z_axis - horizontal/2 - vertical/2

  # Render
  img = rand(RGB{Float32}, image_height, image_width)

  # col-major
  for col in 1:image_width 
    for row in 1:image_height 
      u = Float32(col / image_width)
      v = Float32((image_height-row) / image_height) # we start at the top left
      # ray direction is lower_left_corner + component in x + component in y - origin(reference point)
      # we need to create a vec to store the new direction, as its calculated as a difference in 2 points
      ray = Ray(origin, lower_left_corner + u*horizontal + v*vertical)
      img[row, col] = sky_color(ray)
    end
  end
  img
end

print(@__FILE__)
@btime render()
save("imgs/09_skycolor.png", render())