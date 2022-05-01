module RayTracingWeekend

export 
# Types
    Point,
    Vec,
    XYZ,
    Ray,
    Camera,
    HitRecord,
    Hittable,
    Sphere,

# Functions
    len,
    len_squared,
    to_vec,
    to_point,
    random_vector,
    degrees_to_radians,
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
include("hittable.jl")

end
