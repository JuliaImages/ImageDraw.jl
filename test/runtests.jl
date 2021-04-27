module ImageDrawTest

using Test
using ImageDraw, ImageCore, ColorVectorSpace

tests = [
    "core.jl",
    "line2d.jl",
    "ellipse2d.jl",
    "circle2d.jl",
    "paths.jl",
    "cross.jl",
    "rectangle.jl",
    "polygon2d.jl"
]

for t in tests
    @testset "$t" begin
        include(t)
    end
end

end
