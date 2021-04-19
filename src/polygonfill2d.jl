
"""
Main boundary fill

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


# function draw!(img::AbstractArray{T,2}, verts::Array{CartesianIndex{2},1}, f::AbstractPolyFillAlgorithm;connectverts::Bool = true) where T <: Colorant
#     res = copy(img)
#     f(res, verts, f.x, f.y, f.fill_color, f.boundarycolor)
# end


"""
Main API
draw(img::AbstractArray{T,2}, verts::Vector{CartesianIndex{2}}, f::AbstractPolyFillAlgorithm)

"""
function draw(img::AbstractArray{T,2}, verts::Vector{CartesianIndex{2}}, f::AbstractPolyFillAlgorithm;connectverts::Bool=true) where {T <: Colorant}
    res = copy(img)
    if (connectverts == true)
        for i in 1:length(verts) - 1
            draw!(res, LineSegment(verts[i], verts[i + 1]), f.fill_color)
        end	
    end
    f(res, verts, f.x, f.y, f.fill_color, f.boundary_color)
end