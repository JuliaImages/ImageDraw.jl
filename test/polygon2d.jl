@testset "Polygon2D" begin
    verts = [CartesianIndex(2, 2), CartesianIndex(2, 6), CartesianIndex(6, 6), CartesianIndex(6, 2), CartesianIndex(2, 2)]
    
    img = zeros(RGB{N0f8}, 7, 7)

    expected = copy(img)
    expected[2:6, 2:6] .= RGB{N0f8}(1)
    res = @inferred draw(img, Polygon(verts), RGB{N0f8}(1), fill_color = RGB{N0f8}(1))
    @test all(expected .== res) == true

    expected = copy(img)
    expected[2:6, 2:6] .= RGB{N0f8}(1)
    expected[3:5, 3:5] .= RGB{N0f8}(0.5)
    res = @inferred draw(img, Polygon(verts), RGB{N0f8}(1), fill_color = RGB{N0f8}(0.5))
    @test all(expected .== res) == true

    expected = copy(img)
    expected[2:6, 2:6] .= RGB{N0f8}(1)
    expected[3:5, 3:5] .= RGB{N0f8}(0.5)
    res = @inferred draw(img, Polygon(verts), RGB{N0f8}(1), fill_color = RGB{N0f8}(1), fill_opacity = 0.5)
    @test all(expected .== res) == true

    expected = copy(img)
    expected[2:6, 2:6] .= RGB{N0f8}(0.5)
    res = @inferred draw(img, Polygon(verts), RGB{N0f8}(1), opacity = 0.5, fill_color = RGB{N0f8}(1), fill_opacity = 0.5)
    @test all(expected .== res) == true

    expected = copy(img)
    expected[2:6, 2:6] .= RGB{N0f8}(0.5)
    expected[3:5, 3:5] .= RGB{N0f8}(0.75)
    res = @inferred draw(img, Polygon(verts), RGB{N0f8}(1), opacity = 0.5, fill_color = RGB{N0f8}(1), fill_opacity = 0.75)
    @test all(expected .== res) == true

    # cases when verts are outside the domain
    verts = [CartesianIndex(4, 4), CartesianIndex(4, 8), CartesianIndex(8, 8), CartesianIndex(8, 4), CartesianIndex(4, 4)]

    expected = copy(img)
    expected[4:7, 4:7] .= RGB{N0f8}(1)
    res = @inferred draw(img, Polygon(verts), RGB{N0f8}(1), fill_color = RGB{N0f8}(1))
    @test all(expected .== res) == true
end