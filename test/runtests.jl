module ImageDrawTest

# write your own tests here
using FactCheck, ImageDraw, Base.Test, Images

include("line2d.jl")
include("ellipse2d.jl")
include("circle2d.jl")
include("paths.jl")

isinteractive() || FactCheck.exitstatus()

end
