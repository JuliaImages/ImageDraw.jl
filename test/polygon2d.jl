using Images
using Base.Test

@testset "Polygon2d" begin
    vert=CartesianIndex{2}[]
    push!(vert, CartesianIndex(1,1))
    push!(vert, CartesianIndex(1,3))
    push!(vert, CartesianIndex(1,5))
    push!(vert, CartesianIndex(3,3))
    push!(vert, CartesianIndex(3,1))
    img = polygon_perimeter(zeros(ColorTypes.Gray{Bool},5,5), vert)
    @test all(x->x==true, img[1,:])==true
    @test all(x->x==true, img[1:3,1])==true
    @test all(x->x==true, img[3,1:3])==true
    @test all(x->x==false, img[2,2:3])==true
    @test img[2,4]==true

    img=zeros(ColorTypes.Gray{Bool},5,5)
    polygon_perimeter!(img, vert)
    @test all(x->x==true, img[1,:])==true
    @test all(x->x==true, img[1:3,1])==true
    @test all(x->x==true, img[3,1:3])==true
    @test all(x->x==false, img[2,2:3])==true
    @test img[2,4]==true

    img=zeros(ColorTypes.RGB{N0f8},5,5)
    polygon_perimeter!(img, vert, RGB{N0f8}(1,0,0))
    @test all(x->x==RGB{N0f8}(1,0,0), img[1,:])==true
    @test all(x->x==RGB{N0f8}(1,0,0), img[1:3,1])==true
    @test all(x->x==RGB{N0f8}(1,0,0), img[3,1:3])==true
    @test all(x->x==RGB{N0f8}(0,0,0), img[2,2:3])==true
    @test img[2,4]==RGB{N0f8}(1,0,0)
end