module ImageDraw

# package code goes here
using ImageCore, ColorTypes

include("line2d.jl")
include("ellipse2d.jl")
include("circle2d.jl")
include("paths.jl")

export
	#Lines
	line!,
	line,
	bresenham,
	xiaolin_wu,
	line_normal!,
	line_normal,

	#Ellipse
	ellipse!,
	ellipse,

	#Circle
	circle!,
	circle,

	#Paths
	path!,
	path

end # module
