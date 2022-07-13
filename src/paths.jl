#Path methods

Path(v::AbstractVector{Tuple{Int, Int}}) = Path([Point(p...) for p in v])
Path(v::AbstractVector{CartesianIndex{2}}) = Path([Point(p) for p in v])

function draw!(img::AbstractArray{T, 2}, path::Path, color::T) where T<:Colorant
    vertices = [CartesianIndex(p.y, p.x) for p in path.vertices]
    for i in 1:length(vertices)-1
		draw!(img, LineSegment(vertices[i], vertices[i+1]), color)
    end
	img
end

#Polygon methods

Polygon(v::AbstractVector{Tuple{Int, Int}}; fill::Bool = false) = Polygon([Point(p...) for p in v]; fill = fill)
Polygon(v::AbstractVector{CartesianIndex{2}}; fill::Bool = false) = Polygon([Point(p) for p in v]; fill = fill)
Polygon(rectangle::RectanglePoints; fill::Bool = false) = Polygon([rectangle.p1, Point(rectangle.p2.x, rectangle.p1.y), rectangle.p2, Point(rectangle.p1.x, rectangle.p2.y)]; fill = fill)

function draw!(img::AbstractArray{T, 2}, polygon::Polygon, color::T) where T<:Colorant
    draw!(img, Path(polygon.vertices), color)
    draw!(img, LineSegment(first(polygon.vertices), last(polygon.vertices)), color)

    if polygon.fill
        polygonscanfill!(img, polygon, color)
    end

    img
end

function polygonscanfill!(img::AbstractArray{T, 2}, polygon::Polygon, color::T) where T <: Colorant
    image_height, image_width = size(img)
    vertices = polygon.vertices

    vertices_y = map((v) -> v.y, vertices)
    scan_range = clamp(floor(Int, minimum(vertices_y)), 1, image_height):clamp(ceil(Int, maximum(vertices_y)), 1, image_height)

    vertices_shifted = push!(vertices[begin + 1:end], vertices[begin])
    intersections_x = Vector{Int}()

    for y in scan_range
        for (vertex_a, vertex_b) in zip(vertices, vertices_shifted)
            if vertex_a.y < y && vertex_b.y >= y || vertex_b.y < y && vertex_a.y >= y
                push!(intersections_x, round(Int, vertex_a.x + (y - vertex_a.y) / (vertex_b.y - vertex_a.y) * (vertex_b.x - vertex_a.x)))
            end
        end

        sort!(intersections_x)

        for i in 1:2:length(intersections_x)
            x1, x2 = intersections_x[i], intersections_x[i + 1]

            if !(x2 < 1 || x1 > image_width)
                x1, x2 = clamp(x1, 1, image_width), clamp(x2, 1, image_width)

                img[y, x1:x2] .= color
            end
        end

        empty!(intersections_x)
    end

    img
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
