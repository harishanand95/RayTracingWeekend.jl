"""
The sky_color(ray) function linearly blends white and blue depending on the height
of the y coordinate after scaling the ray direction to unit length. 
  sky_color(r::Ray) -> ::RGB{Float32}
    
"""
function sky_color(r::Ray)::RGB{Float32}
  v::Vec{Float32} = unit_vector(r.direction)
  t = Float32(0.5f0*(v.y + 1.0f0))
  return (1.0f0 - t) * RGB{Float32}(1.0, 1.0, 1.0) + t*RGB{Float32}(0.5, 0.7, 1.0)
end