#Ellipse methods

Ellipse(x::Int, y::Int, ρx::T, ρy::U) where {T<:Real, U<:Real} = Ellipse(Point(x,y), ρx, ρy)
Ellipse(p::CartesianIndex{2}, ρx::T, ρy::U) where {T<:Real, U<:Real} = Ellipse(Point(p), ρx, ρy)
Ellipse(circle::CirclePointRadius) = Ellipse(circle.center, circle.ρ, circle.ρ)

function draw!(img::AbstractArray{T, 2}, ellipse::Ellipse, color::T; in_bounds::Bool=false, thickness::Int=-1) where T<:Colorant
	ys = Int[]
	xs = Int[]
	for i in ellipse.center.y : ellipse.center.y + ellipse.ρy
		for j in ellipse.center.x : ellipse.center.x + ellipse.ρx
			val = ((i - ellipse.center.y) / ellipse.ρy) ^ 2 + ((j - ellipse.center.x) / ellipse.ρx) ^ 2
			if val < 1
				push!(ys, i)
				push!(xs, j)
			end
		end
	end
	for (yi, xi) in zip(ys, xs)
		draw!(img, yi, xi, color, in_bounds=in_bounds, thickness=thickness)
		draw!(img,2 * ellipse.center.y - yi, xi, color, in_bounds=in_bounds, thickness=thickness)
		draw!(img,yi, 2 * ellipse.center.x - xi, color, in_bounds=in_bounds, thickness=thickness)
		draw!(img, 2 * ellipse.center.y - yi, 2 * ellipse.center.x - xi, color, in_bounds=in_bounds, thickness=thickness)
	end
	img
end
