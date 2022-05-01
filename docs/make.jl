using RayTracingWeekend
using Documenter

DocMeta.setdocmeta!(RayTracingWeekend, :DocTestSetup, :(using RayTracingWeekend); recursive=true)

makedocs(;
    modules=[RayTracingWeekend],
    authors="Harish Anand",
    repo="https://github.com/harishanand95/RayTracingWeekend.jl/blob/{commit}{path}#{line}",
    sitename="RayTracingWeekend.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://harishanand95.github.io/RayTracingWeekend.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/harishanand95/RayTracingWeekend.jl",
    devbranch="main",
)
