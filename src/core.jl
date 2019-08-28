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

abstract type AbstractPath <: Drawable end
abstract type AbstractLine <: Drawable end
abstract type AbstractShape <: Drawable end


abstract type AbstractPolygon <: AbstractShape end
abstract type AbstractEllipse <: AbstractShape end
abstract type AbstractCircle <: AbstractEllipse end


"""
    line = LineTwoPoints(p1, p2)

A `Drawable` infinite length line passing through the two points
`p1` and `p2`.
"""
struct LineTwoPoints <: AbstractLine
    p1::Point
    p2::Point
end

"""
    line = LineNormal(ρ, θ)

A `Drawable` infinte length line having perpendicular length `ρ` from
origin and angle `θ` between the perpendicular and x-axis

"""
struct LineNormal{T<:Real, U<:Real} <: AbstractLine
    ρ::T
    θ::U
end

"""
    circle = CircleThreePoints(p1, p2, p3)

A `Drawable` circle passing through points `p1`, `p2` and `p3`
"""
struct CircleThreePoints <: AbstractCircle
    p1::Point
    p2::Point
    p3::Point
end

"""
    circle = CirclePointRadius(center, ρ)

A `Drawable` circle having center `center` and radius `ρ`
"""
struct CirclePointRadius{T<:Real} <: AbstractCircle
    center::Point
    ρ::T
end

"""
    ls = LineSegment(p1, p2)

A `Drawable` finite length line between `p1` and `p2`
"""
struct LineSegment <: AbstractLine
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
struct Path <: AbstractPath
    vertices::Vector{Point}
end

"""
    ellipse = Ellipse(center, ρx, ρy)

A `Drawable` ellipse with center `center` and parameters `ρx` and `ρy`

"""
struct Ellipse{T<:Real, U<:Real} <: AbstractEllipse
    center::Point
    ρx::T
    ρy::U
end

"""
    polygon = Polygon([vertex])

A `Drawable` polygon i.e. a closed path created by joining the
consecutive points in `[vertex]` along with the first and last point.
!!! note
    This will create a closed path. For a non-closed path, see `Path`
"""
struct Polygon <: AbstractPolygon
    vertices::Vector{Point}
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
struct RegularPolygon{T<:Real, U<:Real} <: AbstractPolygon
    center::Point
    side_count::Int
    side_length::T
    θ::U
end

"""
    cross = Cross(c, range::UnitRange{Int})
A `Drawable` cross passing through the point `c` with arms ranging across `range`.
"""
struct Cross <: AbstractPath
    c::Point
    range::UnitRange{Int}
end

"""
    img_map = ImageMap(img, x, y)

Overlays an image on an larger image. (x, y) is the center for placing the image
"""
struct ImageMap <: Drawable
    image
    x
    y
end

"""
    img = draw!(img, drawable; in_bounds, thickness)

Draws `drawable` on `img` using color `color` which
defaults to `oneunit(eltype(img))`
"""
draw!(img::AbstractArray{T,2}, object::Drawable; in_bounds::Bool=false, thickness::Union{Integer, Nothing}=nothing) where {T<:Colorant} =
    draw!(img, object, oneunit(T), in_bounds=in_bounds, thickness=thickness)


"""
    img = draw!(img, [drawable] ,color; in_bounds, thickness)

Draws all objects in `[drawable]` in the given order on `img` using
corresponding colors from `color` which defaults to `oneunit(eltype(img))`.
color, in_bounds and thickness flags are expanded to length of objects.
"""
function draw!(img::AbstractArray{T, 2}, objects::AbstractVector{U}, color::T = oneunit(T); in_bounds::Bool=false, thickness::Union{Integer, Nothing}=nothing) where {T<:Colorant, U<:Drawable}
    draw!(img, objects, repeat([color], length(objects));
          in_bounds = repeat([in_bounds], length(objects)),
          thickness = repeat([thickness], length(objects)))
end


"""
    draw!(img, [drawable], [colors]; [bool], [Union{Integer,Nothing}])

Draws objects with given colors, in_bounds flags, and thickness flags.
Length of objects, colors, in_bounds flags, thickness flags, all need to be of equal length
"""
function draw!(img::AbstractArray{T,2}, objects::AbstractVector{U}, colors::AbstractVector{V}; in_bounds::Union{AbstractVector{Bool},Nothing}=nothing, thickness::Union{AbstractVector{<:Union{Integer, Nothing}},Nothing}=nothing) where {T<:Colorant, U<:Drawable, V<:Colorant}
    length(colors) == length(objects) || throw("The number of colors and objects should be equal.")
    isnothing(in_bounds) || length(in_bounds) == length(objects) || throw("The number of in_bounds vars and objects should be equal")
    isnothing(thickness) || length(thickness) == length(objects) || throw("The number of thicknesses and objects should be equal")
    isnothing(in_bounds) && isnothing(thickness) ? foreach((object, color) -> draw!(img, object, color), objects, colors) :
                                                   foreach((object, color, in_b, thick) -> draw!(img, object, color, in_bounds=in_b, thickness=thick), objects, colors, in_bounds, thickness)
    img
end


"""
    img_new = draw(img, drawable, color)
    img_new = draw(img, [drawable], [color])

Draws the `drawable` object on a copy of image `img` using color
`color`. Can also draw multiple `Drawable` objects when passed
as a `AbstractVector{Drawable}` with corresponding colors in `[color]`
"""
draw(img::AbstractArray{T,2}, args...; in_bounds::Bool=false, thickness::Union{Integer, Nothing}=nothing) where {T<:Colorant} =
    draw!(copy(img), args...; in_bounds=in_bounds, thickness=thickness)

draw(img::AbstractArray{T,2}, args...) where {T<:Colorant} = draw!(copy(img), args...)

Point(τ::Tuple{Int, Int}) = Point(τ...)
Point(p::CartesianIndex) = Point(p[2], p[1])


draw!(img::AbstractArray{T,2}, p::Point, color::T = oneunit(T); in_bounds::Bool=false, thickness::Union{Integer, Nothing}=nothing) where {T<:Colorant} =
    draw!(img, p.y, p.x, color, in_bounds=in_bounds, thickness=thickness)
draw!(img::AbstractArray{T,2}, p::CartesianIndex{2}, color::T = oneunit(T); in_bounds::Bool=false, thickness::Union{Integer, Nothing}=nothing) where {T<:Colorant} =
    draw!(img, Point(p), color, in_bounds=in_bounds, thickness=thickness)

function draw!(img::AbstractArray{T,2}, y::Integer, x::Integer, color::T; in_bounds::Bool=false, thickness::Union{Integer, Nothing}=nothing) where T<:Colorant
    if !isnothing(thickness)
        drawwiththickness!(img, y, x, color, in_bounds, thickness) # recursively call drawifinbounds!
    else
        in_bounds ? img[y, x] = color : drawifinbounds!(img, y, x, color)
    end
    img
end

"""
    img_new = drawifinbounds!(img, y, x, color; in_bounds, thickness)
    img_new = drawifinbounds!(img, point, color; in_bounds, thickness)
    img_new = drawifinbounds!(img, cartesianIndex, color; in_bounds, thickness)

Draws a single point after checkbounds() for coordinate in the image.
Color Defaults to oneunit(T)

"""

drawifinbounds!(img::AbstractArray{T,2}, p::Point, color::T = oneunit(T)) where {T<:Colorant} = drawifinbounds!(img, p.y, p.x, color)
drawifinbounds!(img::AbstractArray{T,2}, p::CartesianIndex{2}, color::T = oneunit(T)) where {T<:Colorant} = drawifinbounds!(img, Point(p), color)

function drawifinbounds!(img::AbstractArray{T,2}, y::Int, x::Int, color::T) where {T<:Colorant}
    checkbounds(Bool, img, y, x) && (img[y, x] = color)
    img
end

"""
    img_new = drawwiththickness!(img, y, x, color; in_bounds, thickness)
    img_new = drawwiththickness!(img, point, color; in_bounds, thickness)
    img_new = drawwiththickness!(img, cartesianIndex, color; in_bounds, thickness)

Draws pixel with given thickness
Color Defaults to oneunit(T)
Thickness defaults to 1

"""

drawwiththickness!(img::AbstractArray{T,2}, p::Point, color::T, in_bounds::Bool, thickness::Integer) where {T<:Colorant} = drawwiththickness!(img, p.y, p.x, color, in_bounds, thickness)
drawwiththickness!(img::AbstractArray{T,2}, p::CartesianIndex{2}, color::T, in_bounds::Bool, thickness::Integer) where {T<:Colorant} = drawifinbounds!(img, Point(p), color, in_bounds, thickness)

function drawwiththickness!(img::AbstractArray{T,2}, y0::Int, x0::Int, color::T, in_bounds::Bool, thickness::Integer) where {T<:Colorant}
    m = ceil(Int, thickness/2) - 1
    n = thickness % 2 == 0 ? m+1 : m
    pixels = [i for i = -m:n]

    for x in pixels, y in pixels
        draw!(img, y0+y, x0+x, color, in_bounds=in_bounds)
    end
    img
end
