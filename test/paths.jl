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

    # filled polygon
    img = @inferred draw(zeros(Gray{Bool},5,5), Polygon(poly_tuples; fill = true))
    @test all(x->x==true, img[1,:])==true
    @test all(x->x==true, img[2,1:4])==true
    @test all(x->x==true, img[3,1:3])==true

    @test img[2,5]==false
    @test all(x->x==false, img[3,4:5])==true
    @test all(x->x==false, img[4:5,:])==true

    poly_tuples = [(1,1),(5,5),(5,1),(1,5)]
    img = @inferred draw(zeros(Gray{Bool},5,5), Polygon(poly_tuples; fill = true))
    @test all(x->x==true, img[:,1])==true
    @test all(x->x==true, img[2:4,2])==true
    @test img[3, 3]==true
    @test all(x->x==true, img[2:4,4])==true
    @test all(x->x==true, img[:,5])==true
    
    @test all(x->x==false, img[1,2:4])==true
    @test all(x->x==false, (img[2,3], img[4,3]))==true
    @test all(x->x==false, img[5,2:4])==true

    poly_tuples_outside_image = [(-1, 2), (3, 6), (7, 2)]
    img = @inferred draw(zeros(Gray{Bool},5,5), Polygon(poly_tuples_outside_image; fill = true))
    @test all(x->x==true, img[2:4,:])==true
    @test all(x->x==true, img[5,2:3])==true

    @test all(x->x==false, img[1,:])==true
    @test all(x->x==false, (img[5,1], img[5,5]))==true
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

    # No longer invalid, the program will draw what it can on the image 

    # img = zeros(Gray{N0f8},5,5)
    # invalid_points = [(6,1), (4,4), (1,7), (7,6)]
    # @test_throws ErrorException draw!(img, Path(invalid_points))
    #
    # invalid_points = [(4,4), (1,7), (7,6)]
    # @test_throws ErrorException draw!(img, Path(invalid_points))
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
