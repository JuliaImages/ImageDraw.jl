abstract Line

immutable LineTwoPoints <: Line
    y0::Number
    x0::Number
    y1::Number
    x1::Number
end

LineTwoPoints(p1::CartesianIndex{2}, p2::CartesianIndex{2}) = LineTwoPoints(p1[1],p1[2],p2[1],p2[2])

immutable LineNormal <: Line
    ρ::Number
    θ::Number
end

LineNormal(τ::Tuple{Number,Number}) = LineNormal(τ...)

"""
```
img_with_line = line(img, l, color, method)
img_with_line = line(img, LineTwoPoints(p1, p2), color, method)
img_with_line = line(img, LineTwoPoints(y0, x0, y1, x1), color, method)
img_with_line = line(img, LineNormal(ρ,θ), color, method)
```

Draws a line on the input image.
img     =   Image to draw lines on
l       =   A `Line` type object describing the line to be drawn.
            A line can be represented in "two-points form" using `LineTwoPoints(p1,p2)`
            where points p1, p2 are `CartesianIndex{2}`.
            It can also be represented in "two-points form" using `LineTwoPoints(y0,x0,y1,x1)`
            A line can also be represented in "normal form" using `LineNormal(ρ,θ)`
            where ρ = perpendicular distance of line and θ is angle from x-axis in radians.
color   =   Color of the line to be drawn
method  =   Lines are drawn using the `bresenham` method by default. If anti-aliasing
            is required, the `xiaolin_wu` can be used.

"""

#methods for LineTwoPoints parametrization

line{T<:Colorant}(img::AbstractArray{T, 2}, args...) = line!(copy(img), args...)

line!{T<:Colorant}(img::AbstractArray{T, 2}, p1::CartesianIndex{2}, p2::CartesianIndex{2}, method::Function = bresenham) =
    line!(img, LineTwoPoints(p1, p2), one(T), method)

line!{T<:Colorant}(img::AbstractArray{T, 2}, p1::CartesianIndex{2}, p2::CartesianIndex{2}, color::T, method::Function = bresenham) =
    line!(img, LineTwoPoints(p1, p2), color, method)

line!{T<:Colorant}(img::AbstractArray{T, 2}, y0::Int, x0::Int, y1::Int, x1::Int, method::Function = bresenham) = line!(img, y0, x0, y1, x1, one(T), method)
line!{T<:Colorant}(img::AbstractArray{T, 2}, y0::Int, x0::Int, y1::Int, x1::Int, color::T, method::Function = bresenham) = method(img, y0, x0, y1, x1, color)

line!{T<:Colorant}(img::AbstractArray{T, 2}, l::LineTwoPoints, method::Function = bresenham) = line!(img, l, one(T), method)
line!{T<:Colorant}(img::AbstractArray{T, 2}, l::LineTwoPoints, color::T, method::Function = bresenham) = method(img, l.y0, l.x0, l.y1, l.x1, color)

# methods for LineNormal parametrization

line!{T<:Colorant}(img::AbstractArray{T, 2}, l::LineNormal, method::Function = bresenham) = 
    line!(img, l, one(T), method)

function line!{T<:Colorant}(img::AbstractArray{T, 2}, l::LineNormal, color::T, method::Function = bresenham)
    indsy, indsx = indices(img)
    cosθ = cos(l.θ)
    sinθ = sin(l.θ)
    intersections_x = [(x, (l.ρ - x*cosθ)/sinθ) for x in (first(indsx), last(indsx))]
    intersections_y = [((l.ρ - y*sinθ)/cosθ, y) for y in (first(indsy), last(indsy))]
    valid_intersections = Vector{Tuple{Number,Number}}(0)
    for intersection in vcat(intersections_x, intersections_y)
        if 1 <= intersection[1] <= indsx.stop && 1 <= intersection[2] <= indsy.stop
            push!(valid_intersections,intersection)
        end
    end
    if length(valid_intersections) > 0
        method(img, round(Int,valid_intersections[1][2]), round(Int,valid_intersections[1][1]), round(Int,valid_intersections[2][2]), round(Int,valid_intersections[2][1]), color)
    else
        img
    end
end



function bresenham{T<:Colorant}(img::AbstractArray{T, 2}, y0::Int, x0::Int, y1::Int, x1::Int, color::T)
    dx = abs(x1 - x0)
    dy = abs(y1 - y0)

    sx = x0 < x1 ? 1 : -1
    sy = y0 < y1 ? 1 : -1;

    err = (dx > dy ? dx : -dy) / 2

    while true
        img[y0, x0] = color
        (x0 != x1 || y0 != y1) || break
        e2 = err
        if e2 > -dx
            err -= dy
            x0 += sx
        end
        if e2 < dy
            err += dx
            y0 += sy
        end
    end

    img
end

fpart{T}(pixel::T) = pixel - T(trunc(pixel))
rfpart{T}(pixel::T) = one(T) - fpart(pixel)

function swap(x, y)
    temp = y
    y = x
    x = temp
    x, y
end

function xiaolin_wu{T<:Gray}(img::AbstractArray{T, 2}, y0::Int, x0::Int, y1::Int, x1::Int, color::T)
    dx = x1 - x0
    dy = y1 - y0

    swapped=false
    if abs(dx) < abs(dy)
        x0, y0 = swap(x0, y0)
        x1, y1 = swap(x1, y1)
        dx, dy = swap(dx, dy)
        swapped=true
    end
    if x1 < x0
        x0, x1 = swap(x0, x1)
        y0, y1 = swap(y0, y1)
    end
    gradient = dy / dx

    xend = round(Int, x0)
    yend = y0 + gradient * (xend - x0)
    xgap = rfpart(x0 + 0.5)
    xpxl0 = xend
    ypxl0 = trunc(Int, yend)
    index = swapped ? CartesianIndex(xpxl0, ypxl0) : CartesianIndex(ypxl0, xpxl0)
    if checkbounds(Bool, img, index) img[index] = T(rfpart(yend) * xgap) end
    index = swapped ? CartesianIndex(xpxl0, ypxl0 + 1) : CartesianIndex(ypxl0 + 1, xpxl0)
    if checkbounds(Bool, img, index) img[index] = T(fpart(yend) * xgap) end
    intery = yend + gradient

    xend = round(Int, x1)
    yend = y1 + gradient * (xend - x1)
    xgap = fpart(x1 + 0.5)
    xpxl1 = xend
    ypxl1 = trunc(Int, yend)
    index = swapped ? CartesianIndex(xpxl1, ypxl1) : CartesianIndex(ypxl1, xpxl1)
    if checkbounds(Bool, img, index) img[index] = T(rfpart(yend) * xgap) end
    index = swapped ? CartesianIndex(xpxl1, ypxl1 + 1) : CartesianIndex(ypxl1 + 1, xpxl1)
    if checkbounds(Bool, img, index) img[index] = T(fpart(yend) * xgap) end

    for i in (xpxl0 + 1):(xpxl1 - 1)
        index = swapped ? CartesianIndex(i, trunc(Int, intery)) : CartesianIndex(trunc(Int, intery), i)
        if checkbounds(Bool, img, index) img[index] = T(rfpart(intery)) end
        index = swapped ? CartesianIndex(i, trunc(Int, intery) + 1) : CartesianIndex(trunc(Int, intery) + 1, i)
        if checkbounds(Bool, img, index) img[index] = T(fpart(intery)) end
        intery += gradient
    end
    img
end
