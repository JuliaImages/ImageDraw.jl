"""
```
img_with_line = line(img, p1, p2, color, method)
img_with_line = line(img, y0, x0, y1, x1, color, method)
```

Draws a line on the input image given the points p1, p2 as CartesianIndex{2} with the
given `color`. Lines are drawn using the `bresenham` method by default. If anti-aliasing
is required, the `xiaolin_wu` can be used.
"""
line{T<:Colorant}(img::AbstractArray{T, 2}, args...) = line!(copy(img), args...)

function line!{T<:Colorant}(img::AbstractArray{T, 2}, p1::CartesianIndex{2}, p2::CartesianIndex{2}, method::Function = bresenham)
    line!(img, p1[1], p1[2], p2[1], p2[2], one(T), method)
end

function line!{T<:Colorant}(img::AbstractArray{T, 2}, p1::CartesianIndex{2}, p2::CartesianIndex{2}, color::T, method::Function = bresenham)
    line!(img, p1[1], p1[2], p2[1], p2[2], color, method)
end

line!{T<:Colorant}(img::AbstractArray{T, 2}, y0::Int, x0::Int, y1::Int, x1::Int, method::Function = bresenham) = line!(img, y0, x0, y1, x1, one(T), method)
line!{T<:Colorant}(img::AbstractArray{T, 2}, y0::Int, x0::Int, y1::Int, x1::Int, color::T, method::Function = bresenham) = method(img, y0, x0, y1, x1, color)

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

"""
```
img_with_line = line_normal(img, τ, color, method)
img_with_line = line_normal(img, ρ, θ, color, method)
```

Draws a line on the input image given tuple `τ` of the form (ρ,θ) for the normal form of line:
    x*cos(θ) + y*sin(θ) = ρ
with the given `color`. Lines are drawn using the `bresenham` method by default. If anti-aliasing
is required, the `xiaolin_wu` can be used.
"""
line_normal{T<:Colorant}(img::AbstractArray{T, 2}, args...) = line_normal!(copy(img), args...)

line_normal!{T<:Colorant}(img::AbstractArray{T, 2}, τ::Tuple{Number,Number}, method::Function = bresenham) = 
    line_normal!(img, τ[1], τ[2], one(T), method)

line_normal!{T<:Colorant}(img::AbstractArray{T, 2}, τ::Tuple{Number,Number}, color::T, method::Function = bresenham) = 
    line_normal!(img, τ[1], τ[2], color, method)

line_normal!{T<:Colorant}(img::AbstractArray{T, 2}, ρ::Number, θ::Number, method::Function = bresenham) =
    line_normal!(img, ρ, θ, one(T), method)

function line_normal!{T<:Colorant}(img::AbstractArray{T, 2}, ρ::Number, θ::Number, color::T, method::Function = bresenham)
    h,w = size(img)
    ρ -= 1; h -= 1; w -= 1
    t = Vector{Number}(4)
    cosθ = cos(θ)
    sinθ = sin(θ)
    t[1] = ( ρ * cosθ    )/ sinθ
    t[2] = (-ρ * sinθ    )/ cosθ
    t[3] = ( ρ * cosθ - w)/ sinθ
    t[4] = (-ρ * sinθ + h)/ cosθ
    hasInf = false
    for i in 1:4
        if ! isfinite(t[i])
            if ! hasInf
                t[i] = Inf
                hasInf = true
            else
                t[i] = -Inf
            end
        end
    end
    sort!(t)
    method(img, round(Integer, ρ*sinθ + t[2]*cosθ + 1), round(Integer, ρ*cosθ - t[2]*sinθ + 1), round(Integer, ρ*sinθ + t[3]*cosθ + 1), round(Integer, ρ*cosθ - t[3]*sinθ + 1), color)
end