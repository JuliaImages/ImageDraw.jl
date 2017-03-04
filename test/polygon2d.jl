using Images
using Base.Test

@testset "Polygon2d" begin
    vert=CartesianIndex{2}[]
    push!(vert, CartesianIndex(1,1))
    push!(vert, CartesianIndex(1,3))
    push!(vert, CartesianIndex(1,5))
    push!(vert, CartesianIndex(3,3))
    push!(vert, CartesianIndex(3,1))
    img = draw_polygon_perimeter(zeros(ColorTypes.Gray{Bool},5,5), vert)
    @test all(x->x==true, img[1,:])==true
    @test all(x->x==true, img[1:3,1])==true
    @test all(x->x==true, img[3,1:3])==true
    @test img[2,4]==true

    img=zeros(ColorTypes.Gray{Bool},5,5)
    draw_polygon_perimeter!(img, vert)
    @test all(x->x==true, img[1,:])==true
    @test all(x->x==true, img[1:3,1])==true
    @test all(x->x==true, img[3,1:3])==true
    @test img[2,4]==true
end