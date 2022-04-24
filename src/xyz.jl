# Based on https://raytracing.github.io/books/RayTracingInOneWeekend.html
import Base

# http://www.stochasticlifestyle.com/type-dispatch-design-post-object-oriented-programming-julia/
# julia follows inheritance by actions than data. Setup the abstract types hierarchy to mean the 
# existence or non-existence of some behavior

abstract type AbstractXYZ{T<:Real} end
abstract type AbstractPoint <: AbstractXYZ{Real} end
abstract type AbstractVec <: AbstractXYZ{Real} end

struct XYZ{T<:Real} <: AbstractXYZ{Real}
  x::T
  y::T
  z::T
end

struct Point{T<:Real} <: AbstractPoint
  x::T
  y::T
  z::T
end

struct Vec{T<:Real} <: AbstractVec
  x::T
  y::T
  z::T
end


"""
   print(p<:AbstractXYZ)
Prints the struct (Point, Vec) with values.

x = XYZ{Float64}(1.0, 2.0, 3.0)
print(x)

x = Point{Float64}(1.0, 2.0, 3.0)
print(x)

x = Vec{Float64}(1.0, 2.0, 3.0)
print(x)

"""
function Base.print(p::AbstractXYZ) # Harish: writing the action outcome based on type details, will let compiler do optimizations!
  if typeof(p) <: AbstractPoint
    println("Point($(p.x), $(p.y), $(p.z))")
  elseif typeof(p) <: AbstractVec
    println("Vec($(p.x), $(p.y), $(p.z))")
  elseif typeof(p) <: AbstractXYZ
    println("XYZ($(p.x), $(p.y), $(p.z))")
  end
end

x = XYZ{Float64}(1.0, 2.0, 3.0)
print(x)

x = Point{Float64}(1.0, 2.0, 3.0)
print(x)

x = Vec{Float64}(1.0, 2.0, 3.0)
print(x)

"""
    - p::XYZ -> -p::XYZ
Return a negative value of the given XYZ (Point, Vec).
"""
function Base.:-(p::AbstractXYZ)
  if typeof(p) <: AbstractPoint # the actions associated with Point is different from vec
    return Point{}(-p.x, -p.y, -p.z) 
  elseif typeof(p) <: AbstractVec
    return Vec{}(-p.x, -p.y, -p.z)
  elseif typeof(p) <: AbstractXYZ
    return XYZ{}(-p.x, -p.y, -p.z)
  end
end

x = XYZ{Float64}(1.0, 2.0, 3.0)
neg_x = -x
x = Point{Float64}(1.0, 2.0, 3.0)
neg_x = -x
x = Vec{Float64}(1.0, 2.0, 3.0)
neg_x = -x

x = XYZ{Float32}(1.0, 2.0, 3.0)
neg_x = -x
x = Point{Float32}(1.0, 2.0, 3.0)
neg_x = -x
x = Vec{Float32}(1.0, 2.0, 3.0)
neg_x = -x

x = XYZ{Int32}(1.0, 2.0, 3.0)
neg_x = -x
x = Point{Int32}(1.0, 2.0, 3.0)
neg_x = -x
x = Vec{Int32}(1.0, 2.0, 3.0)
neg_x = -x


"""
    p::AbstractXYZ / r::Real -> p::AbstractXYZ
Returns a AbstractXYZ (Point, Vec) divided by a real r.

x = Vec{Int32}(1.0, 2.0, 3.0)
div_x = x/2.0
Vec{Float64}(0.5, 1.0, 1.5)

"""
function Base.:/(p::AbstractXYZ, r::Real)
  if typeof(p) <: AbstractPoint
    return Point{}(p.x/r, p.y/r, p.z/r)
  elseif typeof(p) <: AbstractVec
    return Vec{}(p.x/r, p.y/r, p.z/r)
  elseif typeof(p) <: AbstractXYZ
    return XYZ{}(p.x/r, p.y/r, p.z/r)
  end
end


"""
    Real * p::XYZ -> p::XYZ
Return a XYZ (Point, Vec) multiplied by a real.

x = Vec{Int32}(1.0, 2.0, 3.0)
x_2 = x * 2
x_2 = 2 * x

"""
function Base.:*(p::AbstractXYZ, r::Real)
  if typeof(p) <: AbstractPoint
    return Point{}(p.x*r, p.y*r, p.z*r)
  elseif typeof(p) <: AbstractVec
    return Vec{}(p.x*r, p.y*r, p.z*r)
  elseif typeof(p) <: AbstractXYZ
    return XYZ{}(p.x*r, p.y*r, p.z*r)
  end
end

Base.:*(r::Real, p::AbstractXYZ) = p * r

x = Vec{Int32}(1.0, 2.0, 3.0)
x_2 = x * 2
x_2 = 2 * x


"""
    p1::AbstractXYZ == p2::AbstractXYZ
Check whether the given 2 AbstractXYZ (Point, Vec) are equal.
"""
function Base.:(==)(p1::AbstractXYZ, p2::AbstractXYZ)
  p1.x == p2.x && p1.y == p2.y && p1.z == p2.z
end


"""
    p3::AbstractXYZ = p1::AbstractXYZ + p2::AbstractXYZ
Adds p1 and p2 and returns a new AbstractXYZ (Point, Vec).

There are 3 cases to consider:
1. Addition of 2 points
2. Addition of a point and vec
3. Addition of 2 vectors

Addition is not defined for XYZ type.

  x1 = Point{Float64}(1.0, 2.0, 3.0)
  x2 = Vec{Int32}(1.0, 2.0, 3.0)
  print(x1 + x2)
  
  x1 = Vec{Float64}(1.0, 2.0, 3.0)
  x2 = Vec{Int32}(1.0, 2.0, 3.0)
  print(x1 + x2)
  
  x1 = Point{Int32}(1.0, 2.0, 3.0)
  x2 = Point{Int32}(1.0, 2.0, 3.0)
  print(x1 + x2)

"""
function Base.:+(p1::AbstractXYZ, p2::AbstractXYZ)
  # case 1 both are points
  if typeof(p1) <: AbstractPoint && typeof(p2) <: AbstractPoint
    return Point{}(p1.x+p2.x, p1.y+p2.y, p1.z+p2.z)
  end
  # case 2 any of the input is a point
  if typeof(p1) <: AbstractPoint || typeof(p2) <: AbstractPoint
    return Point{}(p1.x+p2.x, p1.y+p2.y, p1.z+p2.z)
  end
  # case 3 both are vectors
  if typeof(p1) <: AbstractVec && typeof(p2) <: AbstractVec
    return Vec{}(p1.x+p2.x, p1.y+p2.y, p1.z+p2.z)
  end
end


"""
    p3::AbstractXYZ = p1::AbstractXYZ - p2:AbstractXYZ
Subtract p1 from p2, and return a new (Point, Vec).

Check addition docs to determine for more details.
"""
function Base.:(-)(p1::AbstractXYZ, p2::AbstractXYZ)
  return p1 + (-p2)
end

# Multiplication of Points/Vectors are ill defined

# """
#     p3::AbstractXYZ = p1::AbstractXYZ * p2::AbstractXYZ
#   Multiply p1 and p2, and return a new (Point, Vec).
# """
# function Base.:*(p1::AbstractXYZ, p2::AbstractXYZ)
#   # case 1 both are points
#   if typeof(p1) <: AbstractPoint && typeof(p2) <: AbstractPoint
#     return Point{}(p1.x*p2.x, p1.y*p2.y, p1.z*p2.z)
#   end
#   # case 2 any of the input is a point
#   if typeof(p1) <: AbstractPoint || typeof(p2) <: AbstractPoint
#     return Point{}(p1.x*p2.x, p1.y*p2.y, p1.z*p2.z)
#   end
#   # case 3 both are vectors
#   if typeof(p1) <: AbstractVec && typeof(p2) <: AbstractVec
#     return Vec{}(p1.x*p2.x, p1.y*p2.y, p1.z*p2.z)
#   end
# end


# calculate norm and length_squared for a point
"""
    len_squared(p1::XYZ) -> Real

Returns x² + y² + z²
"""
len_squared(p1::AbstractXYZ) = p1.x^2 + p1.y^2 + p1.z^2


"""
    len(p1::AbstractXYZ) -> Real

Returns the √(x² + y² + z²)
"""
len(p1::AbstractXYZ) = sqrt(len_squared(p1))


# Dot product
"""
    p1::AbstractVec ⋅ p2::AbstractVec -> Float32
Returns the result of dot product of 2 Vec

x1 = Vec{Int32}(1.0, 2.0, 3.0)
x2 = Vec{Int32}(1.0, 2.0, 3.0)
println(x1 ⋅ x2)

"""
function (⋅)(p1::AbstractVec, p2::AbstractVec)
  return p1.x * p2.x + p1.y * p2.y + p1.z * p2.z
end


# Cross product
"""
    p1::AbstractVec × p2::AbstractVec -> ::AbstractVec

    Cross product of 2 vectors, return a new vector
"""
function (×)(u::AbstractVec, v::AbstractVec)
  return Vec{}((u.y * v.z) - (u.z * v.y), (u.z * v.x) - (u.x * v.z), (u.x * v.y) - (u.y * v.x))
end

p1 = Vec{Float32}(1.0, 2.0, 3.0)
p2 = Vec{Float32}(1.0, 2.0, 3.0)
p3 = p1 × p2

# Convert a point to a vector (subtract from Vec(0.0, 0.0, 0.0))
to_vec(p::Point) = Vec{}(p.x, p.y, p.z)

x1 = Point{Int32}(1.0, 2.0, 3.0)
v1 = to_vec(x1)