"""
    cross = Cross(c, arm::Int)
A `Drawable` cross passing through the point `c` with arms that are `arm` pixels long.
"""
Cross(c, arm::Int) = Cross(c, -arm:arm)

function draw!(img::AbstractArray{T, 2}, cross::Cross, color::T, thickness::Int=1) where T<:Colorant
    for Δx in cross.range
        drawwiththickness!(img, cross.c.y, cross.c.x + Δx, color, thickness)
    end
    for Δy in cross.range
        drawwiththickness!(img, cross.c.y + Δy, cross.c.x, color, thickness)
    end
    img
end
