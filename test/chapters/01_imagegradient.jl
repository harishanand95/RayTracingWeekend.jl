using Images, ImageView
using RayTracingWeekend
using BenchmarkTools

function render()
  # Generate an 256x256 image
  height = trunc(256)
  width = trunc(256)
  img = rand(RGB{Float32}, height, width)

  # julia is col major
  for col in 1:width 
    for row in 1:height 
      img[row, col] = pixel_color(Point(col/256, (256-row)/256, 0.25))
    end
  end
  img
end

print(@__FILE__)
@btime render()
save("imgs/01_imagegradient.png", render())
