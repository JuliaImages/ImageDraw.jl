#Ellipse methods

Ellipse{T<:Real, U<:Real}(x::Int, y::Int, ρx::T, ρy::U) = Ellipse(Point(x,y), ρx, ρy)
Ellipse{T<:Real, U<:Real}(p::CartesianIndex{2}, ρx::T, ρy::U) = Ellipse(Point(p), ρx, ρy)
Ellipse(circle::CirclePointRadius) = Ellipse(circle.center, circle.ρ, circle.ρ)

function draw!{T<:Colorant}(img::AbstractArray{T, 2}, ellipse::Ellipse, color::T)
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
		img[yi, xi] = color
		img[2 * ellipse.center.y - yi, xi] = color
		img[yi, 2 * ellipse.center.x - xi] = color
		img[2 * ellipse.center.y - yi, 2 * ellipse.center.x - xi] = color
	end
	img
end
