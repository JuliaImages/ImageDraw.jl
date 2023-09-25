"""
Type representing any object drawable on image
"""
abstract type Drawable end

"""
    p = Point(x,y)
    p = Point(c)

A `Drawable` point on the image
"""
struct Point <: Drawable
    x::Int
    y::Int
end

Point(τ::Tuple{Int, Int}) = Point(τ...)
Point(p::CartesianIndex) = Point(p[2], p[1])


abstract type Line <: Drawable end

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
    ellipse = Ellipse(center, ρx, ρy; thickness=0, fill=false)

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
draw(img, Ellipse(CirclePointRadius(Point(6, 6), 5; thickness=4, fill=false)))
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


abstract type Circle <: Drawable end

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
using ImageDraw, TestImages, ImageView, ColorVectorSpace
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


abstract type Rectangle <: Drawable end

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

Path(v::AbstractVector{Tuple{Int, Int}}) = Path([Point(p...) for p in v])
Path(v::AbstractVector{CartesianIndex{2}}) = Path([Point(p) for p in v])


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

Polygon(v::AbstractVector{Tuple{Int, Int}}) = Polygon([Point(p...) for p in v])
Polygon(v::AbstractVector{CartesianIndex{2}}) = Polygon([Point(p) for p in v])
Polygon(rectangle::RectanglePoints) = Polygon([rectangle.p1, Point(rectangle.p2.x, rectangle.p1.y), rectangle.p2, Point(rectangle.p1.x, rectangle.p2.y)])


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
    img = draw!(img, drawable, color, opacity=opacity)
    img = draw!(img, drawable, color)
    img = draw!(img, drawable)

Draws `drawable` on `img` using color `color` which
defaults to `oneunit(eltype(img))` with opacity `opsacity` which defaults to 1.0.
"""

draw!(img::AbstractArray{T,2}, object::Drawable; opacity::AbstractFloat = 1.0) where {T<:Colorant} = draw!(img, object, oneunit(T), opacity=opacity)

"""
    img = draw!(img, [drawable], [color], opacities=[opacity])
    img = draw!(img, [drawable], [color])
    img = draw!(img, [drawable], color, opacities=opacity)
    img = draw!(img, [drawable], color)
    img = draw!(img, [drawable])

Draws all objects in `[drawable]` in the given order on `img` using
corresponding colors from `[color]` and opacities from [opacity] which 
default to `oneunit(eltype(img))` and 1.0 correspondingly.
If only a single color `color` and a single opacity `opacity` are specified then all objects will be
colored with that color and opacity.
"""
function draw!(img::AbstractArray{T,2}, objects::AbstractVector{U}, colors::AbstractVector{V}; opacities::AbstractVector{F}=Float64[]) where {T<:Colorant, U<:Drawable, V<:Colorant, F<:AbstractFloat}
    colors = copy(colors)
    while length(colors) < length(objects)
        push!(colors, oneunit(T))
    end
    opacities = copy(opacities)
    while length(opacities) < length(objects)
        push!(opacities, 1.0)
    end
    foreach((object, color, opacity) -> draw!(img, object, color, opacity=opacity), objects, colors, opacities)
    img
end

draw!(img::AbstractArray{T,2}, objects::AbstractVector{U}, color::T = oneunit(T); opacity::AbstractFloat = 1.0) where {T<:Colorant, U<:Drawable} =
    draw!(img, objects, [color for i in 1:length(objects)], opacities=[opacity for i in 1:length(objects)])

"""
    img_new = draw(img, drawable, color)
    img_new = draw(img, [drawable], [color])
    img_new = draw(img, [drawable], [color], opacity=[opacity])

Draws the `drawable` object on top of a copy of image `img` using color
`color` with opacity `opacity`. Can also draw multiple `Drawable` objects when passed
as a `AbstractVector{Drawable}` with corresponding colors in `[color]` and opacities in `[opacity]`.
"""
draw(img::AbstractArray{T,2}, args...; kwargs...) where {T<:Colorant} = draw!(copy(img), args...; kwargs...)

function draw!(img::AbstractArray{T,2}, point::Point, color::T; opacity::AbstractFloat = 1.0) where T<:Colorant
    drawifinbounds!(img, point, color, opacity=opacity)
end

"""

    img_new = drawifinbounds!(img, y, x, color)
    img_new = drawifinbounds!(img, Point, color)
    img_new = drawifinbounds!(img, CartesianIndex, color)
    img_new = drawifinbounds!(img, CartesianIndex, color, opacity=opacity)

Draws a single point after checkbounds() for coordinate in the image.
Color Defaults to oneunit(T)

"""
drawifinbounds!

drawifinbounds!(img::AbstractArray{T,2}, p::Point, color::T = oneunit(T); opacity::AbstractFloat = 1.0) where {T<:Colorant} = drawifinbounds!(img, p.y, p.x, color, opacity=opacity)
drawifinbounds!(img::AbstractArray{T,2}, p::CartesianIndex{2}, color::T = oneunit(T); opacity::AbstractFloat = 1.0) where {T<:Colorant} = drawifinbounds!(img, Point(p), color, opacity=opacity)

function drawifinbounds!(img::AbstractArray{T,2}, y::Int, x::Int, color::T; opacity::AbstractFloat = 1.0) where {T<:Colorant}
    if checkbounds(Bool, img, y, x)
        _draw_pixel!(img, y, x, color, opacity=opacity)
    end
    img
end


function _draw_pixel!(img::AbstractArray{T,2}, y::Int, x::Int, color::T; opacity::AbstractFloat = 1.0) where {T<:Colorant}
    if opacity == 1.0
        img[y, x] = color
    else
        img[y, x] = color * opacity + img[y, x] * (1 - opacity)
    end
end
