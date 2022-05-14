import Images.RGB

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
  origin::Point{Float32}
  direction::Vec{Float32}
end

""" at(ray, t) returns the point in 3D of ray at `t`. """
@inline function at(r::Ray, t::Float32)
  Point{Float32}(
    r.origin.x + t * r.direction.x,
    r.origin.y + t * r.direction.y,
    r.origin.z + t * r.direction.z
  )
end


"""
   pixel_color (p::Point) -> ::Point{Int8}
Return an RGB pixel color for the input point p where p.x, p.y and p.z is 0-1 range.
"""
pixel_color(p::Point) = RGB{Float32}(p.x, p.y, p.z)

