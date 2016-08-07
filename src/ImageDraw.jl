module ImageDraw

# package code goes here
using Images, ColorTypes

include("line2d.jl")
include("circle2d.jl")

export
	#Lines
	line!,
	line,
	bresenham,
	xiaolin_wu

end # module
