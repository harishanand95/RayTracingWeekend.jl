# Based on https://raytracing.github.io/books/RayTracingInOneWeekend.html
import Base

abstract type AbstractXYZ <: Real end

struct Point{T} <: AbstractXYZ
  x::T
  y::T
  z::T
end

# create an integer point
p = Point{Int}(3, 4, 5)
# create a float point
p_fp32 = Point{Float32}(3.2, 4.1, 5.003)

# https://docs.julialang.org/en/v1/manual/modules/#Qualified-names
# https://discourse.julialang.org/t/bug-in-unary-operator-overloading-syntax/63117
"""
    - p::Point -> p::Point
Return a negative value of the given point.
"""
Base.:-(p::Point) = Point(-p.x, -p.y, -p.z)


"""
    p::Point / r::Real -> p::Point
Returns a point divided by a real.
"""
Base.:/(p::Point, r::Real) = Point(p.x/r, p.y/r, p.z/r)


"""
    Real * p::Point -> p::Point
Return a point muliplied by a real.
"""
Base.:*(p::Point, r::Real)  = Point(p.x*r, p.y*r, p.z*r)
Base.:*(r::Real, p::Point)  = Point(p.x*r, p.y*r, p.z*r)


"""
    p1::Point == p2::Point
Check whether the given 2 points are equal.
"""
function Base.:(==)(p1::Point, p2::Point)
  p1.x == p2.x && p1.y == p2.y && p1.z == p2.z
end


# negative p (Int)
negative_p = -p
negative_p_fp32 = -p_fp32

@assert negative_p_fp32.x == -3.2f0
@assert negative_p_fp32.y == -4.1f0
@assert negative_p_fp32.z == -5.003f0

res = negative_p*3
@assert res.x == -9
@assert res.y == -12
@assert res.z == -15

res = res/3
@assert res.x == -3
@assert res.y == -4
@assert res.z == -5


# Addition - inplace add!(), add() -> ::Point, + operator
# inplace can slow things up, especially on a small ds like point

#"""
#    add!(p1::Point, p2::Point) 
#
#Adds the Point p2 to Point p1.
#"""
#function add!(p1::Point, p2::Point)
#  p1.x = p1.x + p2.x
#  p1.y = p1.y + p2.y
#  p1.z = p1.z + p2.z
#end

# This is wrong as you are going to write to p which is an Int
# psum = add!(p, p_fp32)

"""
    add(p1::point, p2::point) -> ::point
Returns a new point which is the sum of p1 and p2.
"""
function add(p1::Point, p2::Point)
  Point{Float32}(p1.x + p2.x, p1.y + p2.y, p1.z + p2.z)
end

"""
    p3::Point = p1::Point + p2::Point
Adds p1 and p2 and returns a new point
"""
function Base.:+(p1::Point, p2::Point)
  Point(p1.x + p2.x, p1.y + p2.y, p1.z + p2.z)
end

# test add, and +
p1 = Point{Float32}(1.0, 2.0, 4.0)
p2 = Point{Float32}(1.0,2.0, 4.0)
p3 = add(p1, p2)
p3_ = p1 + p2
@assert p3 == p3_


# Subtraction sub! inplace, sub and - operator
#"""
#    sub!(p1::Point, p2::Point) -> ::Point
#Subtract p2 from p1, and return a new point.
#"""
#function sub!(p1::Point, p2::Point)
#  return add!(p1, -p2)
#end

#p1 = Point{Float32}(1.0, 2.0, 4.0)
#p2 = Point{Float32}(1.0,2.0, 4.0)
#sub!(p1, p2)
#@assert p1 == Point{Float32}(0, 0, 0)

"""
    sub(p1::Point, p2::Point) -> ::Point
Subtract p2 from p1, and return a new point.
"""
function sub(p1::Point, p2::Point)
  return p1 + (-p2) # not relying on Base.- as we compare later its results with Base.- results
end

"""
    p3::Point = p1::Point - p2:Point
Subtract p1 from p2, and return a new point.
"""
function Base.:(-)(p1::Point, p2::Point)
  return Point(p1.x - p2.x, p1.y - p2.y, p1.z - p2.z)
end

p1 = Point{Float32}(1.0, 2.0, 4.0)
p2 = Point{Float32}(1.0,2.0, 4.0)
p3 = sub(p1, p2)
p3_ = p1 - p2
@assert p3_ == p3

# Muliplication - inplace mul!, mul and * operator
#"""
#    mul!(p1::Point, p2::Point)
#
#  Multiply p1 and p2, and update p1 to p1*p2.
#"""
#function mul!(p1::Point, p2::Point)
#  p1.x *= p2.x
#  p1.y *= p2.y 
#  p1.z *= p2.z
#end

#p1 = Point{Float32}(1.0, 2.0, 4.0)
#p2 = Point{Float32}(1.0, 2.0, 4.0)
#mul!(p1, p2)
#@assert p1 == Point{Float32}(1.0, 4.0, 16.0)

"""
    mul(p1::Point, p2::Point) -> ::Point

  Multiply p1 and p2, and return a new point.
"""
function mul(p1::Point, p2::Point)
  return Point{Float32}(p1.x * p2.x, p1.y * p2.y, p1.z * p2.z)
end

"""
    p3::Point = p1::Point * p2::Point
  Multiply p1 and p2, and return a new point.
"""
function Base.:*(p1::Point, p2::Point)
  Point(p1.x*p2.x, p1.y*p2.y, p1.z*p2.z)
end

p1 = Point{Float32}(1.0, 2.0, 4.0)
p2 = Point{Float32}(1.0, 2.0, 4.0)
p3 = p1 * p2
p3_ = mul(p1, p2)
@assert p3 == p3_


# calculate norm and length_squared for a point
"""
    len_squared(p1::Point) -> Real

Returns x² + y² + z²
"""
function len_squared(p1::Point)
  return p1.x^2 + p1.y^2 + p1.z^2
end

# calculate the length squared of a point
p = Point{Float32}(0,3,4)
res = len_squared(p) 
@assert res == 25.0


"""
    len(p1::Point) -> Real

Returns the √(x² + y² + z²)
"""
function len(p1::Point)
  return sqrt(len_squared(p1))
end

# calculate the euclidean distance of a point
p = Point{Float32}(0,3,4)
@assert len(p) == 5.0


# Dot product
"""
    p1::Point ⋅ p2::Point -> Float32
Returns the result of dot product of 2 vectors
"""
function (⋅)(p1::Point, p2::Point)
  return p1.x * p2.x + p1.y * p2.y + p1.z * p2.z
end

res = p1 ⋅ p2
@assert res == 21.0f0


# Cross product
"""
    p1::Point × p2::Point -> ::Point

    Cross product of 2 vectors
"""
function (×)(u::Point, v::Point)
  return Point{Float32}((u.y * v.z) - (u.z * v.y), (u.z * v.x) - (u.x * v.z), (u.x * v.y) - (u.y * v.x))
end

p1 = Point{Float32}(1.0, 2.0, 3.0)
p2 = Point{Float32}(1.0, 2.0, 3.0)
p3 = p1 × p2
