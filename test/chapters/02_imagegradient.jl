using Images, ImageView
using RayTracingWeekend
using BenchmarkTools
using Base.Threads
using InteractiveUtils

function render()
  # Generate an 256x256 image
  height = 256
  width = 256
  img = rand(RGB{Float32}, height, width)

  # julia is col major
  for col in 1:width 
    for row in 1:height 
      img[row, col] = RGB{Float32}(col/256.0f0, (256.0f0-row)/256.0f0, 0.25f0)
    end
  end
  img
end

print(@__FILE__)
time_f() = @time render()
time_f() 
time_f() 

# @btime render()
save("imgs/01_imagegradient.png", render())
