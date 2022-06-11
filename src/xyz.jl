# Based on https://raytracing.github.io/books/RayTracingInOneWeekend.html
import Base
using Distributions
using StaticArrays
using LinearAlgebra

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
@inline len_squared(p1::Union{Point, Vec})::Float32 = p1 ⋅ p1


"""
    len(p1::Union{Point, Vec}) -> Real

Returns the √(x² + y² + z²)
"""
@inline len(p1::Union{Point, Vec})::Float32 = √(p1 ⋅ p1)


""" Convert a point to a vector (subtract from Vec(0.0, 0.0, 0.0)) """
@inline to_vec(p::Point{Float32}) = convert(Vec{Float32}, p)


""" Convert a vec to a point """
@inline to_point(v::Vec{Float32}) = convert(Point{Float32}, v)


""" random vector with values between min and max"""
@inline function random_vector(min::Float32, max::Float32)::Vec{Float32}
  x = rand(Float32) * (max-min) + min
  y = rand(Float32) * (max-min) + min
  z = rand(Float32) * (max-min) + min
  return Vec{Float32}(x,y,z)
end

""" Normalized the given vector `v`, len after normalization is 1. """
@inline unit_vector(v::Vec{Float32})::Vec{Float32} = v / len(v)
