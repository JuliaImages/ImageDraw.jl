@enum AlignOptions begin
    top_left = 1
    top_right = 2
    bottom_right = 3
    bottom_left = 4
end

function inset_roi(
    img::AbstractArray{T, 2},
    roi::NTuple{2, NTuple{2, <:Int}},
    scale::R,
    align::AlignOptions,
    color::C
) where {T<:Colorant, R<:Real, C<:Colorant}

    ((sx, sy), (ex, ey)) = roi

    if !checkindex(Bool, axes(img, 1), sx) ||
       !checkindex(Bool, axes(img, 1), ex) ||
       !checkindex(Bool, axes(img, 2), sy) ||
       !checkindex(Bool, axes(img, 2), ey)
        throw(ArgumentError("Region of interest lies out of image"))
    end

    U = promote_type(T, C) # support different types natively
    img = convert.(U, img) # copy
    color = convert(U, color)

    roi_image = @view img[sx:ex, sy:ey]
    roi_image = imresize(roi_image; ratio=scale) # copy

    if !all(size(roi_image) .<= size(img))
        throw(ArgumentError("The scaled region of interest is larger than the image"))
    end

    border_rect = [
        (first(axes(roi_image, 2)), first(axes(roi_image, 1))),
        (last(axes(roi_image, 2)), first(axes(roi_image, 1))),
        (last(axes(roi_image, 2)), last(axes(roi_image, 1))),
        (first(axes(roi_image, 2)), last(axes(roi_image, 1))),
    ]

    draw!(roi_image, Polygon(border_rect), color)

    roi_rect = [
        (sy, sx),
        (ey, sx),
        (ey, ex),
        (sy, ex)
    ]
    draw!(img, Polygon(roi_rect), color)

    if align == top_left
        img[first(axes(img, 1)):first(axes(img, 1))+size(roi_image, 1)-1,
            first(axes(img, 2)):first(axes(img, 2))+size(roi_image, 2)-1] = roi_image
    elseif align == top_right
        img[first(axes(img, 1)):first(axes(img, 1))+size(roi_image, 1)-1,
            last(axes(img, 2))-size(roi_image, 2)+1:last(axes(img, 2))] = roi_image
    elseif align == bottom_right
        img[last(axes(img, 1))-size(roi_image, 1)+1:last(axes(img, 1)),
            last(axes(img, 2))-size(roi_image, 2)+1:last(axes(img, 2))] = roi_image
    else
        align == bottom_left
        img[last(axes(img, 1))-size(roi_image, 1)+1:last(axes(img, 1)),
            first(axes(img, 2)):first(axes(img, 2))+size(roi_image, 2)-1] = roi_image
    end

    return img
end

function display_roi(
    img::AbstractArray{T, 2},
    roi::AbstractVector{NTuple{2, NTuple{2, <:Int}}},
    size::AbstractVector{<:Real},
    align::AbstractVector{AlignOptions},
    color::AbstractVector{C}
) where {T<:Colorant, C<:Colorant}
    if !(length(roi) == length(size) == length(color) == length(align))
        throw(ArgumentError("Arrays roi, size, align and color must be of the same length, instead got $(length(roi)), $(length(size)), $(length(align)) and $(length(color))"))
    end

    if length(roi) > 4
        throw(ArgumentError("Only upto 4 regions of interest can be displayed, instead got $(length(roi))"))
    end

    if length(unique(align)) < length(align)
        @warn "Similarly aligned regions will likely overlap"
    end

end
