#Ellipse methods

Ellipse(x::Int, y::Int, args...; kwargs...) = Ellipse(Point(x,y), args...; kwargs...)
Ellipse(p::CartesianIndex{2}, args...; kwargs...) = Ellipse(Point(p), args...; kwargs...)
Ellipse(circle::CirclePointRadius) = Ellipse(circle.center, circle.ρ, circle.ρ; thickness = circle.thickness, fill = circle.fill)

function draw!(img::AbstractArray{T, 2}, ellipse::Ellipse, color::T; opacity::AbstractFloat = 1.0) where T<:Colorant
	points = Set{Tuple{Int, Int}}()
	break_point = 0
	if ellipse.fill == false
		break_point = ((ellipse.ρy - ellipse.thickness) / ellipse.ρy) ^ 2 + ((ellipse.ρx - ellipse.thickness) / ellipse.ρx) ^ 2 
	end
	for i in ellipse.center.y : ellipse.center.y + ellipse.ρy
		for j in ellipse.center.x : ellipse.center.x + ellipse.ρx
			val = ((i - ellipse.center.y) / ellipse.ρy) ^ 2 + ((j - ellipse.center.x) / ellipse.ρx) ^ 2
			if val < 1 && val >= break_point			
				push!(points, (i, j))
				push!(points, (2 * ellipse.center.y - i, j))
				push!(points, (i, 2 * ellipse.center.x - j))
				push!(points, (2 * ellipse.center.y - i, 2 * ellipse.center.x - j))
			end
		end
	end
	for (yi, xi) in points
		drawifinbounds!(img, yi, xi, color, opacity=opacity)
	end
	img
end
