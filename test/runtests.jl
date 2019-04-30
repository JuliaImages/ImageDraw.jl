module ImageDrawTest

using Test
using ImageDraw, ImageCore, ColorVectorSpace

tests = [
    "core.jl",
    "line2d.jl",
    "ellipse2d.jl",
    "circle2d.jl",
    "paths.jl"
]

for t in tests
    @testset "$t" begin
        include(t)
    end
end

end
