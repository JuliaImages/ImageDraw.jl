# ImageDraw.jl

A drawing package for JuliaImages

```@contents
Depth = 3
```

## Introduction

ImageDraw supports basic drawing on Images. You can draw points, lines, circles, ellipse and paths.  


## Basic usage

Let's start with a drawing a circle

```@setup usage
mkpath("images")
```

```@example usage
using TestImages, ImageDraw, ColorVectorSpace
using FileIO # hide
img = testimage("lighthouse")

# Detect edges at different scales by adjusting the `spatial_scale` parameter.
draw!(img, Ellipse(CirclePointRadius(350,200,100)))
save("images/lighthouse_circle.png", img) # hide
```

When displayed, these three images look like this:
```@raw html
<img src="images/lighthouse_circle.png" width="512px" alt="edge detection demo 1 image" />
<p>
```

Drawing a circle with a thickness

```@example usage
using TestImages, ImageDraw, ColorVectorSpace
using FileIO # hide
img = testimage("lighthouse")

# With keyword argument fill = false, circle with given thickness is computed 
draw!(img, Ellipse(CirclePointRadius(350, 200, 100; thickness = 75, fill = false)))
```

Drawing a Rectangle.

```@example usage
using TestImages, ImageDraw, ImageCore, ImageShow
using FileIO # hide
img = testimage("lighthouse")

img_example_stage1 = draw!(img, Polygon(RectanglePoints(Point(10, 10), Point(100, 100))), RGB{N0f8}(1))
img_example_stage2 = draw!(img_example_stage1, Polygon(RectanglePoints(CartesianIndex(110, 10), CartesianIndex(200, 200))), RGB{N0f8}(1))
img_example_stage3 = draw!(img_example_stage2, Polygon(RectanglePoints(220, 10, 300, 300)), RGB{N0f8}(1))
```

Drawing a Cross.

```@example usage
using TestImages, ImageDraw, ColorVectorSpace, ImageCore
using FileIO # hide
img = testimage("lighthouse");

draw!(img, Cross(Point(200,150), 50), RGB{N0f8}(1))

save("images/lighthouse_cross.png", img) # hide
```

```@raw html
<img src="images/lighthouse_cross.png" width="512px" alt="edge detection demo 1 image" />
<p>
```