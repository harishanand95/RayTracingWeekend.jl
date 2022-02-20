abstract type AbstractXYZ <: Real end
mutable struct Point{T} <: AbstractXYZ
  x::T
  y::T
  z::T
end

# create an integer point
p = Point{Int}(3,4,5)

# create a float point
p_fp32 = Point{Float32}(3.2,4.1,5.003)


import Base.-

"""
    - p::Point -> p::Point
Return a negative value of the given point.
"""
# function (-)(p::Point)
#   return Point(-1.0*p.x, -1.0*p.y, -1.0*p.z)
# end
# https://discourse.julialang.org/t/bug-in-unary-operator-overloading-syntax/63117
Base.:-(p::Point) = Point(-p.x, -p.y, -p.z)

# negative p (Int)
negative_p = -p
# negative p (Float32)
negative_p_fp32 = -p_fp32
@assert negative_p_fp32.x == -3.2f0
@assert negative_p_fp32.y == -4.1f0
@assert negative_p_fp32.z == -5.003f0


"""
    add(p1::Point, p2::Point) 

Adds the Point p2 to Point p1.
"""
function add!(p1::Point, p2::Point)
  p1.x = p1.x + p2.x
  p1.y = p1.y + p2.y
  p1.z = p1.z + p2.z
end

# Add the int p to float p_fp32
add!(p_fp32, p)

p_fp32
@assert p_fp32.x == 6.2f0
@assert p_fp32.y == 8.1f0
@assert p_fp32.z == 10.003f0

# This is wrong as you are going to write to p which is an Int
# psum = add!(p, p_fp32)


"""
    mul!(p1::Point, scale::Real)

Multiplies p1 by scale and stores the result in p1.
"""
function mul!(p1::Point, scale::Real)
  p1.x = p1.x * scale
  p1.y = p1.y * scale
  p1.z = p1.z * scale
end

# multiply x, y, z by a scale=2
mul!(p_fp32, 2)
p_fp32


""" 
    div!(p1::Point, scale)

Divides each element in p1 by scale.
"""
function div!(p1::Point, scale::Real)
  mul!(p1, 1/scale)
end

# divide x, y, z in p_fp32 by 2
div!(p_fp32, 2)
p_fp32


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


"""
    add(p1::point, p2::point) -> ::point
Adds p1 and p2 and returns a new point
"""
function add(p1::Point, p2::Point)
  temp = Point{Float32}(p1.x, p1.y, p1.z)
  add!(temp, p2)
  return temp
end

p1 = Point{Float32}(1.0,2.0,4.0)
p2 = Point{Float32}(1.0,2.0,4.0)
p3 = add(p1, p2)

@assert p3.x == 2.0f0
@assert p3.y == 4.0f0
@assert p3.z == 8.0f0


"""
    sub(p1::Point, p2::Point) -> ::Point

Subtract p2 from p1, and return a new point.
"""
function sub(p1::Point, p2::Point)
  return add(p1, -p2)
end

p3 = sub(p1, p2)

 
"""
    mul(p1::Point, p2::Point) -> ::Point

  Multiply p1 and p2, and return a new point.
"""
function mul(p1::Point, p2::Point)
  return Point{Float32}(p1.x * p2.x, p1.y * p2.y, p1.z * p2.z)
end

p3 = mul(p1, p2)

@assert p3.x == 1.0f0
@assert p3.y == 4.0f0
@assert p3.z == 16.0f0


"""
    p1::Point ⋅ p2::Point -> Float32
Returns the result of dot product of 2 vectors
"""
function (⋅)(p1::Point, p2::Point)
  return p1.x * p2.x + p1.y * p2.y + p1.z * p2.z
end

res = p1 ⋅ p2
@assert res == 21.0f0


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

