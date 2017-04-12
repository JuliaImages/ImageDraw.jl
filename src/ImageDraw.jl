module ImageDraw

# package code goes here
using ImageCore, ColorTypes, Distances

include("core.jl")
include("line2d.jl")
include("ellipse2d.jl")
include("circle2d.jl")
include("paths.jl")

#export methods
export
	draw,
	draw!,
	bresenham,
	xiaolin_wu

#export types
export
	#Drawable
	Drawable,

	#Point
	Point,

	#Lines
	LineNormal,
	LineTwoPoints,

	#LineSegment
	LineSegment,

	#Ellipse
	Ellipse,

	#Circles
	CirclePointRadius,
	CircleThreePoints,

	#Path
	Path,

	#Polygons
	Polygon,
	RegularPolygon

end # module
