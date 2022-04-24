# Based on https://raytracing.github.io/books/RayTracingInOneWeekend.html
import Base
include("xyz.jl")


# create an integer point
p = Point{Int}(3, 4, 5)
# create a float point
p_fp32 = Point{Float32}(3.2, 4.1, 5.003)
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

# test +
p1 = Point{Float32}(1.0, 2.0, 4.0)
p2 = Point{Float32}(1.0, 2.0, 4.0)
p3_ = p1 + p2
@assert Point{Float32}(2.0, 4.0, 8.0) == p3_

p1 = Point{Float32}(1.0, 2.0, 4.0)
v2 = Vec{Float32}(1.0, 2.0, 4.0)
p3_ = p1 + v2
@assert Point{Float32}(2.0, 4.0, 8.0) == p3_

# test - 
p1 = Point{Float32}(1.0, 2.0, 4.0)
p2 = Point{Float32}(1.0,2.0, 4.0)
p3_ = p1 - p2
@assert p3_ == Point{Float32}(0.0, 0.0, 0.0)

# Ill defined operation: Muliplication - inplace mul!, mul and * operator
# p1 = Point{Float32}(1.0, 2.0, 4.0)
# p2 = Point{Float32}(1.0, 2.0, 4.0)
# p3 = p1 * p2
# p3_ = mul(p1, p2)
# @assert p3 == p3_

# calculate the length squared of a point
p = Point{Float32}(0, 3, 4)
res = len_squared(p) 
@assert res == 25.0

# calculate the euclidean distance of a point
p = Point{Float32}(0,3,4)
@assert len(p) == 5.0

# dot product
v1 = Vec{Float32}(0,3,4)
v2 = Vec{Float32}(0,3,4)
res = v1 ⋅ v2
@assert res == 25.0f0


# Cross product
v1 = Vec{Float32}(1.0, 2.0, 3.0)
v2 = Vec{Float32}(1.0, 2.0, 3.0)
v3 = v1 × v2
