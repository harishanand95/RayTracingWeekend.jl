import Images.RGB

""" Camera object with specification for origin, horizontal and vertical vectors. 
    We can use the camera object to generate rays along each (u,v) pixels.
"""
struct Camera
  origin::Point{Float32}
  lower_left_corner::Point{Float32}
  horizontal::Vec{Float32}
  vertical::Vec{Float32}
end


"""
Create a camera object from aspect_ratio, viewport_height and focal_length
"""
function get_camera(;aspect_ratio=Float32(16/9), viewport_height=Float32(2.0), focal_length=Float32(1.0))
  viewport_width    = Float32(viewport_height * aspect_ratio)
  origin            = Point{Float32}(0, 0, 0)
  horizontal        = Vec{Float32}(viewport_width, 0, 0) # h direction
  vertical          = Vec{Float32}(0, viewport_height, 0) # v direction
  lower_left_corner = origin - (horizontal/2 + vertical/2 + Vec{Float32}(0.0, 0.0, focal_length))
  return Camera(origin, lower_left_corner, horizontal, vertical)
end


"""Create a ray based on u, v inputs on the camera"""
function get_ray(camera::Camera, u::Float32, v::Float32)
  return Ray(camera.origin, to_vec(camera.lower_left_corner + u*camera.horizontal + v*camera.vertical - camera.origin))
end


""" `get_sampled_color` applies gamma correction and scales the pixel color by the number of samples taken."""
function get_sampled_color(color::RGB, samples_per_pixel::Int32)
  scale = 1/samples_per_pixel
  return RGB(clamp(sqrt(color.r*scale), 0, 1), clamp(sqrt(color.g*scale), 0, 1), clamp(sqrt(color.b*scale), 0, 1))
end
