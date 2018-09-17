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

abstract type Line <: Drawable end
abstract type Circle <: Drawable end


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
    circle = CirclePointRadius(center, ρ)

A `Drawable` circle having center `center` and radius `ρ`
"""
struct CirclePointRadius{T<:Real} <: Circle
    center::Point
    ρ::T
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

"""
    ellipse = Ellipse(center, ρx, ρy)

A `Drawable` ellipse with center `center` and parameters `ρx` and `ρy`

"""
struct Ellipse{T<:Real, U<:Real} <: Drawable
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
struct Polygon <: Drawable
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
struct RegularPolygon{T<:Real, U<:Real} <: Drawable
    center::Point
    side_count::Int
    side_length::T
    θ::U
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
    if checkbounds(Bool, img, point.y, point.x)
        img[point.y, point.x] = color
    end
    img
end
