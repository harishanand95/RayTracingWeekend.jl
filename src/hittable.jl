"""
    HitRecord stores information on the point of impact for a ray.
    This includes where ray hits, "t" in o+d(t), surface normal 
    and where the impact was like the front side or back side.
"""
mutable struct HitRecord
  p::Point{<:Real} 
  normal::Vec{<:Real}
  t::Float32
  front_face::Bool
end

"""
    Get a HitRecord object with default values.
"""
function get_hit_record()
  HitRecord(Point{Float32}(0.0, 0.0, 0.0), Vec{Float32}(0.0, 0.0, 0.0), Float32(0.0), false)
end


"""
    Set HitRecord `rec` to the arguments passed.
"""
function set_hit_record(rec::HitRecord, p::Point, normal::Vec, t::Float32, front_face::Bool)
  setfield!(rec, :t, t)
  setfield!(rec, :p, p)
  setfield!(rec, :normal, normal)
  setfield!(rec, :front_face, front_face)
end


"""
    Set the source HitRecord to be same as the destination HitRecord.
    Equivalent of copy constructor in C++. (Harish: maybe slow?)
"""
function set_hit_record(source::HitRecord, destination::HitRecord)
  setfield!(destination, :p, getfield(source, :p))
  setfield!(destination, :normal, getfield(source, :normal))
  setfield!(destination, :t, getfield(source, :t))
  setfield!(destination, :front_face, getfield(source, :front_face))
end 


""" HitRecord2 stores material inaddition to details present in HitRecord. """
mutable struct HitRecord2
  p::Point{<:Real} 
  normal::Vec{<:Real}
  t::Float32
  front_face::Bool
  material::Material # a constructor cannot be defined as its a abstract type here
end


"""
    Get a HitRecord2 object with default values, and a given material (since material is abstract).
"""
function get_hit_record(material::Material)
  HitRecord2(Point{Float32}(0.0, 0.0, 0.0), Vec{Float32}(0.0, 0.0, 0.0), Float32(0.0), false, material)
end


""" set_hit_record sets fields inside HitRecord2 `rec` to the arguments passed"""
function set_hit_record(rec::HitRecord2, p::Point, normal::Vec, t::Float32, front_face::Bool, material::Material)
  setfield!(rec, :t, t)
  setfield!(rec, :p, p)
  setfield!(rec, :normal, normal)
  setfield!(rec, :front_face, front_face)
  setfield!(rec, :material, material)
end


"""
    Set the source HitRecord2 to be same as the destination HitRecord2.
    Equivalent of copy constructor in C++. (Harish: maybe slow?)
"""
function set_hit_record(source::HitRecord2, destination::HitRecord2)
  setfield!(destination, :p, getfield(source, :p))
  setfield!(destination, :normal, getfield(source, :normal))
  setfield!(destination, :t, getfield(source, :t))
  setfield!(destination, :front_face, getfield(source, :front_face))
  setfield!(destination, :material, getfield(source, :material))
end 


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
  c = (oc ⋅ oc) - (object.radius*object.radius)
  discriminant = (half_b*half_b) - (a*c)
  if (discriminant < 0) 
    return false
  end
  
  sqrt_d = sqrt(discriminant)
  root = (-half_b - sqrt_d) / a

  if (root < t_min) || (t_max < root)
    root = (-half_b + sqrt_d) / a
    if (root < t_min) || (t_max < root)
      return false
    end
  end
  setfield!(rec, :t, root)
  setfield!(rec, :p, at(ray, rec.t))
  outward_normal = to_vec(rec.p - object.center) / object.radius
  front_face = (ray.direction ⋅ outward_normal) < 0
  normal = front_face ? outward_normal : -outward_normal

  if typeof(rec) == HitRecord2 && typeof(object) == Sphere2
    set_hit_record(rec, at(ray, rec.t), normal, root, front_face, object.material)
  else
    set_hit_record(rec, at(ray, rec.t), normal, root, front_face)
  end
  return true
end


"""
  Apply ray hit on all the `objects` in the scene. 
"""
function hit(objects::Vector{<:Hittable}, ray::Ray, t_min::Float32, t_max::Float32, rec::Union{HitRecord, HitRecord2})
  if typeof(rec) == HitRecord2
    temp = get_hit_record(Metal(0.0, 0.0))
  else
    temp = get_hit_record()
  end
  hit_anything=false
  closest_so_far = t_max

  for object in objects
    if (hit!(object, ray, t_min, closest_so_far, temp)) 
      hit_anything = true
      closest_so_far = temp.t
      set_hit_record(temp, rec)
    end
  end
  return hit_anything
end


add!(list::Vector{<:Hittable}, object) = push!(list, object)
clear!(list::Vector{<:Hittable}) = empty!(list)