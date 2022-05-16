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
    len_squared(p1::Union{Point, Vec}) -> Real

Returns x² + y² + z²
"""
@inline len_squared(p1::Union{Point, Vec}) = Float32(p1.x^2 + p1.y^2 + p1.z^2)


"""
    len(p1::Union{Point, Vec}) -> Real

Returns the √(x² + y² + z²)
"""
@inline len(p1::Union{Point, Vec}) = √(len_squared(p1))


# Dot product
"""
    p1::Vec ⋅ p2::Vec -> Float32
Returns the result of dot product of 2 Vec

x1 = Vec{Int32}(1.0, 2.0, 3.0)
x2 = Vec{Int32}(1.0, 2.0, 3.0)
println(x1 ⋅ x2)

"""
@inline function (⋅)(p1::Union{Point{Float32}, Vec{Float32}}, p2::Union{Point{Float32}, Vec{Float32}})
  return Float32(p1.x * p2.x + p1.y * p2.y + p1.z * p2.z)
end


# Cross product
"""
    p1::Vec × p2::Vec -> ::Vec

    Cross product of 2 vectors, return a new vector
"""
@inline function (×)(u::Union{Point{Float32}, Vec{Float32}}, v::Union{Point{Float32}, Vec{Float32}})
  return Vec{Float32}((u.y * v.z) - (u.z * v.y), (u.z * v.x) - (u.x * v.z), (u.x * v.y) - (u.y * v.x))
end


""" Convert a point to a vector (subtract from Vec(0.0, 0.0, 0.0)) """
@inline to_vec(p::Point{Float32}) = convert(Vec{Float32}, p)


""" Convert a vec to a point """
@inline to_point(v::Vec{Float32}) = convert(Point{Float32}, v)


""" random vector with values between min and max"""
@inline random_vector(min::Float32, max::Float32) = Vec{Float32}(rand(Uniform(min, max)), rand(Uniform(min, max)), rand(Uniform(min, max)))


""" Normalized the given vector `v`, len after normalization is 1. """
@inline unit_vector(v::Vec{Float32}) = v / len(v)
