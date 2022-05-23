abstract type Hittable end

""" Sphere stores information on center and radius. """
struct Sphere <: Hittable
  center::Point{Float32}
  radius::Float32
end


""" Sphere2 stores material inaddition to center and radius. """
struct Sphere2 <: Hittable
  center::Point{Float32}
  radius::Float32
  material::Material
end


"""
    hit! function for sphere, calculates the impact location, normal etc on HitRecord `rec`
    for the `ray`. 
    - This function will update values on rec on a successful hit.
"""
function hit!(object::Union{Sphere, Sphere2}, ray::Ray, t_min::Float32, t_max::Float32, rec::Union{HitRecord, HitRecord2})
  oc = to_vec(ray.origin - object.center)
  a = ray.direction ⋅ ray.direction
  half_b = oc ⋅ ray.direction
  c = oc ⋅oc - object.radius^2
  discriminant = half_b*half_b - a*c
  if (discriminant < 0) 
    return false
  end
  sqrtd = sqrt(discriminant)
  root = (-half_b - sqrtd) / a

  if (root < t_min) || (t_max < root)
    root = Float32((-half_b + sqrtd) / a)
    if (root < t_min) || (t_max < root)
      return false
    end
  end
  p = at(ray, root)
  
  outward_normal = to_vec(p - object.center) / object.radius
  front_face = (ray.direction ⋅ outward_normal) < 0
  normal = front_face ? outward_normal : -outward_normal 

  if typeof(object) == Sphere2
    set_hit_record(rec, p, normal, root, front_face, object.material)
  else
    set_hit_record(rec, p, normal, root, front_face)
  end

  return true
end


"""
  Apply ray hit on all the `objects` in the scene. 
"""
function hit(objects::Vector{<:Hittable}, ray::Ray, t_min::Float32, t_max::Float32, rec::Union{HitRecord, HitRecord2})
  if typeof(rec) == HitRecord2
    temp = get_hit_record(Lambertian(0.0f0))
  else
    temp = get_hit_record()
  end
  hit_anything=false

  for object in objects
    if (hit!(object, ray, t_min, t_max, temp)) 
      hit_anything = true
      t_max = temp.t
    end
  end

  if hit_anything
    set_hit_record(temp, rec)
    return hit_anything
  end
  return hit_anything
end


add!(list::Vector{<:Hittable}, object) = push!(list, object)
clear!(list::Vector{<:Hittable}) = empty!(list)