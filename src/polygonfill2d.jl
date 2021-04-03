# abstract type AbstractPolyFillAlgorithm end

# """


# """
# struct boundaryfill{T<:Colorant} <: AbstractPolyFillAlgorithm
# 	x::Int
# 	y::Int
# 	fill_color::T
#     boundarycolor::T
#     function boundaryfill(x::Int,y::Int,fill_color::T,boundarycolor::T) where {T<:Colorant}
#         println("Test 1")
#         new{T}(x,y,fill_color,boundarycolor)
#     end
# end

# boundaryfill(;x::Int=0, y::Int=0, fill_color::Colorant=RGB(1), boundarycolor::Colorant=RGB(1)) = boundaryfill(x, y, fill_color, boundarycolor)

function boundaryfill(res::AbstractArray{T,2}, x::Int, y::Int, fill_color::T, boundary_color::T) where T<:Colorant
    if (res[y, x] != boundary_color && res[y, x] !=fill_color)
            if checkbounds(Bool, res, y, x) res[y, x] = fill_color end
             boundaryfill(res, x + 1, y, fill_color, boundary_color)
             boundaryfill(res, x, y + 1, fill_color, boundary_color)
             boundaryfill(res, x - 1, y, fill_color, boundary_color)
             boundaryfill(res, x, y - 1, fill_color, boundary_color)
    end        
end
	
"""
    Main boundary fill

"""

function (f::boundaryfill)(res::AbstractArray{T,2},verts::Vector,x::Int,y::Int,fill_color::T,boundarycolor::T) where {T<:Colorant}
	for i in 1:length(verts)-1
		draw!(res, LineSegment(verts[i], verts[i+1]), fill_color)
    end	
	boundaryfill(res,f.x, f.y, f.fill_color, f.boundarycolor)
   res
end



function draw(img::AbstractArray{T,2}, verts::Vector{CartesianIndex{2}}, f::AbstractPolyFillAlgorithm) where T <: Colorant
    f(img, verts, f.x, f.y, f.fill_color, f.boundarycolor)
end

"""
    Main API
    draw(img::AbstractArray{T,2}, verts::Vector{CartesianIndex{2}}, f::AbstractPolyFillAlgorithm)

"""
function draw(img::AbstractArray{T,2}, verts::Vector{CartesianIndex{2}}, f::AbstractPolyFillAlgorithm) where {T<:Colorant}
   res = copy(img)
   f(res, verts, f.x, f.y, f.fill_color, f.boundarycolor)
end