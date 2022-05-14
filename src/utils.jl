const PI = 3.1415926535897932385

function degrees_to_radians(degrees)
  return Float32(degrees * pi / 180.0f0);
end

function random_in_unit_sphere(normalized=false) 
  while (true)
    p = random_vector(Float32(-1.0), Float32(1.0))
    if (len_squared(p) >= 1) 
      continue
    end
    if normalized
      return unit_vector(p) # actual lambertian case
    end
    return p # a hack to get lambertian.
  end
end


function near_zero(v::Vec)
  return v.x < 1e-8 && v.y < 1e-8 && v.z < 1e-8
end


reflect(v::Vec, n::Vec) = v - 2(v⋅n)*n