using Documenter, ImageDraw

makedocs(sitename="Documentation",
            format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"))
deploydocs(repo = "github.com/JuliaImages/ImageDraw.jl.git")