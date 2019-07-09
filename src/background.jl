"""
    gen_img = generatecanvas(colortype, x, y)
    gen_img = generatecanvas(colortype, x, y, background)
    gen_img = generatecanvas(colortype, [x,y])
    gen_img = generatecanvas(colortype, [x,y], background)

    Creates an image of with the given colortype and size.
    Defaults to a black solid image
"""
generatecanvas(colortype::Type, x::Int, y::Int) = zeros(colortype, (x,y))

generatecanvas(colortype::Type, size::NTuple{2, Int}) = zeros(colortype, size)

generatecanvas(colortype::Type, x::Int, y::Int, b::AbstractBackground) =
    generatecanvas(colortype, (x,y), b)

function generatecanvas(colortype::Type, size::NTuple{2, Int}, b::AbstractBackground)
    draw!(zeros(colortype, (size...)), b)
end


"""
    new_img = draw!(img, solid_background)

    Paints the entire given image a solid color
"""
function draw!(img::AbstractArray{T,2}, b::SolidBackground) where {T<:Colorant}
    b.color == zero(typeof(b.color)) ? (return img) : nothing
    x, y = size(img)
    for i = 1:y
        for j = 1:x
            draw!(img, Point(j, i), b.color)
        end
    end
    img
end

"""
    new_img = draw!(img, striped_background)

    Layers colors onto a given image to set a "background"
"""
function draw!(img::AbstractArray{T,2}, b::StripedBackground) where {T<:Colorant}
    x,y = size(img)
    for (e,(c,d)) in enumerate(zip(b.colors,b.distances))
        draw!(img, LineNormal(d,b.θ), c)
        for i = 1:y
            cnt = 0
            for j = 1:x
                if img[i,j] == zero(typeof(c))
                    draw!(img, Point(j,i), c)
                    cnt += 1
                elseif img[i,j] == c
                    break
                elseif img[i,j] in b.colors[1:e-1]
                    cnt = 1
                    continue
                end
            end
            cnt == 0 ? break : continue
        end
    end
    img
end
