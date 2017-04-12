"""
Type representing any object drawable on image
"""
abstract Drawable

"""
    p = Point(x,y)
    p = Point(c)

A `Drawable` point on the image
"""
immutable Point <: Drawable
    x::Int
    y::Int
end

abstract Line <: Drawable
abstract Circle <: Drawable


"""
    line = LineTwoPoints(p1, p2)

A `Drawable` infinite length line passing through the two points
`p1` and `p2`.
"""
immutable LineTwoPoints <: Line
    p1::Point
    p2::Point
end

"""
    line = LineNormal(ρ, θ)

A `Drawable` infinte length line having perpendicular length `ρ` from
origin and angle `θ` between the perpendicular and x-axis
"""
immutable LineNormal <: Line
    ρ::Real
    θ::Real
end

"""
    circle = CircleThreePoints(p1, p2, p3)

A `Drawable` circle passing through points `p1`, `p2` and `p3`
"""
immutable CircleThreePoints <: Circle
    p1::Point
    p2::Point
    p3::Point
end

"""
    circle = CirclePointRadius(p, ρ)

A `Drawable` circle having center `p` and radius `ρ`
"""
immutable CirclePointRadius <: Circle
    center::Point
    ρ::Real
end

"""
    ls = LineSegment(p1, p2)

A `Drawable` finite length line between `p1` and `p2`
"""
immutable LineSegment <: Drawable
    p1::Point
    p2::Point
end

"""
    path = Path([point])

A `Drawable` sequence of line segments
"""
immutable Path <: Drawable
    vertices::Vector{Point}
end

"""
    ellipse = Ellipse(center, ρx, ρy)

A `Drawable` ellipse with center `center` and parameters `ρx` and `ρy`
"""
immutable Ellipse <: Drawable
    center::Point
    ρx::Real
    ρy::Real
end

"""
    polygon = Polygon([vertex])

A `Drawable` polygon represented by a `Vector` of vertices
"""
immutable Polygon <: Drawable
    vertices::Vector{Point}
end

"""
    rp = RegularPolygon(center, side_count, side_length, θ)

A `Drawable` regular polygon.

#Arguments
* `center::Point` : the center of the polygon
* `side_count::Int` : number of sides of the polygon
* `side_length::Real` : length of each side
* `θ::Real` : orientation of the polygon w.r.t x-axis
"""
immutable RegularPolygon <: Drawable
    center::Point
    side_count::Int
    side_length::Real
    θ::Real
end

"""
    img = draw!(img, drawable, color)
    img = draw!(img, drawable)

Draws `drawable` on `img` using color `color` which
defaults to `one(eltype(img))`
"""
draw!{T<:Colorant}(img::AbstractArray{T,2}, object::Drawable) = draw!(img, object, one(T))


"""
    img = draw!(img, [drawable], [color])
    img = draw!(img, [drawable] ,color)
    img = draw!(img, [drawable])

Draws all objects in `[drawable]` in the given order on `img` using
corresponding colors from `[color]` which defaults to `one(eltype(img))`
"""
function draw!{T<:Colorant, U<:Drawable, V<:Colorant}(img::AbstractArray{T,2}, objects::Vector{U}, colors::Vector{V})
    colors = copy(colors)
    while length(colors) < length(objects)
        push!(colors, one(T))
    end
    map(objects, colors) do object, color
        draw!(img, object, color)
    end
    img
end

draw!{T<:Colorant, U<:Drawable}(img::AbstractArray{T,2}, objects::Vector{U}, color::T = one(T)) =
    draw!(img, objects, [color])

"""
    img_new = draw(img, drawable, color)
    img_new = draw(img, [drawable], [color])

Draws the `drawable` object on a copy of image `img` using color
`color`. Can also draw multiple `Drawable` objects when passed
as a `Vector{Drawable}` with corresponding colors in `[color]` 
"""
draw{T<:Colorant}(img::AbstractArray{T,2}, args...) = draw!(copy(img), args...)

Point(p::CartesianIndex) = Point(p[2], p[1])

function draw!{T<:Colorant}(img::AbstractArray{T,2}, point::Point, color::T)
    if CartesianIndex(point.y, point.x) ∈ CartesianRange(size(img))
        img[point.y, point.x] = color
    end
    img
end