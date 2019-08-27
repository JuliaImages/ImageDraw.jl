using LinearAlgebra

@testset "Core" begin

    points = [Point(1,1), Point(2,2), Point(3,3)]
    img = zeros(Gray{N0f8}, 3, 3)
    @inferred draw!(img, points)
    expected = Matrix(Diagonal([1,1,1]))
    @test all(img .== expected) == true

    img = zeros(Gray{N0f8}, 3, 3)
    @inferred draw!(img, points, Gray{N0f8}(0.8))
    expected = Matrix(Diagonal([0.8,0.8,0.8]))
    @test all(img .== expected) == true

    img = zeros(Gray{N0f8}, 3, 3)
    @inferred draw!(img, points, Gray{N0f8}(0.8))
    expected = Matrix(Diagonal([0.8,0.8,0.8]))
    @test all(img .== expected) == true

    points = [Point((1,1)), Point((2,2)), Point((3,3))]
    img = zeros(Gray{N0f8}, 3, 3)
    @inferred draw!(img, points)
    expected = Matrix(Diagonal([1,1,1]))
    @test all(img .== expected) == true

    ci = [CartesianIndex(1,2), CartesianIndex(1,3), CartesianIndex(3,1)]
    points = [Point(i) for i in ci]
    img = zeros(Gray{N0f8}, 3, 3)
    expected = copy(img)
    @inferred draw!(img, points)
    expected[1,2] = expected[1,3] = expected[3,1] = oneunit(Gray{N0f8})
    @test all(img .== expected) == true

    point = Point(4,1)
    img = zeros(Gray{N0f8}, 3, 3)
    @inferred draw!(img, point)
    expected = zeros(Gray{N0f8})
    @test all(img .== expected) == true

    @testset "Thickness" begin
        point = Point(2,2)
        img = zeros(Gray{N0f8}, 3, 3)
        @inferred draw!(img, point, thickness=2)
        img[2:end,2:end] .= 1
        expected = img
        @test all(img .== expected) == true

        point = Point(2,2)
        img = zeros(Gray{N0f8}, 3, 3)
        @inferred draw!(img, point, thickness=3)
        expected = img .= 1
        @test all(img .== expected) == true
    end
end
