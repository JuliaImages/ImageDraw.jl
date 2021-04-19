@testset "Rectangle" begin
    img = zeros(RGB, 10, 10)
    expected = copy(img)
    expected[3:9, 2] .= RGB{N0f8}(1)
    expected[3:9, 5] .= RGB{N0f8}(1)
    expected[3, 2:5] .= RGB{N0f8}(1)
    expected[9, 2:5] .= RGB{N0f8}(1)
    res = @inferred draw!(img, Polygon(RectanglePoints(Point(2, 3), Point(5, 9))), RGB{N0f8}(1))
    @test all(expected .== res) == true
    
    img1 = zeros(RGB, 10, 10)
    expected = copy(img1)
    expected[3:7, 2] .= RGB{N0f8}(1)
    expected[3:7, 5] .= RGB{N0f8}(1)
    expected[3, 2:5] .= RGB{N0f8}(1)
    expected[7, 2:5] .= RGB{N0f8}(1)
    res = @inferred draw!(img1,Polygon(RectanglePoints(CartesianIndex(2, 3), CartesianIndex(5, 7))), RGB{N0f8}(1))
    @test all(expected .== res ) == true

    img2 = zeros(RGB, 10, 10)
    expected = copy(img2)
    expected[3:7, 2] .= RGB{N0f8}(1)
    expected[3:7, 5] .= RGB{N0f8}(1)
    expected[3, 2:5] .= RGB{N0f8}(1)
    expected[7, 2:5] .= RGB{N0f8}(1)
    res = @inferred draw!(img2, Polygon(RectanglePoints(2, 3, 5, 7)), RGB{N0f8}(1))
    @test all(expected .== res) == true
end