module ImageDraw

# package code goes here
using Images, ColorTypes

include("line2d.jl")
include("ellipse2d.jl")
include("circle2d.jl")
include("polygon2d.jl")

export
	#Lines
	line!,
	line,
	bresenham,
	xiaolin_wu,

	#Ellipse
	ellipse!,
	ellipse,

	#Circle
	circle!,
	circle,

	#Polygon
	lines!,
	lines

end # module
