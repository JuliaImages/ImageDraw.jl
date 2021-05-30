function generate_logo()
    # Load original image (from https://github.com/JuliaImages/juliaimages.github.io/blob/source/docs/src/assets/logo.png)
    img = load("docs/logo_original.png")

    # Define some colors
    c_red, c_green, c_blue, c_purple = RGBA.([Colors.JULIA_LOGO_COLORS...])
    gray_dark = RGBA{N0f8}(0.1,0.1,0.1)
    gray_light = RGBA{N0f8}(0.9,0.9,0.9)

    # Change base color black to gray
    img = img*N0f8(0.5) .+ RGBA{N0f8}(0.5,0.5,0.5,0)
    img_dark = copy(img)
    img_light = copy(img)

    # Define points on the image
    p_green = Point(87,35)
    p_red = Point(75,55)
    p_purple = Point(99,55)
    p_1 = Point(13,96)
    p_2 = Point(52,50)
    p_3 = Point(73,73)
    p_4 = Point(84,62)
    p_5 = Point(116,97)

    # Define path
    path_dark = "docs/src/assets/logo-dark.png"
    path_light = "docs/src/assets/logo.png"

    for (img,gray,name) in ((img_dark,gray_light,path_dark), (img_light,gray_dark,path_light))
        draw!(img, LineTwoPoints(p_1,p_2), gray)
        draw!(img, LineTwoPoints(p_2,p_3), gray)
        draw!(img, LineTwoPoints(p_3,p_4), gray)
        draw!(img, LineTwoPoints(p_4,p_5), gray)

        draw!(img, Cross(p_1,8), gray)
        draw!(img, Cross(p_2,8), gray)
        draw!(img, Cross(p_3,8), gray)
        draw!(img, Cross(p_4,8), gray)
        draw!(img, Cross(p_5,8), gray)

        draw!(img, Ellipse(CirclePointRadius(p_green,10)), c_green)
        draw!(img, Ellipse(CirclePointRadius(p_red,10)), c_red)
        draw!(img, Ellipse(CirclePointRadius(p_purple,10)), c_purple)

        save(name,img)
    end
end
