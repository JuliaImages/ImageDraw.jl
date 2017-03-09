"""
```
img_with_ellipse = ellipse(img, center, radiusy, radiusx)
img_with_ellipse = ellipse(img, center, color, radiusy, radiusx)
img_with_ellipse = ellipse(img, y, x, radiusy, radiusx)
img_with_ellipse = ellipse(img, y, x, color, radiusy, radiusx)
```
Draws a ellipse on the input image given the `center` as a `CartesianIndex{2}` or
as coordinates `(y, x)` using the specified `color`. If `color` is not specified,
`one(eltype(img))` is used.
"""
ellipse{T<:Colorant}(img::AbstractArray{T, 2}, args...) = ellipse!(copy(img), args...)

function ellipse!{T<:Colorant}(img::AbstractArray{T, 2}, center::CartesianIndex{2}, color::T, radiusy::Real, radiusx::Real)
    ellipse!(img, center[1], center[2], color, radiusy, radiusx)
end

function ellipse!{T<:Colorant}(img::AbstractArray{T, 2}, y::Int, x::Int, radiusy::Real, radiusx::Real)
	ellipse!(img, y, x, one(T), radiusy, radiusx)
end

function ellipse!{T<:Colorant}(img::AbstractArray{T, 2}, y::Int, x::Int, color::T, radiusy::Real, radiusx::Real)
	ys = Int[]
	xs = Int[]
	for i in y : y + radiusy
		for j in x : x + radiusx
			val = ((i - y) / radiusy) ^ 2 + ((j - x) / radiusx) ^ 2
			if val < 1
				push!(ys, i)
				push!(xs, j)
			end
		end
	end
	for (yi, xi) in zip(ys, xs)
		img[yi, xi] = color
		img[2 * y - yi, xi] = color
		img[yi, 2 * x - xi] = color
		img[2 * y - yi, 2 * x - xi] = color
	end
	img
end
