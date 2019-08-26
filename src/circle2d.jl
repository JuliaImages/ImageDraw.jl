import LinearAlgebra: det

#CirclePointRadius methods

CirclePointRadius(x::Int, y::Int, ρ::T) where {T<:Real} = CirclePointRadius(Point(x,y), ρ)
CirclePointRadius(p::CartesianIndex{2}, ρ::T) where {T<:Real} = CirclePointRadius(Point(p), ρ)

draw!(img::AbstractArray{T, 2}, circle::CirclePointRadius, color::T; in_bounds::Bool=false, thickness::Integer=-1) where {T<:Colorant} =
    draw!(img, Ellipse(circle), color, in_bounds=in_bounds, thickness=thickness)

#CircleThreePoints methods

CircleThreePoints(x1::Int, y1::Int, x2::Int, y2::Int, x3::Int, y3::Int) =
    CircleThreePoints(Point(x1,y1), Point(x2,y2), Point(x3,y3))
CircleThreePoints(p1::CartesianIndex{2}, p2::CartesianIndex{2}, p3::CartesianIndex{2}) =
    CircleThreePoints(Point(p1), Point(p2), Point(p3))

function draw!(img::AbstractArray{T, 2}, circle::CircleThreePoints, color::T; in_bounds::Bool=false, thickness::Integer=-1) where T<:Colorant
    ind = axes(img)
    x1 = circle.p1.x; y1 = circle.p1.y
    x2 = circle.p2.x; y2 = circle.p2.y
    x3 = circle.p3.x; y3 = circle.p3.y
    D = det([[x1, x2, x3] [y1, y2, y3] [1, 1, 1]])
    ! isapprox(D, 0, rtol = 0, atol = maximum(abs, (x1, x2, x3)) * maximum(abs, (y1, y2, y3)) * eps(Float64)) || error("Points do not lie on unique circle")
    R = [[y2 - y3, x3 - x2] [y2 - y1, x1 - x2]] * [(x1^2 + y1^2)-(x2^2 + y2^2), (x2^2 + y2^2)-(x3^2 + y3^2)] / (2 * D)
    ρ = euclidean([x1, y1], R)
    (first(ind[2]) <= R[1] <= last(ind[2]) && first(ind[1]) <= R[2] <= last(ind[1])) || error("Center of circle is out of the bounds of image")
    ρ - 1 <= minimum(abs, [R[1] - first(ind[2]), R[1] - last(ind[2]), R[2] - first(ind[1]), R[2] - last(ind[1])]) || error("Circle is out of the bounds of image : Radius is too large")
    draw!(img, CirclePointRadius(Point(round(Int,R[1]), round(Int,R[2])), ρ), color, in_bounds=in_bounds, thickness=thickness)
end
