"""
```
img_with_circle = circle(img, center, radiusy, radiusx)
img_with_circle = circle(img, center, color, radiusy, radiusx)
img_with_circle = circle(img, y, x, radiusy, radiusx)
img_with_circle = circle(img, y, x, color, radiusy, radiusx)
```
Draws a circle on the input image given the `center` as a `CartesianIndex{2}` or
as coordinates `(y, x)` using the specified `color`. If `color` is not specified,
`one(eltype(img))` is used.
"""
circle{T<:Colorant}(img::AbstractArray{T, 2}, args...) = circle!(copy(img), args...)
circle!{T<:Colorant}(img::AbstractArray{T, 2}, center::CartesianIndex{2}, color::T, radius::Real) = circle!(img, center[1], center[2], color, radius)
circle!{T<:Colorant}(img::AbstractArray{T, 2}, y::Int, x::Int, radius::Real) = circle!(img, y, x, one(T), radius)
circle!{T<:Colorant}(img::AbstractArray{T, 2}, y::Int, x::Int, color::T, radius::Real) = ellipse!(img, y, x, color, radius, radius)
