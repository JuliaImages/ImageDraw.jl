module ImageDraw

# package code goes here
using ImageCore, Distances

include("core.jl")
include("line2d.jl")
include("ellipse2d.jl")
include("circle2d.jl")
include("paths.jl")
include("cross.jl")
include("rectangle.jl")
include("polygonfill2d.jl")

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
	RegularPolygon,
	RectanglePoints,

	#Cross
	Cross

	#Polygon fill
	boundaryfill
	
end # module
