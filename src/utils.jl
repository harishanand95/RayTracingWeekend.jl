@inline function degrees_to_radians(degrees::Float32)::Float32
  return degrees * pi / 180.0f0;
end

function random_in_unit_sphere(normalized=false)::Vec{Float32}
  while (true)
    p = random_vector(-1.0f0, 1.0f0)
    if (len_squared(p) >= 1.0f0) 
      continue
    end
    if normalized
      return unit_vector(p) # actual lambertian case
    end
    return p # a hack to get lambertian.
  end
end


@inline function near_zero(v::Vec{Float32})
  return v.x < 1e-8 && v.y < 1e-8 && v.z < 1e-8
end


@inline reflect(v::Vec{Float32}, n::Vec{Float32})::Vec{Float32} = v - 2(v⋅n)*n


""" Get a random vector inside a disk of unit size. """
function random_in_unit_disk()::Vec{Float32}
  while (true)
    p = Vec{Float32}(rand(Float32), rand(Float32), 0.0f0)
    if len_squared(p) >= 1.0f0
      continue
    end
    return p
  end
end