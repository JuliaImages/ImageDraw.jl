#Path methods

function draw!(img::AbstractArray{T, 2}, path::Path, color::T; opacity::AbstractFloat = 1.0, skip_first_pixel::Bool = false) where T<:Colorant
    vertices = [CartesianIndex(p.y, p.x) for p in path.vertices]
    for i in 1:length(vertices)-1
        edge_start = vertices[i]
        edge_end = vertices[i+1]
        if edge_start == edge_end
            continue
        end
		draw!(img, LineSegment(edge_start, edge_end), color, opacity=opacity, skip_first_pixel=skip_first_pixel)
        skip_first_pixel = true
    end
	img
end


function foreach_point_within_border(f, img::AbstractArray{T, 2}, border_marker::T, start_x::Int, start_y::Int) where T
    stack = [(start_y, start_x)]
    marked = Set{Tuple{Int, Int}}()
    while !isempty(stack)
        y, x = pop!(stack)
        if checkbounds(Bool, img, y, x)
            if (img[y, x] != border_marker && (y, x) ∉ marked)
                push!(marked, (y, x))
                f(x, y)
                push!(stack, (y + 1, x))
                push!(stack, (y, x + 1))
                push!(stack, (y - 1, x))
                push!(stack, (y, x - 1))
            end
        end
    end
end


function is_inside_polygon(x::Int, y::Int, vertices::AbstractVector{Point})
    vertices = [[p.y, p.x] for p in vertices]
    winding_number = 0
    for (start_point, end_point) in zip(vertices, circshift(vertices, -1))
        max_x = maximum([start_point[2], end_point[2]])
        min_y, max_y = extrema([start_point[1], end_point[1]])
        if x < max_x && min_y < y < max_y
            winding_number += sign(end_point[1] - start_point[1])
        end
    end
    winding_number != 0
end


function fill_polygon!(img::AbstractArray{T, 2}, polygon::Polygon, fill_color::T, fill_opacity::AbstractFloat) where T<:Colorant
    fill_buffer = zeros(Gray{Bool}, size(img))
    border_marker = Gray{Bool}(true)
    draw!(fill_buffer, polygon, border_marker)

    is_suitable_seed(index) = is_inside_polygon(index[2], index[1], polygon.vertices) && !Bool(fill_buffer[index])
    inside_point = findfirst(is_suitable_seed, CartesianIndices(img))
    if inside_point === nothing
        return img
    end
    inside_point_y, inside_point_x = Tuple(inside_point)
    foreach_point_within_border(fill_buffer, border_marker, inside_point_x, inside_point_y) do x, y
        draw!(img, Point(x, y), fill_color, opacity=fill_opacity)
    end
    img
end


function draw!(img::AbstractArray{T, 2}, polygon::Polygon, color::T; opacity::AbstractFloat = 1.0, kwargs...) where T<:Colorant
    if :fill_color in keys(kwargs)
        fill_color = kwargs[:fill_color]
        fill_opacity = get(kwargs, :fill_opacity, opacity)
    else
        fill_color = color
        fill_opacity = get(kwargs, :fill_opacity, 0.0)
    end
    if fill_opacity > 0.0
        fill_polygon!(img, polygon, fill_color, fill_opacity)
    end
    vertices = [polygon.vertices; first(polygon.vertices)]
    draw!(img, Path(vertices), color, opacity=opacity, skip_first_pixel=true)
    img
end


#RegularPolygon methods

RegularPolygon(point::CartesianIndex{2}, side_count::Int, side_length::T, θ::U) where {T<:Real, U<:Real} =
    RegularPolygon(Point(point), side_count, side_length, θ)

function draw!(img::AbstractArray{T, 2}, rp::RegularPolygon, color::T; opacity::AbstractFloat = 1.0) where T<:Colorant
    n = rp.side_count
    ρ = rp.side_length/(2*sin(π/n))
    polygon = Polygon([Point(round(Int, rp.center.x + ρ*cos(rp.θ + 2π*k/n)), round(Int, rp.center.y + ρ*sin(rp.θ + 2π*k/n))) for k in 1:n ])
    draw!(img, polygon, color, opacity=opacity)
end
