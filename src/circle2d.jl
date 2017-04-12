#CirclePointRadius methods

CirclePointRadius(x::Int, y::Int, ρ::Real) = CirclePointRadius(Point(x,y), ρ)
CirclePointRadius(p::CartesianIndex{2}, ρ::Real) = CirclePointRadius(Point(p), ρ)

draw!{T<:Colorant}(img::AbstractArray{T, 2}, circle::CirclePointRadius, color::T) = draw!(img, Ellipse(circle), color)

#CircleThreePoints methods

CircleThreePoints(x1::Int, y1::Int, x2::Int, y2::Int, x3::Int, y3::Int) =
    CircleThreePoints(Point(x1,y1), Point(x2,y2), Point(x3,y3))
CircleThreePoints(p1::CartesianIndex{2}, p2::CartesianIndex{2}, p3::CartesianIndex{2}) =
    CircleThreePoints(Point(p1), Point(p2), Point(p3))

function draw!{T<:Colorant}(img::AbstractArray{T, 2}, circle::CircleThreePoints, color::T)
    x1 = circle.p1.x; y1 = circle.p1.y
    x2 = circle.p2.x; y2 = circle.p2.y
    x3 = circle.p3.x; y3 = circle.p3.y
    D = det([[x1, x2, x3] [y1, y2, y3] [1, 1, 1]])
    D != 0 || error("Points do not lie on unique circle")
    R = [[y2 - y3, x3 - x2] [y2 - y1, x1 - x2]] * [(x1^2 + y1^2)-(x2^2 + y2^2), (x2^2 + y2^2)-(x3^2 + y3^2)] / (2 * D)
    ρ = euclidean([x1, y1], R)
    draw!(img, CirclePointRadius(Point(R[1], R[2]), ρ), color)
end