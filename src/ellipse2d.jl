#Ellipse methods

Ellipse(x::Int, y::Int, ρx::T, ρy::U; thickness::Int = 0, fill::Bool = true) where {T<:Real, U<:Real} = Ellipse{T, U}(Point(x,y), ρx, ρy, thickness, fill)
Ellipse(p::CartesianIndex{2}, ρx::T, ρy::U; thickness::Int = 0, fill::Bool = true) where {T<:Real, U<:Real} = Ellipse{T, U}(Point(p), ρx, ρy, thickness, fill)
Ellipse(circle::CirclePointRadius) = Ellipse(circle.center, circle.ρ, circle.ρ;  thickness = circle.thickness, fill = circle.fill)

function draw!(img::AbstractArray{T, 2}, ellipse::Ellipse, color::T) where T<:Colorant
	ys = Int[]
	xs = Int[]
	break_point = 0
	if ellipse.fill == false
        break_point = ((ellipse.ρy - ellipse.thickness)/ ellipse.ρy) ^ 2 + ((ellipse.ρx - ellipse.thickness)/ ellipse.ρx) ^ 2 
	end
	for i in ellipse.center.y : ellipse.center.y + ellipse.ρy
		for j in ellipse.center.x : ellipse.center.x + ellipse.ρx
			val = ((i - ellipse.center.y) / ellipse.ρy) ^ 2 + ((j - ellipse.center.x) / ellipse.ρx) ^ 2
			if val < 1 && val >= break_point			
				push!(ys, i)
				push!(xs, j)
			end
		end
	end
	for (yi, xi) in zip(ys, xs)
		drawifinbounds!(img, yi, xi, color)
		drawifinbounds!(img,2 * ellipse.center.y - yi, xi, color)
		drawifinbounds!(img,yi, 2 * ellipse.center.x - xi, color)
		drawifinbounds!(img, 2 * ellipse.center.y - yi, 2 * ellipse.center.x - xi, color)
	end
	img
end
