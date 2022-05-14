# Based on https://raytracing.github.io/books/RayTracingInOneWeekend.html
import Base
using Distributions
using StaticArrays

# http://www.stochasticlifestyle.com/type-dispatch-design-post-object-oriented-programming-julia/
# julia follows inheritance by actions than data. Setup the abstract types hierarchy to mean the 
# existence or non-existence of some behavior

struct Point{T} <: FieldVector{3, T}
  x::T
  y::T
  z::T
end


struct Vec{T} <: FieldVector{3, T}
  x::T
  y::T
  z::T
end


# calculate norm and length_squared for a point
"""
    len_squared(p1::XYZ) -> Real

Returns x² + y² + z²
"""
len_squared(p1::Union{Point, Vec}) = Float32(p1.x^2 + p1.y^2 + p1.z^2)


"""
    len(p1::AbstractXYZ) -> Real

Returns the √(x² + y² + z²)
"""
len(p1::Union{Point, Vec}) = √(len_squared(p1))


# Dot product
"""
    p1::AbstractVec ⋅ p2::AbstractVec -> Float32
Returns the result of dot product of 2 Vec

x1 = Vec{Int32}(1.0, 2.0, 3.0)
x2 = Vec{Int32}(1.0, 2.0, 3.0)
println(x1 ⋅ x2)

"""
@inline function (⋅)(p1::Union{Point, Vec}, p2::Union{Point, Vec})
  return Float32(p1.x * p2.x + p1.y * p2.y + p1.z * p2.z)
end


# Cross product
"""
    p1::AbstractVec × p2::AbstractVec -> ::AbstractVec

    Cross product of 2 vectors, return a new vector
"""
function (×)(u::Union{Point, Vec}, v::Union{Point, Vec})
  return Vec{Float32}((u.y * v.z) - (u.z * v.y), (u.z * v.x) - (u.x * v.z), (u.x * v.y) - (u.y * v.x))
end


""" Convert a point to a vector (subtract from Vec(0.0, 0.0, 0.0)) """
to_vec(p::Point) = Vec{Float32}(p.x, p.y, p.z)


""" Convert a vec to a point """
to_point(v::Vec) = Point{Float32}(v.x, v.y, v.z)


""" random vector with values between min and max"""
random_vector(min, max) = Vec{Float32}(rand(Uniform(min, max)), rand(Uniform(min, max)), rand(Uniform(min, max)))
