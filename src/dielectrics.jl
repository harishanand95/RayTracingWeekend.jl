
struct Dielectric <: Material
  albedo::RGB{Float32}
  ir::Float32
end
  

function refract(ray_in::Vec{Float32}, normal::Vec{Float32}, refractive_index::Float32)
  cosθ = min(-ray_in ⋅ normal, 1.0f0)
  ⟂ = refractive_index * (ray_in + cosθ*normal)
  ∥ = -√(abs(1.0f0 - len_squared(⟂))) * normal
  return +(⟂, ∥) # not sure why + did not work :?
end


function reflectance(cosθ::Float32, refraction_index::Float32)
  # Use Schlick's approximation for reflectance
  r0 = (1-refraction_index) / (1+refraction_index)
  r0 = Float32(r0*r0)
  return Float32(r0 + (1-r0)*((1 - cosθ)^5))
end


function scatter(material::Dielectric, r_in::Ray, rec)
  refraction_ratio = rec.front_face ? (1.0f0 / material.ir) : material.ir
  unit_direction = unit_vector(r_in.direction)

  cosθ = min((-unit_direction ⋅ rec.normal), 1.0f0)
  sinθ = √(1.0f0 - cosθ*cosθ)
  cannot_refract = (refraction_ratio * sinθ) > 1.0f0

  if (cannot_refract || reflectance(cosθ, refraction_ratio) > rand(Float32))
    direction = reflect(unit_direction, rec.normal)
  else
    direction = refract(unit_direction, rec.normal, refraction_ratio)
  end

  scattered = Ray(rec.p, direction)
  return true, RGB{Float32}(1.0, 1.0, 1.0), scattered
end