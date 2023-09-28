# Rectangle methods

RectanglePoints(x1::Int, y1::Int, x2::Int, y2::Int)  = RectanglePoints(Point(x1, y1), Point(x2, y2))
RectanglePoints(p1::CartesianIndex{2}, p2::CartesianIndex{2}) = RectanglePoints(Point(p1[1], p1[2]), Point(p2[1], p2[2]))

draw!(img::AbstractArray{T, 2}, rectangle::RectanglePoints, color::T; opacity::AbstractFloat = 1.0) where {T<:Colorant} = draw!(img, Polygon(rectangle), color, opacity=opacity)

