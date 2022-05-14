module RayTracingWeekend

export 
# Types
    Point,
    Vec,
    Ray,
    Camera,
    HitRecord,
    Hittable,
    Sphere,
    Material,
    Lambertian,
    Metal,
    HitRecord2,
    Sphere2,
# Functions
    len,
    len_squared,
    to_vec,
    to_point,
    random_vector,
    degrees_to_radians,
    random_in_unit_sphere,
    at,
    pixel_color,
    sky_color,
    get_camera,
    get_ray,
    get_sampled_color,
    set_hit_record,
    set_face_normal,
    hit!,
    hit,
    add!,
    clear!,
    scatter,
    get_hit_record,
# Operators
    ×,
    ⋅,

# Constants
    PI

include("xyz.jl")
include("utils.jl")
include("ray.jl")
include("render.jl")
include("camera.jl")
include("material.jl")
include("hittable.jl")

end
