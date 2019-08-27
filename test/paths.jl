using ImageDraw
using Test

@testset "Polygon" begin
    vert=CartesianIndex{2}[]
    push!(vert, CartesianIndex(1,1))
    push!(vert, CartesianIndex(1,3))
    push!(vert, CartesianIndex(1,5))
    push!(vert, CartesianIndex(3,3))
    push!(vert, CartesianIndex(3,1))

    img = @inferred draw(zeros(Gray{Bool},5,5), Polygon(vert))
    @test all(x->x==true, img[1,:])==true
    @test all(x->x==true, img[1:3,1])==true
    @test all(x->x==true, img[3,1:3])==true
    @test all(x->x==false, img[2,2:3])==true
    @test img[2,4]==true

    img=zeros(Gray{Bool},5,5)
    @inferred draw!(img, Polygon(vert))
    @test all(x->x==true, img[1,:])==true
    @test all(x->x==true, img[1:3,1])==true
    @test all(x->x==true, img[3,1:3])==true
    @test all(x->x==false, img[2,2:3])==true
    @test img[2,4]==true

    img=zeros(RGB{N0f8},5,5)
    @inferred draw!(img, Polygon(vert), RGB(1,0,0))
    @test all(x->x==RGB{N0f8}(1,0,0), img[1,:])==true
    @test all(x->x==RGB{N0f8}(1,0,0), img[1:3,1])==true
    @test all(x->x==RGB{N0f8}(1,0,0), img[3,1:3])==true
    @test all(x->x==RGB{N0f8}(0,0,0), img[2,2:3])==true
    @test img[2,4]==RGB{N0f8}(1,0,0)

    poly_tuples = [(1,1),(3,1),(5,1),(3,3),(1,3)]
    img = @inferred draw(zeros(Gray{Bool},5,5), Polygon(poly_tuples))
    @test all(x->x==true, img[1,:])==true
    @test all(x->x==true, img[1:3,1])==true
    @test all(x->x==true, img[3,1:3])==true
    @test all(x->x==false, img[2,2:3])==true
    @test img[2,4]==true
end

@testset "Path" begin
    vert=CartesianIndex{2}[]
    push!(vert, CartesianIndex(1,1))
    push!(vert, CartesianIndex(1,3))
    push!(vert, CartesianIndex(1,5))
    push!(vert, CartesianIndex(3,3))
    push!(vert, CartesianIndex(3,1))

    img=zeros(RGB{N0f8},5,5)
    @inferred draw!(img, Path(vert))
    @test all(x->x==RGB{N0f8}(1,1,1), img[1,:])==true
    @test all(x->x==RGB{N0f8}(1,1,1), img[3,1:3])==true
    @test all(x->x==RGB{N0f8}(0,0,0), img[2,1:3])==true
    @test img[2,4]==RGB{N0f8}(1,1,1)

    poly_tuples = [(1,1),(3,1),(5,1),(3,3),(1,3)]

    img=zeros(RGB{N0f8},5,5)
    @inferred draw!(img, Path(poly_tuples))
    @test all(x->x==RGB{N0f8}(1,1,1), img[1,:])==true
    @test all(x->x==RGB{N0f8}(1,1,1), img[3,1:3])==true
    @test all(x->x==RGB{N0f8}(0,0,0), img[2,1:3])==true
    @test img[2,4]==RGB{N0f8}(1,1,1)


    @testset "Thickness" begin
        vert=CartesianIndex{2}[]
        push!(vert, CartesianIndex(1,1))
        push!(vert, CartesianIndex(1,4))
        push!(vert, CartesianIndex(4,4))
        push!(vert, CartesianIndex(4,1))
        img=zeros(Gray{N0f8},5,5)
        expected = Gray{N0f8}.([1 1 1 1 1
								1 1 1 1 1
								1 1 0 1 1
								1 1 1 1 1
								1 1 1 1 1])
        draw!(img, Polygon(vert),thickness=2)

    end


end

@testset "RegularPolygon" begin
    img = zeros(Gray, 10, 10)
    expected = copy(img)
    expected[3, 2:6] .= Gray(1)
    expected[7, 2:6] .= Gray(1)
    expected[3:7, 2] .= Gray(1)
    expected[3:7, 6] .= Gray(1)
    @test all(expected .== @inferred draw(img, RegularPolygon(CartesianIndex(5,4), 4, 4, π/4))) == true
end
