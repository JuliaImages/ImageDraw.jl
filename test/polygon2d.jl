@testset "Polygon2D" begin
    verts = [CartesianIndex(2, 2), CartesianIndex(2, 6), CartesianIndex(6, 6), CartesianIndex(6, 2), CartesianIndex(2, 2)]
    
    # cases for closed = true
    img = zeros(RGB, 7, 7)
    expected = copy(img)
    expected[2:6, 2:6] .= RGB{N0f8}(1)
    res = @inferred draw(img, verts, BoundaryFill(4, 4; fill_value = RGB(1), boundary_value = RGB(1)); closed = true)
    @test all(expected .== res) == true

    img = zeros(RGB, 7, 7)
    expected = copy(img)
    expected[2:6, 2:6] .= RGB{N0f8}(1)
    res = @inferred draw!(img, verts, BoundaryFill(4, 4; fill_value = RGB(1), boundary_value = RGB(1)); closed = true)
    @test all(expected .== res) == true

    # cases for closed = false
    img = zeros(RGB, 7, 7)
    expected = ones(RGB, 7, 7)
    res = @inferred draw(img, verts, BoundaryFill(4, 4; fill_value = RGB(1), boundary_value = RGB(1)); closed = false)
    @test all(expected .== res) == true

    img = zeros(RGB, 7, 7)
    expected = ones(RGB, 7, 7)
    res = @inferred draw!(img, verts, BoundaryFill(4, 4; fill_value = RGB(1), boundary_value = RGB(1)); closed = false)
    @test all(expected .== res) == true

    # cases without boundary_value
    img = zeros(RGB,7,7)
    expected = ones(RGB,7,7)
    res = @inferred draw(img, verts, BoundaryFill(4, 4; fill_value = RGB(1)); closed = false)
    @test all(expected .== res) == true

    img = zeros(RGB,7,7)
    expected = ones(RGB,7,7)
    res = @inferred draw!(img, verts, BoundaryFill(4, 4; fill_value = RGB(1)); closed = false)
    @test all(expected .== res) == true

    # cases without both fill_value and boundary_value
    img = zeros(RGB,7,7)
    expected = ones(RGB,7,7)
    res = @inferred draw(img, verts, BoundaryFill(4, 4); closed = false)
    @test all(expected .== res) == true

    img = zeros(RGB,7,7)
    expected = ones(RGB,7,7)
    res = @inferred draw!(img, verts, BoundaryFill(4, 4); closed = false)
    @test all(expected .== res) == true

    # cases with no parameters
    img = zeros(RGB,7,7)
    expected = copy(img)
    expected .= RGB{N0f8}(1)
    res = @inferred draw(img, verts, BoundaryFill(); closed = false)
    @test all(expected .== res) == true

    img = zeros(RGB,7,7)
    expected = copy(img)
    expected .= RGB{N0f8}(1)
    res = @inferred draw!(img, verts, BoundaryFill(); closed = false)
    @test all(expected .== res) == true

    # cases for use of CartesianIndex
    img = zeros(RGB, 7, 7)
    expected = copy(img)
    expected[2:6, 2:6] .= RGB{N0f8}(1)
    res = @inferred draw(img, verts, BoundaryFill(CartesianIndex(4, 4); fill_value = RGB(1), boundary_value = RGB(1)); closed = true)
    @test all(expected .== res) == true

    img = zeros(RGB, 7, 7)
    expected = copy(img)
    expected[2:6, 2:6] .= RGB{N0f8}(1)
    res = @inferred draw!(img, verts, BoundaryFill(CartesianIndex(4, 4); fill_value = RGB(1), boundary_value = RGB(1)); closed = true)
    @test all(expected .== res) == true

    # Cases for use of Point
    img = zeros(RGB, 7, 7)
    expected = copy(img)
    expected[2:6, 2:6] .= RGB{N0f8}(1)
    res = @inferred draw(img, verts, BoundaryFill(Point(5, 4); fill_value = RGB(1), boundary_value = RGB(1)); closed = true)
    @test all(expected .== res) == true

    img = zeros(RGB, 7, 7)
    expected = copy(img)
    expected[2:6, 2:6] .= RGB{N0f8}(1)
    res = @inferred draw!(img, verts, BoundaryFill(Point(5, 4); fill_value = RGB(1), boundary_value = RGB(1)); closed = true)
    @test all(expected .== res) == true

    # cases when verts are outside the domain
    img = zeros(RGB, 7, 7)
    verts = [CartesianIndex(2, 2), CartesianIndex(2, 0), CartesianIndex(6, 6), CartesianIndex(6, 2), CartesianIndex(2, 2)]
    err = DomainError(CartesianIndex(2, 0), "Vertice $(CartesianIndex(2, 0)) outside the image array domain")
    @test_throws err draw(img, verts, BoundaryFill(4, 4; fill_value = RGB(1), boundary_value = RGB(1)); closed = true)

    img = zeros(RGB, 7, 7)
    verts = [CartesianIndex(2, 2), CartesianIndex(2, 6), CartesianIndex(0, 6), CartesianIndex(6, 2), CartesianIndex(2, 2)]
    err = DomainError(CartesianIndex(0, 6), "Vertice $(CartesianIndex(0, 6)) outside the image array domain")
    @test_throws err draw!(img, verts, BoundaryFill(4, 4; fill_value = RGB(1), boundary_value = RGB(1)); closed = true)

    # verts need to be reset to original
    verts = [CartesianIndex(2, 2), CartesianIndex(2, 6), CartesianIndex(6, 6), CartesianIndex(6, 2), CartesianIndex(2, 2)]
    
    # cases when initial point is outside image domain
    img = zeros(RGB, 7, 7)
    @test_throws BoundsError draw(img, verts, BoundaryFill(0, 4; fill_value = RGB(1), boundary_value = RGB(1)); closed = true)

    img = zeros(RGB, 7, 7)
    @test_throws BoundsError draw!(img, verts, BoundaryFill(4, 9; fill_value = RGB(1), boundary_value = RGB(1)); closed = true)

    # cases without boundary_value and fill value = RGB(0, 1, 0)
    img = zeros(RGB,7,7)
    expected = copy(img)
    expected[2:6, 2:6] .= RGB(0, 1, 0)
    res = @inferred draw(img, verts, BoundaryFill(4, 4; fill_value = RGB(0, 1, 0)); closed = true)
    @test all(expected .== res) == true

    img = zeros(RGB,7,7)
    expected = copy(img)
    expected[:,:] .= RGB(0, 1, 0)
    res = @inferred draw!(img, verts, BoundaryFill(4, 4; fill_value = RGB(0, 1, 0)); closed = false)
    @test all(expected .== res) == true

end