"""
```
img_with_line = line(img, p1, p2, color, method)
img_with_line = line(img, y0, x0, y1, x1, color, method)
```

Draws a line on the input image given the points p1, p2 as CartesianIndex{2} with the 
given `color`. Lines are drawn using the `bresenham` method by default. If anti-aliasing
is required, the `xiaolin_wu` can be used.
"""
line{T<:Colorant}(img::AbstractArray{T, 2}, p1::CartesianIndex{2}, p2::CartesianIndex{2}) = line(img, p1[1], p1[2], p2[1], p2[2], zero(T))
line{T<:Colorant}(img::AbstractArray{T, 2}, p1::CartesianIndex{2}, p2::CartesianIndex{2}, color::T) = line(img, p1[1], p1[2], p2[1], p2[2], color)

function line{T}(img::AbstractArray{T, 2}, y0::Int, x0::Int, y1::Int, x1::Int, color::T, method::Function = bresenham)
		
end

function bresenham()
	
end

function xiaolin_wu()
	
end