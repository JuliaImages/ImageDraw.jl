"""
    cross = Cross(c, arm::Int, color; in_bounds, thickness))
A `Drawable` cross passing through the point `c` with arms that are `arm` pixels long.
"""
Cross(c, arm::Int) = Cross(c, -arm:arm)

function draw!(img::AbstractArray{T, 2}, cross::Cross, color::T; in_bounds::Bool=false, thickness::Union{Integer, Nothing}=nothing) where T<:Colorant
    for Δx in cross.range
        draw!(img, cross.c.y, cross.c.x + Δx, color, in_bounds=in_bounds, thickness=thickness)
    end
    for Δy in cross.range
        draw!(img, cross.c.y + Δy, cross.c.x, color, in_bounds=in_bounds, thickness=thickness)
    end
    img
end
