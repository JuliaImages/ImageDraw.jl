
#Function to return valid intersections of lines with image boundary

function get_valid_intersections{T<:Real, U<:Real}(intersections::Vector{Tuple{T,U}}, indsx::AbstractUnitRange, indsy::AbstractUnitRange)
    valid_intersections = Vector{Tuple{T,U}}(0)
    for intersection in intersections
        if first(indsx) <= intersection[1] <= last(indsx) && first(indsy) <= intersection[2] <= last(indsy)
            push!(valid_intersections,intersection)
        end
    end
    valid_intersections
end

# LineTwoPoints methods

LineTwoPoints(x0::Int, y0::Int, x1::Int, y1::Int) = LineTwoPoints(Point(x0, y0), Point(x1,y1))
LineTwoPoints(p1::CartesianIndex{2}, p2::CartesianIndex{2}) = LineTwoPoints(Point(p1), Point(p2))

draw!{T<:Colorant}(img::AbstractArray{T,2}, line::LineTwoPoints, method::Function = bresenham) =
    draw!(img, line, one(T), method)

function draw!{T<:Colorant}(img::AbstractArray{T,2}, line::LineTwoPoints, color::T, method::Function = bresenham)
    indsy, indsx = indices(img)
    x1 = line.p1.x; y1 = line.p1.y
    x2 = line.p2.x; y2 = line.p2.y
    m = (y2 - y1) / (x2 - x1)
    intersections_x = [(x, y1 + m*(x-x1)) for x in (first(indsx), last(indsx))]
    intersections_y = [(x1 + (y-y1)/m, y) for y in (first(indsy), last(indsy))]
    valid_intersections = get_valid_intersections(vcat(intersections_x, intersections_y), indsx, indsy)
    if length(valid_intersections) > 0
        method(img, round(Int,valid_intersections[1][2]), round(Int,valid_intersections[1][1]), round(Int,valid_intersections[2][2]), round(Int,valid_intersections[2][1]), color)
    else
        img
    end
end


# LineNormal methods

LineNormal{T<:Real, U<:Real}(τ::Tuple{T,U}) = LineNormal(τ...)

draw!{T<:Colorant}(img::AbstractArray{T,2}, line::LineNormal, method::Function = bresenham) =
    draw!(img, line, one(T), method)

function draw!{T<:Colorant}(img::AbstractArray{T, 2}, line::LineNormal, color::T, method::Function = bresenham)
    indsy, indsx = indices(img)
    cosθ = cos(line.θ)
    sinθ = sin(line.θ)
    intersections_x = [(x, (line.ρ - x*cosθ)/sinθ) for x in (first(indsx), last(indsx))]
    intersections_y = [((line.ρ - y*sinθ)/cosθ, y) for y in (first(indsy), last(indsy))]
    valid_intersections = get_valid_intersections(vcat(intersections_x, intersections_y), indsx, indsy)
    if length(valid_intersections) > 0
        method(img, round(Int,valid_intersections[1][2]), round(Int,valid_intersections[1][1]), round(Int,valid_intersections[2][2]), round(Int,valid_intersections[2][1]), color)
    else
        img
    end
end

# LineSegment methods

LineSegment(x0::Int, y0::Int, x1::Int, y1::Int) = LineSegment(Point(x0, y0), Point(x1,y1))
LineSegment(p1::CartesianIndex, p2::CartesianIndex) = LineSegment(Point(p1), Point(p2))

draw!{T<:Colorant}(img::AbstractArray{T,2}, line::LineSegment, method::Function = bresenham) =
    draw!(img, line, one(T), method)

draw!{T<:Colorant}(img::AbstractArray{T,2}, line::LineSegment, color::T, method::Function = bresenham) =
    method(img, line.p1.y, line.p1.x, line.p2.y, line.p2.x, color)

# Methods to draw lines

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
    y, x
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
