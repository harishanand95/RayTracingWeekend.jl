include("xyz.jl")
include("ray.jl") # TODO FIX THIS, imports everything

using Images, ImageView

# Camera geometry
# (0,0,0) is the origin of the Camera
# positive x-axis is (right-side) width 
# positive y-axis is upwards height
# negative z-axis points towards the imageplane (viewport)
# aspect ratio is 16:9
# viewport height = 2; width = 4
# bottom left (-2, -1, -1) 

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
lower_left_corner = Vec{Float32}(shift_in_z_axis.x, shift_in_z_axis.y, shift_in_z_axis.z) - horizontal/2 - vertical/2


# Render
"""
    ray_color(r::Ray) -> ::RGB{Float32}
    
"""
function ray_color(r::Ray)
  unit_vector::Vec = r.direction / len(r.direction)
  t = Float32(0.5*(unit_vector.y + 1.0))
  return (1.0 - t) * RGB{Float32}(1.0, 1.0, 1.0) + t*RGB{Float32}(0.5, 0.7, 1.0)
end


img = rand(RGB{Float32}, image_height, image_width)

for x in 1:image_height # rows
  for y in 1:image_width # cols, not the best julia practise
    i = Float32(x / image_height)
    j = Float32(y / image_width)
    # ray direction is lower_left_corner + component in x + component in y - origin(reference point)
    # we need to create a vec to store the new direction, as its calculated as a difference in 2 points
    ray = Ray(origin, lower_left_corner + j*horizontal + i*vertical)
    img[x, y] = ray_color(ray)
  end
end

img