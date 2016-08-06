module ImageDraw

# package code goes here
using Images, ColorTypes

include("draw2d.jl")

export
	#Lines
	line,
	bresenham,
	xiaolin_wu

end # module
