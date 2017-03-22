module ImageDraw

# package code goes here
using ImageCore, ColorTypes

include("line2d.jl")
include("ellipse2d.jl")
include("circle2d.jl")
include("paths.jl")

#export Types
export LineTwoPoints, LineNormal

#export Methods
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

	#Paths
	path!,
	path

end # module
