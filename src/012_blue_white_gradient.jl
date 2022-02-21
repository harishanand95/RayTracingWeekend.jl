include("010_points.jl")
include("011_ray.jl")

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
horizontal        = Point{Float32}(viewport_width, 0, 0) # h direction
vertical          = Point{Float32}(0, viewport_height, 0) # veritcal direction
lower_left_corner = origin - horizontal/2 - vertical/2 - Point{Float32}(0.0, 0.0, focal_length)
