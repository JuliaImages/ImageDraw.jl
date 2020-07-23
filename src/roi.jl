@enum AlignOptions begin
    auto = 0
    top_left = 1
    top_right = 2
    bottom_right = 3
    bottom_left = 4
end

function inset_roi(
    img::AbstractArray{T, 2},
    roi::NTuple{2, NTuple{2, <:Int}};
    scale::R = -1, # try to make the view 1/6th or the image area, else as large as fits
    align::AlignOptions = auto, # not let the view obscure the ROI itself
    color::C = Gray(1.0) # to not convert Gray images to RGB in the default case
) where {T<:Colorant, R<:Real, C<:Colorant}

    ((sx, sy), (ex, ey)) = roi

    if !checkindex(Bool, axes(img, 1), sx) ||
       !checkindex(Bool, axes(img, 1), ex) ||
       !checkindex(Bool, axes(img, 2), sy) ||
       !checkindex(Bool, axes(img, 2), ey)
        throw(ArgumentError("Region of interest lies out of image"))
    end

    if scale <= 0 && scale != -1
        throw(ArgumentError("Scale must be positive, instead got $(scale)"))
    end

    if scale == -1
        h = ex - sx + 1
        w = ey - sy + 1
        scale = sqrt(prod(size(img)) / (6 * h * w))
        scale = min((size(img)[1])/h, (size(img)[2])/w, scale)
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

    if align == auto
        if first(axes(img, 1))+size(roi_image, 1)-1 < sx ||
           first(axes(img, 2))+size(roi_image, 2)-1 < sy
            align = top_left

        elseif first(axes(img, 1))+size(roi_image, 1)-1 < sx ||
                last(axes(img, 2))-size(roi_image, 2)+1 > ey
            align = top_right

        elseif last(axes(img, 1))-size(roi_image, 1)+1 > ex ||
                last(axes(img, 2))-size(roi_image, 2)+1 > ey
            align = bottom_right

        elseif last(axes(img, 1))-size(roi_image, 1)+1 > ex ||
                first(axes(img, 2))+size(roi_image, 2)-1 < sy
            align = bottom_left
            
        end

        if align == auto
            @warn "Could not determine overlap-free placement with current settings."
            align = top_left
        end
    end

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
