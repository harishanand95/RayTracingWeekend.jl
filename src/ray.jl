using Images, ImageView
include("xyz.jl")


# Define ray P(t) = Origin + direction * (t)
"""
    r = Ray(origin, direction)
    r.origin ::Point 
    r.direction ::Vec 
    at(r::Ray, t::Float32) ::Point 

Rays simulate the physical rays, they have a direction and origin.
The value t will give you a point along the ray in positive and negative direction.
"""
struct Ray 
  origin::Point
  direction::Vec
end

@inline function at(r::Ray, t::Real)
  Point{}(
    r.origin.x + t * r.direction.x,
    r.origin.y + t * r.direction.y,
    r.origin.z + t * r.direction.z
  )
end

o = Point{Float32}(0.0, 0.0, 0.0)
d = Vec{Float32}(1.0, 1.0, 10.0)
r = Ray(o, d)

out1 = at(r, 1.0)
@assert out1.x == 1.0
@assert out1.y == 1.0
@assert out1.z == 10.0

out2 = at(r, 10.0)
@assert out2.x == 10.0
@assert out2.y == 10.0
@assert out2.z == 100.0

out3 = at(r, -10.0)
@assert out3.x == -10.0
@assert out3.y == -10.0
@assert out3.z == -100.0


# Part of chapter 1 
"""
   pixel_color (p::Point) -> ::Point{Int8}
Return an RGB pixel color for the input point p where p.x, p.y and p.z is 0-1 range.
"""
pixel_color(p::Point) = RGB(p.x, p.y, p.z)

p1 = Point{Float32}(0.89, 0.25, 0.11)
rgb = pixel_color(p1)

# Generate an 256x256 image
height = trunc(256)
width = trunc(256)
img = rand(RGB{Float32}, height, width)

# julia is col major
for col in 1:width 
  for row in 1:height 
    img[row, col] = pixel_color(Point(col/256, (256-row)/256, 0.25))
  end
end
img