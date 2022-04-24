using Images, ImageView

include("xyz.jl")
include("ray.jl")


mutable struct Camera
  origin::Point{Float32}
  lower_left_corner::Point{Float32}
  horizontal::Vec{Float32}
  vertical::Vec{Float32}
end


"""
Create a camera object
"""
function get_camera()
  camera = Camera(Point{Float32}(0,0,0), Point{Float32}(0,0,0), Vec{Float32}(0,0,0), Vec{Float32}(0,0,0))
  aspect_ratio      = Float32(16/9)
  viewport_height   = Float32(2.0)
  viewport_width    = Float32(viewport_height * aspect_ratio)
  focal_length      = Float32(1.0)

  camera.origin     = Point{Float32}(0, 0, 0)
  camera.horizontal = Vec{Float32}(viewport_width, 0, 0) # h direction
  camera.vertical   = Vec{Float32}(0, viewport_height, 0) # v direction

  camera.lower_left_corner = camera.origin - (camera.horizontal/2 + camera.vertical/2 + Vec{Float32}(0.0, 0.0, focal_length))
  return camera
end

"""Create a ray based on u, v inputs on the camera"""
function get_ray(camera::Camera, u::Float32, v::Float32)
  return Ray(camera.origin, to_vec(camera.lower_left_corner + u*camera.horizontal + v*camera.vertical - camera.origin))
end


function get_sampled_color(color::RGB, samples_per_pixel::Int)
  scale = 1/samples_per_pixel
  return RGB(clamp(color.r*scale, 0, 1), clamp(color.g*scale, 0, 1), clamp(color.b*scale, 0, 1))
end
