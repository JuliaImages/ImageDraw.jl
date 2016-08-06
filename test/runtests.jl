module ImageDrawTest

# write your own tests here
using FactCheck, ImageDraw, Base.Test, Images

include("line2d.jl")

isinteractive() || FactCheck.exitstatus()

end
