abstract type Material end

struct Lambertian <: Material
  albedo::RGB{Float32}
end

struct Metal <: Material
  albedo::RGB{Float32}
  fuzz::Float32
end

function scatter(material::Lambertian, r_in::Ray, rec)
  scatter_direction = rec.normal + random_in_unit_sphere(true)

  if near_zero(scatter_direction)
    scatter_direction = rec.normal
  end
  scattered = Ray(rec.p, scatter_direction)
  attenuation = material.albedo
  return true, attenuation, scattered
end


function scatter(material::Metal, r_in::Ray, rec)
  reflected = reflect(unit_vector(r_in.direction), rec.normal)
  scattered = Ray(rec.p, reflected + random_in_unit_sphere(true)*material.fuzz)
  attenuation = material.albedo
  return (scattered.direction ⋅ rec.normal) > 0, attenuation, scattered
end