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
lower_left_corner = shift_in_z_axis - horizontal/2 - vertical/2


# Render
"""
The ray_color(ray) function linearly blends white and blue depending on the height
of the y coordinate after scaling the ray direction to unit length. 
    ray_color(r::Ray) -> ::RGB{Float32}
    
"""
function ray_color(r::Ray)
  unit_vector::Vec = r.direction / len(r.direction)
  t = Float32(0.5*(unit_vector.y + 1.0))
  return (1.0 - t) * RGB{Float32}(0.5, 0.7, 1.0) + t*RGB{Float32}(1.0, 1.0, 1.0)
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


# Create a sphere 
function hit_sphere(center::Point, radius::Real, ray::Ray)
  oc = to_vec(ray.origin - center)
  a = ray.direction ⋅ ray.direction
  b = 2.0 * (oc ⋅ ray.direction)
  c = oc ⋅ oc - (radius*radius)
  discriminant = b*b - 4*a*c
  if (discriminant < 0)
    return -1.0;
  end
    return -b - sqrt(discriminant) / (2.0*a);
end

function ray_color_sphere(r::Ray)
  t = hit_sphere(Point(0.0, 0.0, -1.0), 0.5, r)
  if t != -1.0
    return RGB(1.0, 0.0, 0.0)
  end
  ray_color(r) # sky color 
end

img = rand(RGB{Float32}, image_height, image_width)

for x in 1:image_height # rows
  for y in 1:image_width # cols, not the best julia practise
    i = Float32(x / image_height)
    j = Float32(y / image_width)
    # ray direction is lower_left_corner + component in x + component in y - origin(reference point)
    # we need to create a vec to store the new direction, as its calculated as a difference in 2 points
    ray1 = Ray(origin, lower_left_corner + (j*horizontal) + (i*vertical))
    img[x, y] = ray_color_sphere(ray1)
  end
end
img


# Normal map color
function ray_color_sphere_normal(r::Ray)
  t = hit_sphere(Point(0.0, 0.0, -1.0), 0.5, r)
  if t > 0.0
    contact_vec = to_vec(at(r, t)) - Vec(0, 0, -1)
    N = contact_vec / len(contact_vec)
    return 0.5*RGB(N.x+1, N.y+1, N.z+1)
  end
  ray_color(r) # sky color 
end

img = rand(RGB{Float32}, image_height, image_width)

for x in 1:image_height # rows
  for y in 1:image_width # cols, not the best julia practise
    i = Float32(x / image_height)
    j = Float32(y / image_width)
    # ray direction is lower_left_corner + component in x + component in y - origin(reference point)
    # we need to create a vec to store the new direction, as its calculated as a difference in 2 points
    ray1 = Ray(origin, lower_left_corner + (j*horizontal) + (i*vertical))
    img[x, y] = ray_color_sphere_normal(ray1)
  end
end
img


