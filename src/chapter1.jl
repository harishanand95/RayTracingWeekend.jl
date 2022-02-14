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


"""
    - p::Point -> p::Point
Return a negative value of the given point.
"""
function (-)(p::Point) 
  n = Point(-1*p.x, -1*p.y, -1*p.z)
  return n
end

# negative p (Int)
negative_p = -p
# negative p (Float32)
negative_p_fp32 = -p_fp32
@assert negative_p_fp32.x == -3.2
@assert negative_p_fp32.y == -4.1
@assert negative_p_fp32.z == -5.003

"""
    add(p1::Point, p2::Point) 

Adds the Point p2 to Point p1.
"""
function add!(p1::Point, p2::Point)
  p1.x = p1.x + p2.x
  p1.y = p1.y + p2.y
  p1.z = p1.z + p1.z
end

# Add the int p to float p_fp32
add!(p_fp32, p)
p_fp32
@assert p_fp32.x == 6.2
@assert p_fp32.y == 8.1
@assert p_fp32.z == 10.006

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

# Additional utility functions
#   1. add points/vectors
#   2. subtract vectors
#   3. multiply vectors
#   3. mutiply and divide by number
#   4. dot product
#   5. cross product
#   6. unit vector

"""
    add(p1::point, p2::point) -> ::point
Adds p1 and p2 and returns a new point
"""

