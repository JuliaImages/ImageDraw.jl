"""
```
draw_polygon_perimeter!(img, vertices)
img2=draw_polygon_perimeter(img, vertices)
```
Draws the perimeter of the polygon formed by input vertices(Array of CartesianIndex).
"""



draw_polygon_perimeter{T<:Colorant}(img::AbstractArray{T, 2}, args...) = draw_polygon_perimeter!(copy(img), args...)

function draw_polygon_perimeter!{T<:Colorant}(img::AbstractArray{T, 2}, vertices::Array{CartesianIndex{2},1})

    f = CartesianIndex(map(r->first(r)-1, indices(img)))
    l = CartesianIndex(map(r->last(r), indices(img)))
    for vertex in vertices
        if min(f, vertex)!=f || max(l, vertex)!=l
            println(vertex)
            error("Polygon coordinates out of range.")
        end
    end

    for i in 1:length(vertices)-1
        line!(img, vertices[i], vertices[i+1])
    end
    line!(img, vertices[1], vertices[end])
end
