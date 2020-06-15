@testset "Lines2D" begin

  expected = Gray{N0f8}.([0 0 1 0 0
                          0 1 1 1 0
                          0 0 1 0 0
                          0 0 0 0 0
                          0 0 0 0 0])
  img = fill(Gray{N0f8}(0), 5, 5)
  draw!(img, Cross(Point(3,2), 1), Gray{N0f8}(1))
  @test img == expected

  @testset "Thickness" begin
    expected = Gray{N0f8}.([0 0 1 1 0
                            0 1 1 1 1
                            0 1 1 1 1
                            0 0 1 1 0
                            0 0 0 0 0])
    img = fill(Gray{N0f8}(0), 5, 5)
    draw!(img, Cross(Point(3,2), 1), Gray{N0f8}(1), thickness=2)
    @test img == expected

  end

end
