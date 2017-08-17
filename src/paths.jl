#Path methods

Path(v::AbstractVector{Tuple{Int, Int}}) = Path([Point(p...) for p in v])
Path(v::AbstractVector{CartesianIndex{2}}) = Path([Point(p) for p in v])

function draw!(img::AbstractArray{T, 2}, path::Path, color::T) where T<:Colorant
    vertices = [CartesianIndex(p.y, p.x) for p in path.vertices]
    f = CartesianIndex(map(r->first(r)-1, indices(img)))
    l = CartesianIndex(map(r->last(r), indices(img)))

    if min(f,vertices[1])!=f || max(l,vertices[1])!=l
        println(vertices[1])
        error("Point coordinates out of range.")
    end

    for i in 1:length(vertices)-1
        if min(f,vertices[i+1])==f && max(l,vertices[i+1])==l
            draw!(img, LineSegment(vertices[i], vertices[i+1]), color)
        else
            println(vertices[i+1])
            error("Point coordinates out of range.")
        end
    end
end

#Polygon methods

Polygon(v::AbstractVector{Tuple{Int, Int}}) = Polygon([Point(p...) for p in v])
Polygon(v::AbstractVector{CartesianIndex{2}}) = Polygon([Point(p) for p in v])

function draw!(img::AbstractArray{T, 2}, polygon::Polygon, color::T) where T<:Colorant
    draw!(img, Path(polygon.vertices), color)
    draw!(img, LineSegment(first(polygon.vertices), last(polygon.vertices)), color)
end

#RegularPolygon methods

RegularPolygon(point::CartesianIndex{2}, side_count::Int, side_length::T, θ::U) where {T<:Real, U<:Real} =
    RegularPolygon(Point(point), side_count, side_length, θ)

function draw!(img::AbstractArray{T, 2}, rp::RegularPolygon, color::T) where T<:Colorant
    n = rp.side_count
    ρ = rp.side_length/(2*sin(π/n))
    polygon = Polygon([ Point(round(Int, rp.center.x + ρ*cos(rp.θ + 2π*k/n)), round(Int, rp.center.y + ρ*sin(rp.θ + 2π*k/n))) for k in 1:n ])
    draw!(img, polygon, color)
end
