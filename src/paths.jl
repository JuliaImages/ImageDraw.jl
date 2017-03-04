"""

Draws lines segments connecting input points.
Parameters:
img: 2d array
vertices: coordinates of points as array of CartesianIndex
color (optional): color of line segments
closed (keyword): whether to connect first and last points

In case a point is out-of-bounds, it throws an error after drawing the line segments till that point.
"""

path{T<:Colorant}(img::AbstractArray{T, 2}, vertices::Array{CartesianIndex{2},1}, color::T=one(T); closed::Bool=true) = path!(copy(img),vertices,color,closed=closed)

function path!{T<:Colorant}(img::AbstractArray{T, 2}, vertices::Array{CartesianIndex{2},1}, color::T=one(T); closed::Bool=true)
    f = CartesianIndex(map(r->first(r)-1, indices(img)))
    l = CartesianIndex(map(r->last(r), indices(img)))

    if min(f,vertices[1])!=f || max(l,vertices[1])!=l
        println(vertices[1])
        error("Point coordinates out of range.")
    end

    for i in 1:length(vertices)-1
        if min(f,vertices[i+1])==f && max(l,vertices[i+1])==l
            line!(img, vertices[i], vertices[i+1], color)
        else
            println(vertices[i+1])
            error("Point coordinates out of range.")
        end
    end

    if closed==true
        line!(img, vertices[1], vertices[end], color)
    end
end