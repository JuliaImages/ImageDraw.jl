# ImageDraw.jl Documentation

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

Drawing a Rectangle.

```@example usage
using TestImages, ImageDraw, ImageCore
using FileIO # hide
img = testimage("lighthouse")

draw!(img, Rectangle((50,300), 300, 100), RGB(1, 0, 0))
save("images/lighthouse_rectangle.png", img) # hide
```

```@raw html
<img src="images/lighthouse_rectangle.png" width="512px" alt="edge detection demo 1 image" />
<p>
```