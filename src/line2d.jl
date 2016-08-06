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

line!{T<:Colorant}(img::AbstractArray{T, 2}, p1::CartesianIndex{2}, p2::CartesianIndex{2}, color::T) = line!(img, p1[1], p1[2], p2[1], p2[2], color)
line!{T<:Colorant}(img::AbstractArray{T, 2}, y0::Int, x0::Int, y1::Int, x1::Int, method::Function = bresenham) = line!(img, y0, x0, y1, x1, one(T), method)
line!{T<:Colorant}(img::AbstractArray{T, 2}, y0::Int, x0::Int, y1::Int, x1::Int, color::T, method::Function = bresenham) = method(img, y0, x0, y1, x1, color)

function bresenham{T<:Colorant}(img::AbstractArray{T, 2}, y0::Int, x0::Int, y1::Int, x1::Int, color::T)
	dx = abs(x1 - x0)
	dy = abs(y1 - y0)
	sx = x0 < x1 ? 1 : -1
	sy = y0 < y1 ? 1 : -1
	x = x0 - 1
	y = y0 - 1
	offset = dx - dy
	while true
		img[y + 1, x + 1] = color
		(x != x1 - 1 || y != y1 - 1) || break
		if offset * 2 > -dy
			offset -= dy;
			x += sx;
		end
		if offset * 2 < dx
			offset += dx;
			y += sy;
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
    index = swapped ? CartesianIndex(ypxl0, xpxl0) : CartesianIndex(xpxl0, ypxl0)
    img[index] = T(rfpart(yend) * xgap)
    index = swapped ? CartesianIndex(ypxl0 + 1, xpxl0) : CartesianIndex(xpxl0, ypxl0 + 1)
    img[index] = T(fpart(yend) * xgap)
    intery = yend + gradient

    xend = round(Int, x1)
    yend = y1 + gradient * (xend - x1)
    xgap = fpart(x1 + 0.5)
    xpxl1 = xend
    ypxl1 = trunc(Int, yend)
    index = swapped ? CartesianIndex(ypxl1, xpxl1) : CartesianIndex(xpxl1, ypxl1)
    img[index] = T(rfpart(yend) * xgap)
    index = swapped ? CartesianIndex(ypxl1 + 1, xpxl1) : CartesianIndex(xpxl1, ypxl1 + 1)
    img[index] = T(fpart(yend) * xgap)
    
    for i in (xpxl0 + 1):(xpxl1 - 1)
	    index = swapped ? CartesianIndex(trunc(Int, intery), i) : CartesianIndex(i, trunc(Int, intery))
	    img[index] = T(rfpart(intery))
	    index = swapped ? CartesianIndex(trunc(Int, intery) + 1, i) : CartesianIndex(i, trunc(Int, intery) + 1)
	    img[index] = T(fpart(intery))
        intery += gradient
    end
	img
end