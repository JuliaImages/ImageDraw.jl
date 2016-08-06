module ImageDrawTest

# write your own tests here
using FactCheck, ImageDraw, Base.Test, Images

include("draw2d.jl")

isinteractive() || FactCheck.exitstatus()

end
