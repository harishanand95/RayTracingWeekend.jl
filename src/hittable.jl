include("xyz.jl")
include("ray.jl")

# HitRecord stores point where ray hits, "t", surface normal and if its front_face or not.

"""
    Stores information of the point of impact for a ray.
    This includes where ray hits, "t" in o+d(t), surface normal 
    and the impace was on the front side or back side.
"""
mutable struct HitRecord 
  p::Point{<:Real} 
  normal::Vec{<:Real}
  t::Float32
  front_face::Bool
end


"""
    Create a HitRecord object with all zeros.
"""
function get_hit_record()
  p = Point{Float32}(0.0, 0.0, 0.0)
  n = Vec{Float32}(0.0, 0.0, 0.0)
  t = Float32(0.0)
  f = false
  return HitRecord(p, n, t, f)
end


"""
    Set the source hit_record to be same as the destination.
    Equivalent of copy constructor in C++. (Harish: maybe slow?)
"""
function set_hit_record(source::HitRecord, destination::HitRecord)
  destination.p = source.p
  destination.normal = source.normal
  destination.t = source.t
  destination.front_face = source.front_face
end 


"""
    Sets the face normal to pointing outwards on the impact location of the object.
"""
function set_face_normal(record::HitRecord, r::Ray, outward_normal::Vec)
  record.front_face = (r.direction ⋅ outward_normal) < 0
  record.normal = record.front_face ? outward_normal : -outward_normal
end


abstract type Hittable end

struct Sphere <: Hittable
  center::Point{Float32}
  radius::Float32
end


"""
    Ray hit function for sphere, calculates the impact location, normal etc in `rec`
    for the `ray` on `object`.
"""
function hit!(object::Sphere, ray::Ray, t_min::Float32, t_max::Float32, rec::HitRecord)
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

  if (root < t_min || t_max < root)
    root = (-half_b + sqrt_d) / a
    if (root < t_min || t_max < root)
      return false
    end
  end

  rec.t = root
  rec.p = at(ray, rec.t)
  outward_normal = to_vec(rec.p - object.center) / object.radius
  set_face_normal(rec, ray, outward_normal)

  return true
end

"""
  Apply ray hit! on all the `objects` in the scene. 
"""
function hit(objects::Vector{<:Hittable}, ray::Ray, t_min::Float32, t_max::Float32, rec::HitRecord)
  temp = get_hit_record()
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


function add!(list::Vector{<:Hittable}, object)
  push!(list, object)
end


function clear!(list::Vector{<:Hittable})
  empty!(list)
end

# tests
world = Vector{Hittable}()
add!(world, Sphere(Point{Float32}(0, 0, -1), 0.5))
add!(world, Sphere(Point{Float32}(0, 0, -1), 0.5))

@assert size(world) == (2,) # ask claforte how to compare with 2 directly?
clear!(world)
add!(world, Sphere(Point{Float32}(0, 0, -1), 0.5))
@assert size(world) == (1,)