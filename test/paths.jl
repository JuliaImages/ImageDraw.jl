using ImageDraw, ColorTypes, FixedPointNumbers
using Base.Test

@testset "Paths" begin
    vert=CartesianIndex{2}[]
    push!(vert, CartesianIndex(1,1))
    push!(vert, CartesianIndex(1,3))
    push!(vert, CartesianIndex(1,5))
    push!(vert, CartesianIndex(3,3))
    push!(vert, CartesianIndex(3,1))

    img = path(zeros(Gray{Bool},5,5), vert, closed=true)
    @test all(x->x==true, img[1,:])==true
    @test all(x->x==true, img[1:3,1])==true
    @test all(x->x==true, img[3,1:3])==true
    @test all(x->x==false, img[2,2:3])==true
    @test img[2,4]==true

    img=zeros(Gray{Bool},5,5)
    path!(img, vert)
    @test all(x->x==true, img[1,:])==true
    @test all(x->x==true, img[1:3,1])==true
    @test all(x->x==true, img[3,1:3])==true
    @test all(x->x==false, img[2,2:3])==true
    @test img[2,4]==true

    img=zeros(RGB{N0f8},5,5)
    path!(img, vert, RGB{N0f8}(1,0,0), closed=true)
    @test all(x->x==RGB{N0f8}(1,0,0), img[1,:])==true
    @test all(x->x==RGB{N0f8}(1,0,0), img[1:3,1])==true
    @test all(x->x==RGB{N0f8}(1,0,0), img[3,1:3])==true
    @test all(x->x==RGB{N0f8}(0,0,0), img[2,2:3])==true
    @test img[2,4]==RGB{N0f8}(1,0,0)

    img=zeros(RGB{N0f8},5,5)
    path!(img, vert,closed=false)
    @test all(x->x==RGB{N0f8}(1,1,1), img[1,:])==true
    @test all(x->x==RGB{N0f8}(1,1,1), img[3,1:3])==true
    @test all(x->x==RGB{N0f8}(0,0,0), img[2,1:3])==true
    @test img[2,4]==RGB{N0f8}(1,1,1)
end
