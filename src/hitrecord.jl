"""
    HitRecord stores information on the point of impact for a ray.
    This includes where ray hits, "t" in o+d(t), surface normal 
    and where the impact was like the front side or back side.
"""
mutable struct HitRecord
  p::Point{Float32} 
  normal::Vec{Float32}
  t::Float32
  front_face::Bool
end

"""
    Get a HitRecord object with default values.
"""
@inline function get_hit_record()
  HitRecord(Point{Float32}(0.0, 0.0, 0.0), Vec{Float32}(0.0, 0.0, 0.0), Float32(0.0), false)
end


"""
    Set HitRecord `rec` to the arguments passed.
"""
@inline function set_hit_record(rec::HitRecord, p::Point{Float32}, normal::Vec{Float32}, t::Float32, front_face::Bool)
  setfield!(rec, :t, t)
  setfield!(rec, :p, p)
  setfield!(rec, :normal, normal)
  setfield!(rec, :front_face, front_face)
end


"""
    Set the source HitRecord to be same as the destination HitRecord.
    Equivalent of copy constructor in C++. (Harish: maybe slow?)
"""
@inline function set_hit_record(source::HitRecord, destination::HitRecord)
  setfield!(destination, :p, getfield(source, :p))
  setfield!(destination, :normal, getfield(source, :normal))
  setfield!(destination, :t, getfield(source, :t))
  setfield!(destination, :front_face, getfield(source, :front_face))
end 


""" HitRecord2 stores material inaddition to details present in HitRecord. """
mutable struct HitRecord2
  p::Point{Float32} 
  normal::Vec{Float32}
  t::Float32
  front_face::Bool
  material::Material # a constructor cannot be defined as its a abstract type here
end


"""
    Get a HitRecord2 object with default values, and a given material (since material is abstract).
"""
function get_hit_record(material::Material)
  return HitRecord2(Point{Float32}(0.0, 0.0, 0.0), Vec{Float32}(0.0, 0.0, 0.0), Float32(0.0), false, material)
end


""" set_hit_record sets fields inside HitRecord2 `rec` to the arguments passed"""
function set_hit_record(rec::HitRecord2, p::Point{Float32}, n::Vec{Float32}, t::Float32, front_face::Bool, material::Material)
  setfield!(rec, :t, t)
  setfield!(rec, :p, p)
  setfield!(rec, :normal, n)
  setfield!(rec, :front_face, front_face)
  setfield!(rec, :material, material)
end


"""
    Set the source HitRecord2 to be same as the destination HitRecord2.
    Equivalent of copy constructor in C++. (Harish: maybe slow?)
"""
@inline function set_hit_record(source::HitRecord2, destination::HitRecord2)
  setfield!(destination, :p, getfield(source, :p))
  setfield!(destination, :normal, getfield(source, :normal))
  setfield!(destination, :t, getfield(source, :t))
  setfield!(destination, :front_face, getfield(source, :front_face))
  setfield!(destination, :material, getfield(source, :material))
end 
