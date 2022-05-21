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
function get_camera(;aspect_ratio=Float32(16/9), viewport_height=Float32(2.0), focal_length=Float32(1.0))::Camera
  viewport_width    = Float32(viewport_height * aspect_ratio)
  origin            = Point{Float32}(0, 0, 0)
  horizontal        = Vec{Float32}(viewport_width, 0, 0) # h direction
  vertical          = Vec{Float32}(0, viewport_height, 0) # v direction
  lower_left_corner = origin - (horizontal/2 + vertical/2 + Vec{Float32}(0.0, 0.0, focal_length))
  return Camera(origin, lower_left_corner, horizontal, vertical)
end


"""Create a ray based on u, v inputs on the camera"""
@inline function get_ray(camera::Camera, u::Float32, v::Float32)::Ray
  return Ray(camera.origin, to_vec(camera.lower_left_corner + u*camera.horizontal + v*camera.vertical - camera.origin))
end


""" `get_sampled_color` applies gamma correction and scales the pixel color by the number of samples taken."""
function get_sampled_color(color::RGB{Float32}, samples_per_pixel::Int32)::RGB{Float32}
  scale = 1/samples_per_pixel
  return RGB{Float32}(clamp(sqrt(color.r*scale), 0.0f0, 1.0f0), clamp(sqrt(color.g*scale), 0.0f0, 1.0f0), clamp(sqrt(color.b*scale), 0.0f0, 1.0f0))
end


# On https://raytracing.github.io/books/RayTracingInOneWeekend.html#positionablecamera
# We define a new set of functions for camera, that can take vertical field of view

"""
Create a camera object from vfov and aspect_ratio.
"""
function get_camera(vfov::Float32, aspect_ratio::Float32) # vertical field-of-view in degrees
  θ = degrees_to_radians(vfov)
  h = tan(θ/2)
  viewport_height = 2.0f0 * h
  viewport_width = aspect_ratio * viewport_height
  
  focal_length      = 1.0f0
  origin            = Point{Float32}(0, 0, 0)
  horizontal        = Vec{Float32}(viewport_width, 0, 0) # h direction
  vertical          = Vec{Float32}(0, viewport_height, 0) # v direction
  lower_left_corner = origin - (horizontal/2 + vertical/2 + Vec{Float32}(0.0, 0.0, focal_length))
  return Camera(origin, lower_left_corner, horizontal, vertical)
end

"""
Get a camera that is looking from `lookfrom` and looking at `lookat`.
Additionally `vup` viewup is provided to allow for rotations.

"""
function get_camera(lookfrom::Point{Float32}, lookat::Point{Float32}, vup::Vec{Float32}, vfov::Float32, aspect_ratio::Float32)
  θ = degrees_to_radians(vfov)
  h = tan(θ/2)
  viewport_height = 2.0f0 * h
  viewport_width = aspect_ratio * viewport_height

  w = unit_vector(to_vec(lookfrom - lookat))
  u = unit_vector(vup × w)
  v = w × u

  origin = lookfrom;
  horizontal = viewport_width * u;
  vertical = viewport_height * v;
  lower_left_corner = origin - horizontal/2 - vertical/2 - w;
  return Camera(origin, lower_left_corner, horizontal, vertical)
end


struct Camera2
  origin::Point{Float32}
  lower_left_corner::Point{Float32}
  horizontal::Vec{Float32}
  vertical::Vec{Float32}
  u::Vec{Float32}
  v::Vec{Float32}
  w::Vec{Float32}
  lens_radius::Float32
end


"""
  Get a Camera2 object that is looking from `lookfrom` and looking at `lookat`.
  Additionally `vup` viewup is provided to allow for rotations.
  The camera can do defocus blur, by generating random scene rays 
  originating from inside a disk centered at the lookfrom point.

"""
function get_camera(
  lookfrom::Point{Float32}, lookat::Point{Float32}, vup::Vec{Float32}, 
  vfov::Float32, aspect_ratio::Float32, aperture::Float32, focus_dist::Float32)

  θ = degrees_to_radians(vfov)
  h = tan(θ/2)
  viewport_height = 2.0f0 * h
  viewport_width = aspect_ratio * viewport_height

  w = unit_vector(to_vec(lookfrom - lookat))
  u = unit_vector(vup × w)
  v = w × u

  origin = lookfrom;
  horizontal = focus_dist * viewport_width * u;
  vertical = focus_dist * viewport_height * v;
  lower_left_corner = origin - horizontal/2 - vertical/2 - focus_dist*w
  lens_radius = aperture / 2

  return Camera2(origin, lower_left_corner, horizontal, vertical, u, v, w, lens_radius)
end


"""Create a ray based on s, t inputs on camera2"""
function get_ray(camera::Camera2, s::Float32, t::Float32)
  rd = camera.lens_radius * random_in_unit_disk()
  offset = to_point(camera.u * rd.x + camera.v * rd.y)
  return Ray(camera.origin + offset, to_vec(camera.lower_left_corner + s*camera.horizontal + t*camera.vertical - camera.origin - offset))
end