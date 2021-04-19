
"""
    (f::BoundaryFill)(res::AbstractArray{T,2}, verts::Vector{CartesianIndex{2}}, x::Int, y::Int, fill_color::T, boundary_color::T) where {T <: Colorant}

"""

function (f::BoundaryFill)(res::AbstractArray{T,2}, verts::Vector{CartesianIndex{2}}, x::Int, y::Int, fill_color::T, boundary_color::T) where {T <: Colorant}
    if (res[y, x] != f.boundary_color && res[y, x] != f.fill_color)
        if checkbounds(Bool, res, y, x) res[y, x] = f.fill_color end
        f(res, verts,  x + 1, y, fill_color, boundary_color)
        f(res, verts,  x, y + 1, fill_color, boundary_color)
        f(res, verts,  x - 1, y, fill_color, boundary_color)
        f(res, verts,  x, y - 1, fill_color, boundary_color)
    end       
    res
end

"""
draw!(img::AbstractArray{T,2}, verts::Vector{CartesianIndex{2}}, f::AbstractPolyFillAlgorithm; connectverts)

Draw on `img` using algorithm `f`.

# Output

When `img` is specified, a copy of `img` is made and changes are made on it and returned.

# Example

Just simply pass an algorithm with parameters,with image and vertices of polygon

```julia
using ImageDraw

img = zeros(RGB, 7, 7)
expected = copy(img)
expected[2:6, 2:6] .= RGB{N0f8}(1)
verts = [CartesianIndex(2, 2), CartesianIndex(2, 6), CartesianIndex(6, 6), CartesianIndex(6, 2), CartesianIndex(2,2)]

res = draw!(img, verts, BoundaryFill(x=4, y=4, fill_color=RGB(1), boundary_color=RGB(1)); connectverts=true)
```
"""
function draw!(img::AbstractArray{T,2}, verts::Vector{CartesianIndex{2}}, f::AbstractPolyFillAlgorithm;connectverts::Bool = true) where T <: Colorant
    res = copy(img)
    if (connectverts == true)
        for i in 1:length(verts) - 1
            draw!(res, LineSegment(verts[i], verts[i + 1]), f.fill_color)
        end	
    end
    f(res, verts, f.x, f.y, f.fill_color, f.boundary_color)
end


"""
    draw(img::AbstractArray{T,2}, verts::Vector{CartesianIndex{2}}, f::AbstractPolyFillAlgorithm; connectverts)

Draw on `img` using algorithm `f`.

# Output

When `img` is specified, a copy of `img` is made and changes are made on it and returned.

# Example

Just simply pass an algorithm with parameters,with image and vertices of polygon

```julia
using ImageDraw

img = zeros(RGB, 7, 7)
expected = copy(img)
expected[2:6, 2:6] .= RGB{N0f8}(1)
verts = [CartesianIndex(2, 2), CartesianIndex(2, 6), CartesianIndex(6, 6), CartesianIndex(6, 2), CartesianIndex(2,2)]

draw(img, verts, BoundaryFill(x=4, y=4, fill_color=RGB(1), boundary_color=RGB(1)); connectverts=true)
```
"""
function draw(img::AbstractArray{T,2}, verts::Vector{CartesianIndex{2}}, f::AbstractPolyFillAlgorithm; connectverts::Bool=true) where {T <: Colorant}
    res = copy(img)
    if (connectverts == true)
        for i in 1:length(verts) - 1
            draw!(res, LineSegment(verts[i], verts[i + 1]), f.boundary_color)
        end	
    end
    f(res, verts, f.x, f.y, f.fill_color, f.boundary_color)
end