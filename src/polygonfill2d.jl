
"""
    (f::BoundaryFill)(res::AbstractArray{T,2}, verts::Vector{CartesianIndex{2}}, x::Int, y::Int, fill_value::T, boundary_value::T) where {T <: Colorant}

"""

function (f::BoundaryFill)(
    res::AbstractArray{T, 2},
    verts::Vector{CartesianIndex{N}},
    x::Int,
    y::Int,
    ) where {T <: Colorant, N}
    if checkbounds(Bool, res, y, x)
        if (res[y, x] != f.boundary_value && res[y, x] != f.fill_value)
            res[y, x] = f.fill_value
            f(res, verts, x + 1, y)
            f(res, verts, x, y + 1)
            f(res, verts, x - 1, y)
            f(res, verts, x, y - 1)
        end
    end
    res
end

"""
    (f::FloodFill)(res::AbstractArray{T,2}, verts::Vector{CartesianIndex{2}}, x::Int, y::Int, fill_value::T, boundary_value::T) where {T <: Colorant}

"""

function (f::FloodFill)(
    res::AbstractArray{T, 2},
    verts::Vector{CartesianIndex{N}},
    x::Int,
    y::Int,
    ) where {T<:Colorant, N}
    if (res[y, x] != f.current_value || res[y, x] == f.fill_value) return res end
    if checkbounds(Bool, res, y, x) res[y, x] = f.fill_value end
    f(res, verts, x + 1, y)
    f(res, verts, x - 1, y)
    f(res, verts, x, y + 1)
    f(res, verts, x, y - 1)
    res
end

"""
    draw!(img::AbstractArray{T,2}, verts::Vector{CartesianIndex{2}}, f::AbstractPolyFillAlgorithm; closed::Bool)

Draw on `img` using algorithm `f`.

# Output

When `img` is specified, changes are made on `img` and returned.

# Example

Just simply pass an algorithm with parameters, with image and vertices of polygon

```julia
using ImageDraw

img = zeros(RGB, 7, 7)
expected = copy(img)
expected[2:6, 2:6] .= RGB{N0f8}(1)

verts = [CartesianIndex(2, 2), CartesianIndex(2, 6), CartesianIndex(6, 6), CartesianIndex(6, 2), CartesianIndex(2,2)]

draw!(img, verts, BoundaryFill(4, 4; fill_value = RGB(1), boundary_value = RGB(1)); closed = true)
```
"""

function draw!(
    img::AbstractArray{<:Colorant,N},
    verts::Vector{CartesianIndex{N}},
    f::AbstractPolyFillAlgorithm;
    closed::Bool = false,
    ) where N

    # Boundscheck for verts
    @boundscheck map(x -> (checkbounds(Bool, img, x[1], x[2]) ? nothing : throw(DomainError(x, "Vertice $x outside the image array domain"))), verts)
    # Boundscheck for seed point
    @boundscheck checkbounds(img, f.x, f.y)
    
    if (closed == true)
        for i = 1:length(verts)-1
            draw!(img, LineSegment(verts[i], verts[i+1]), f.fill_value)
        end
    end
    f(img, verts, f.x, f.y)
end



"""
    draw(img::AbstractArray{T,2}, verts::Vector{CartesianIndex{2}}, f::AbstractPolyFillAlgorithm; closed::Bool)

Draw on `img` using algorithm `f`.

# Output

When `img` is specified, a copy of `img` is made and changes are made on it and returned.

# Example

Just simply pass an algorithm with parameters, with image and vertices of polygon

```julia
using ImageDraw

img = zeros(RGB, 7, 7)
expected = copy(img)
expected[2:6, 2:6] .= RGB{N0f8}(1)

verts = [CartesianIndex(2, 2), CartesianIndex(2, 6), CartesianIndex(6, 6), CartesianIndex(6, 2), CartesianIndex(2,2)]

res = draw(img, verts, BoundaryFill(4, 4; fill_value = RGB(1), boundary_value = RGB(1)); closed = true)
```
"""
function draw(
    img::AbstractArray{<:Colorant,N},
    verts::Vector{CartesianIndex{N}},
    f::AbstractPolyFillAlgorithm;
    kwargs...
    ) where N
    draw!(copy(img), verts, f; kwargs...)
end