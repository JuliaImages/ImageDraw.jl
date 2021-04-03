# using ImageCore,ImageDraw,ColorVectorSpace
# using Test

# @testset "Polygon2D" begin
#     img = zeros(RGB, 7, 7)
#     expected = copy(img)
#     expected[2:6, 2:6] .= RGB{N0f8}(1)
#     verts = [CartesianIndex(2, 2), CartesianIndex(2, 6),CartesianIndex(6, 6), CartesianIndex(6, 2),CartesianIndex(2,2)]
    
#     res = @inferred draw(img,verts,boundaryfill(x=4,y=4,fill_color=RGB(1),boundarycolor=RGB(1)))
#     @test all(expected .== res) == true
# end