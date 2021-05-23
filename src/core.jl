"""
Type representing any object drawable on image
"""
abstract type Drawable end

"""
Root type for the polygon filling algorithm in `ImageDraw` packages

Any concrete polygon filling algorithm shall subtype it to support 
`draw` and `draw!` APIs.

"""
abstract type AbstractPolyFillAlgorithm end

"""
    p = Point(x,y)
    p = Point(c)

A `Drawable` point on the image
"""
struct Point <: Drawable
    x::Int
    y::Int
end

abstract type Line <: Drawable end
abstract type Circle <: Drawable end
abstract type Rectangle <: Drawable end


"""
    line = LineTwoPoints(p1, p2)

A `Drawable` infinite length line passing through the two points
`p1` and `p2`.
"""
struct LineTwoPoints <: Line
    p1::Point
    p2::Point
end

"""
    line = LineNormal(ρ, θ)

A `Drawable` infinte length line having perpendicular length `ρ` from
origin and angle `θ` between the perpendicular and x-axis

"""
struct LineNormal{T<:Real, U<:Real} <: Line
    ρ::T
    θ::U
end

"""
    circle = CircleThreePoints(p1, p2, p3)

A `Drawable` circle passing through points `p1`, `p2` and `p3`
"""
struct CircleThreePoints <: Circle
    p1::Point
    p2::Point
    p3::Point
end

"""
    circle = CirclePointRadius(center, ρ; thickness = 0, fill = false)

A `Drawable` circle having center `center` and radius `ρ`
with keyword arguments `thickness` and `fill` for drawing hollow circle

# Arguments
- `thickness::Int`: thickness of the circle
- `fill::Bool`: argument to determine whether to fill the circle or not

# Examples
```
using ImageDraw,TestImages,ImageView, ColorVectorSpace
img = testimage("lighthouse")

draw!(img, Ellipse(CirclePointRadius(350,200,100))) 
draw!(img, Ellipse(CirclePointRadius(150,200,100; thickness = 70 , fill = false)))
```

"""
struct CirclePointRadius{T<:Real} <: Circle
    center::Point
    ρ::T
    thickness::Int
    fill::Bool
    function CirclePointRadius{T}(center::Point, ρ::T; thickness::Int = 0, fill::Bool = true) where {T<:Real}
        thickness >= ρ && throw(ArgumentError("Thickness $thickness should be smaller than $(ρ)."))
        new{T}(center, ρ, thickness, fill)
    end
end

CirclePointRadius(center::Point, ρ::T; kwargs...) where {T<:Real} = CirclePointRadius{T}(center, ρ; kwargs...)

"""
    ls = LineSegment(p1, p2)

A `Drawable` finite length line between `p1` and `p2`
"""
struct LineSegment <: Drawable
    p1::Point
    p2::Point
end

"""
    path = Path([point])

A `Drawable` sequence of line segments connecting consecutive pairs
of points in `[point]`.
!!! note
    This will create a non-closed path. For a closed path, see `Polygon`
"""
struct Path <: Drawable
    vertices::Vector{Point}
end

"""
    ellipse = Ellipse(center, ρx, ρy; thickness = 0,fill = false)

A `Drawable` ellipse with center `center` and parameters `ρx` and `ρy`
with keyword arguments `thickness` and `fill` for drawing hollow ellipse

# Arguments
- `thickness::Int`: thickness of the circle
- `fill::Bool`: argument to determine whether to fill the ellipse or not

# Examples
```
using ImageDraw,TestImages,ImageView, ColorVectorSpace
img = testimage("lighthouse")

draw(img, Ellipse(5, 5, 5, 5), Gray{N0f8}(0.5))
draw(img, Ellipse(CartesianIndex(5,5), 5, 3))
draw(img, Ellipse(CirclePointRadius(Point(6, 6), 5; thickness = 4, fill = false)))
```
"""

struct Ellipse{T<:Real, U<:Real} <: Drawable
    center::Point
    ρx::T
    ρy::U
    thickness::Int
    fill::Bool
    function Ellipse{T, U}(center, ρx::T, ρy::U; thickness::Int = 0, fill::Bool = true) where {T<:Real, U<:Real}
        thickness >= min(ρx, ρy) && throw(ArgumentError("Thickness $thickness should be smaller than $(min(ρx, ρy))."))
        new{T, U}(center, ρx, ρy, thickness, fill)
    end
end

Ellipse(center::Point, ρx::T, ρy::U; kwargs...) where {T<:Real, U<:Real} = Ellipse{T,U}(center, ρx, ρy; kwargs...)

""" 
    polygon = Polygon([vertex])

A `Drawable` polygon i.e. a closed path created by joining the
consecutive points in `[vertex]` along with the first and last point.
!!! note
    This will create a closed path. For a non-closed path, see `Path`
"""
struct Polygon <: Drawable
    vertices::Vector{Point}
end

"""
    BoundaryFill <: AbstractPolyFillAlgorithm
    BoundaryFill(x::Int, y::Int, fill_value::T, boundary_value::T)

    draw(img, verts, alg::BoundaryFill; closed)
    draw!(img, verts, alg::BoundaryFill; closed)

Applies boundary filling algortithm on image inside the vertices provided in order

# Output

Return the boundary filled image inside the vertices(provided in order). 

# Arguments

## `x` && `y`

Boundary fill is a seeded polygon filling algorithm. 
So we need to provide the seed point (x,y) inside the image from where the algorithm can start its function.

## `fill_value`

The pixels inside the boundary of vertices of polygon are filled with this colorant parameter.

## `boundary_value`

The pixels to define the boundary using verts is filled with this colorant parameter. 
Without this parameter, the whole picture will be filled with the `fill_value`

# `closed`

`closed` keyword specifies whether to connect the polygon edges using the verts provided. 
Edges will be filled and connected using `boundary_value`.

```julia
using ImageDraw

img = zeros(RGB, 7, 7)
expected = copy(img)
expected[2:6, 2:6] .= RGB{N0f8}(1)

verts = [CartesianIndex(2, 2), CartesianIndex(2, 6), CartesianIndex(6, 6), CartesianIndex(6, 2), CartesianIndex(2,2)]

fill_method = draw(img, verts, BoundaryFill(4, 4; fill_value = RGB(1), boundary_value = RGB(1)); closed = true)
```
"""

struct BoundaryFill{T<:Colorant} <: AbstractPolyFillAlgorithm
    x::Int
    y::Int
    fill_value::T
    boundary_value::T
    function BoundaryFill(x::Int, y::Int, fill_value::T, boundary_value::T) where {T <: Colorant}
        new{T}(x, y, fill_value, boundary_value)
    end
end

BoundaryFill(x::Int = 1, y::Int = 1; fill_value::Colorant = RGB(1), boundary_value::Colorant = fill_value) = BoundaryFill(x, y, fill_value, boundary_value)
BoundaryFill(p::CartesianIndex{2}; fill_value::Colorant = RGB(1), boundary_value::Colorant = fill_value) = BoundaryFill(p[1], p[2], fill_value, boundary_value)
BoundaryFill(p::Point; fill_value::Colorant = RGB(1), boundary_value::Colorant = fill_value) = BoundaryFill(p.y, p.x, fill_value, boundary_value)

"""
    FloodFill{T<:Colorant} <: AbstractPolyFillAlgorithm
    FloodFill( x::Int, y::Int, fill_value::T, boundary_value::T)

    draw(img, verts, alg::FloodFill; closed)
    draw!(img, verts, alg::FloodFill; closed)


"""
struct FloodFill{T<:Colorant} <: AbstractPolyFillAlgorithm
    x::Int
    y::Int
    fill_value::T
    current_value::T
    function FloodFill(x::Int, y::Int, fill_value::T, current_value::T) where {T <: Colorant}
        new{T}(x, y, fill_value, current_value)
    end

end

FloodFill(x::Int = 1, y::Int = 1; fill_value::Colorant = RGB(1), current_value::Colorant = fill_value) = FloodFill(x, y, fill_value, current_value)
FloodFill(p::CartesianIndex{2}; fill_value::Colorant = RGB(1), current_value::Colorant = fill_value) = FloodFill(p[1], p[2], fill_value, current_value)
FloodFill(p::Point; fill_value::Colorant = RGB(1), current_value::Colorant = fill_value) = FloodFill(p.y, p.x, fill_value, current_value)


"""
    rectangle = RectanglePoints(p1, p2)
    rectangle = RectanglePoints(x1, y1, x2, y2)

A `Drawable` rectangle i.e. a closed path where parameters `p1` and `p2` 
are diagonally opposite vertices of the rectangle.

Parameters `p1` and `p2` can be passed in either `Point` struct format or `CartesianIndex` format as shown in example below.
`(x1, y1, x2, y2)` is interpreted as `(CartesianIndex(x1, y1), CartesianIndex(x2, y2))`.

# Examples

```julia
using TestImages, ImageDraw, ImageCore
img = testimage("lighthouse")

# rectangles drawn on img using different methods of passing parameters
draw!(img, Polygon(RectanglePoints(Point(10, 10), Point(100, 100))), RGB{N0f8}(1))
draw!(img, Polygon(RectanglePoints(CartesianIndex(110, 10), CartesianIndex(200, 200))), RGB{N0f8}(1))
draw!(img, Polygon(RectanglePoints(220, 10, 300, 300)), RGB{N0f8}(1))
```

"""
struct RectanglePoints <: Rectangle
    p1::Point
    p2::Point
end

"""
    rp = RegularPolygon(center, side_count, side_length, θ)

A `Drawable` regular polygon.

#Arguments
* `center::Point` : the center of the polygon
* `side_count::Int` : number of sides of the polygon
* `side_length::Real` : length of each side
* `θ::Real` : orientation of the polygon w.r.t x-axis (in radians)

"""
struct RegularPolygon{T<:Real, U<:Real} <: Drawable
    center::Point
    side_count::Int
    side_length::T
    θ::U
end

"""
    cross = Cross(c, range::UnitRange{Int})
A `Drawable` cross passing through the point `c` with arms ranging across `range`.
"""
struct Cross <: Drawable
    c::Point
    range::UnitRange{Int}
end

"""
    img = draw!(img, drawable, color)
    img = draw!(img, drawable)

Draws `drawable` on `img` using color `color` which
defaults to `oneunit(eltype(img))`
"""
draw!(img::AbstractArray{T,2}, object::Drawable) where {T<:Colorant} = draw!(img, object, oneunit(T))


"""
    img = draw!(img, [drawable], [color])
    img = draw!(img, [drawable] ,color)
    img = draw!(img, [drawable])

Draws all objects in `[drawable]` in the given order on `img` using
corresponding colors from `[color]` which defaults to `oneunit(eltype(img))`
If only a single color `color` is specified then all objects will be
colored with that color.
"""
function draw!(img::AbstractArray{T,2}, objects::AbstractVector{U}, colors::AbstractVector{V}) where {T<:Colorant, U<:Drawable, V<:Colorant}
    colors = copy(colors)
    while length(colors) < length(objects)
        push!(colors, oneunit(T))
    end
    foreach((object, color) -> draw!(img, object, color), objects, colors)
    img
end

draw!(img::AbstractArray{T,2}, objects::AbstractVector{U}, color::T = oneunit(T)) where {T<:Colorant, U<:Drawable} =
    draw!(img, objects, [color for i in 1:length(objects)])

"""
    img_new = draw(img, drawable, color)
    img_new = draw(img, [drawable], [color])

Draws the `drawable` object on a copy of image `img` using color
`color`. Can also draw multiple `Drawable` objects when passed
as a `AbstractVector{Drawable}` with corresponding colors in `[color]`
"""
draw(img::AbstractArray{T,2}, args...) where {T<:Colorant} = draw!(copy(img), args...)

Point(τ::Tuple{Int, Int}) = Point(τ...)
Point(p::CartesianIndex) = Point(p[2], p[1])

function draw!(img::AbstractArray{T,2}, point::Point, color::T) where T<:Colorant
    drawifinbounds!(img, point, color)
end

"""

    img_new = drawifinbounds!(img, y, x, color)
    img_new = drawifinbounds!(img, Point, color)
    img_new = drawifinbounds!(img, CartesianIndex, color)

Draws a single point after checkbounds() for coordinate in the image.
Color Defaults to oneunit(T)

"""

drawifinbounds!(img::AbstractArray{T,2}, p::Point, color::T = oneunit(T)) where {T<:Colorant} = drawifinbounds!(img, p.y, p.x, color)
drawifinbounds!(img::AbstractArray{T,2}, p::CartesianIndex{2}, color::T = oneunit(T)) where {T<:Colorant} = drawifinbounds!(img, Point(p), color)

function drawifinbounds!(img::AbstractArray{T,2}, y::Int, x::Int, color::T) where {T<:Colorant}
    if checkbounds(Bool, img, y, x) img[y, x] = color end
    img
end
