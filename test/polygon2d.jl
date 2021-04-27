@testset "Polygon2D" begin
    verts = [CartesianIndex(2, 2), CartesianIndex(2, 6), CartesianIndex(6, 6), CartesianIndex(6, 2), CartesianIndex(2, 2)]
    
    # cases for closed = true
    img = zeros(RGB, 7, 7)
    expected = copy(img)
    expected[2:6, 2:6] .= RGB{N0f8}(1)
    res = @inferred draw(img, verts, BoundaryFill(x = 4, y = 4, fill_value = RGB(1), boundary_value = RGB(1)); closed = true)
    @test all(expected .== res) == true

    img = zeros(RGB, 7, 7)
    expected = copy(img)
    expected[2:6, 2:6] .= RGB{N0f8}(1)
    res = @inferred draw!(img, verts, BoundaryFill(x = 4, y = 4, fill_value = RGB(1), boundary_value = RGB(1)); closed = true)
    @test all(expected .== res) == true

    # cases for closed = false
    img = zeros(RGB, 7, 7)
    expected = ones(RGB, 7, 7)
    res = @inferred draw(img, verts, BoundaryFill(x = 4,y = 4,fill_value = RGB(1), boundary_value = RGB(1)); closed = false)
    @test all(expected .== res) == true

    img = zeros(RGB, 7, 7)
    expected = ones(RGB, 7, 7)
    res = @inferred draw!(img, verts, BoundaryFill(x = 4,y = 4,fill_value = RGB(1), boundary_value = RGB(1)); closed = false)
    @test all(expected .== res) == true

end