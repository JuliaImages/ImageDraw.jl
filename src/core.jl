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
    circle = CirclePointRadius(center, ρ; thickness, fill)

A `Drawable` circle having center `center` and radius `ρ`
with keyword arguments `thickness` and `fill` for drawing hollow circle

# Arguments
- `thickness::Integer`: thickness of the circle 
- `fill::Bool`: argument to determine whether to fill the circle or not

# Examples
```
julia> using ImageDraw,TestImages,ImageView, ColorVectorSpace
julia> img = testimage("lighthouse")

julia> draw!(img, Ellipse(CirclePointRadius(350,200,100))) 
julia> draw!(img, Ellipse(CirclePointRadius(150,200,100; thickness = 70 , fill = false)))

julia> imshow(img)

```

"""
struct CirclePointRadius{T<:Real} <: Circle
    center::Point
    ρ::T
    thickness::Int
    fill::Bool
end

CirclePointRadius(center::Point, ρ::Real; thickness=1, fill=true) = CirclePointRadius(center, ρ, thickness, fill)

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
with keyword arguments `thickness` and `fill` for drawing hollow ellipse

"""
struct Ellipse{T<:Real, U<:Real} <: Drawable
    center::Point
    ρx::T
    ρy::U
    thickness::Int
    fill::Bool
end

Ellipse(center::Point, ρx::T, ρy::U; thickness::Int =  0, fill::Bool = true) where {T<:Real, U<:Real} = Ellipse(center, ρx, ρy, thickness, fill)

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
