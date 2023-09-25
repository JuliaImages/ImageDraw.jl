using LinearAlgebra
using ColorVectorSpace

@testset "Circle" begin
    @testset "CirclePointRadius" begin
        img = zeros(Gray{N0f8}, 10, 10)

        expected = Gray{N0f8}[  0 0 1 1 1 1 1 0 0 0
                                0 1 1 1 1 1 1 1 0 0
                                1 1 1 1 1 1 1 1 1 0
                                1 1 1 1 1 1 1 1 1 0
                                1 1 1 1 1 1 1 1 1 0
                                1 1 1 1 1 1 1 1 1 0
                                1 1 1 1 1 1 1 1 1 0
                                0 1 1 1 1 1 1 1 0 0
                                0 0 1 1 1 1 1 0 0 0
                                0 0 0 0 0 0 0 0 0 0 ]

        res = @inferred draw(img, CirclePointRadius(Point(5,5), 5))
        @test all(expected .== res) == true

        res = @inferred draw(img, CirclePointRadius(5, 5, 5))
        @test all(expected .== res) == true

        res = @inferred draw(img, CirclePointRadius(CartesianIndex(5,5), 5))
        @test all(expected .== res) == true

        res = @inferred draw(img, CirclePointRadius(Point(5,5), 5), Gray{N0f8}(0.5))
        expected = map(i->(i==1 ? Gray{N0f8}(0.5) : Gray{N0f8}(0)), expected)
        @test all(expected .== res) == true

        img = zeros(Gray{N0f8}, 10, 10)
        expected = Gray{N0f8}[ 0 0 0 0 0 0 0 0 0 0
                               0 0 0 1 1 1 1 1 0 0
                               0 0 1 1 1 1 1 1 1 0
                               0 1 1 1 0 0 0 1 1 1
                               0 1 1 0 0 0 0 0 1 1
                               0 1 1 0 0 0 0 0 1 1
                               0 1 1 0 0 0 0 0 1 1
                               0 1 1 1 0 0 0 1 1 1
                               0 0 1 1 1 1 1 1 1 0
                               0 0 0 1 1 1 1 1 0 0 ]

        res = @inferred draw(img, CirclePointRadius(Point(6, 6), 5; thickness = 3, fill = false))
        @test all(expected .== res)

        res = @inferred draw(img, CirclePointRadius(Point(6, 6), 5; thickness = 3, fill = false), opacity=0.5)
        @test all(expected * N0f8(0.5) .== res)
        
        err = ArgumentError("Thickness 7 should be smaller than 5.")
        @test_throws err CirclePointRadius(CartesianIndex(6, 6), 5; thickness = 7, fill = false)

        @test draw(img, CirclePointRadius(Point(6, 6), 5; thickness = 0, fill = true)) == draw(img, CirclePointRadius(Point(6, 6), 5))

        @test draw(img, CirclePointRadius(CartesianIndex(5,5), 5; thickness = 0, fill = true)) == draw(img, CirclePointRadius(CartesianIndex(5,5), 5))
        
        @test draw(img, CirclePointRadius(5, 5, 5; thickness = 0, fill = true)) == draw(img, CirclePointRadius(5, 5, 5))


        # expected = CirclePointRadius(Point(6, 6), 5; thickness=UInt8(1), fill=false)
        # res = CirclePointRadius(Point(6, 6), 5; thickness=1, fill=false)
        # @test expected == res
    end

    @testset "CircleThreePoints" begin
        img = zeros(Gray{N0f8}, 10, 10)

        expected = Gray{N0f8}[ 0 0 0 0 0 0 0 0 0 0
                               0 0 0 1 1 1 1 1 0 0
                               0 0 1 1 1 1 1 1 1 0
                               0 1 1 1 1 1 1 1 1 1
                               0 1 1 1 1 1 1 1 1 1
                               0 1 1 1 1 1 1 1 1 1
                               0 1 1 1 1 1 1 1 1 1
                               0 1 1 1 1 1 1 1 1 1
                               0 0 1 1 1 1 1 1 1 0
                               0 0 0 1 1 1 1 1 0 0 ]

        res = @inferred draw(img, CircleThreePoints(Point(1,5), Point(5,1), Point(10,5)))
        @test all(expected .== res)

        res = @inferred draw(img, CircleThreePoints(1,5, 5,1, 10,5))
        @test all(expected .== res)

        res = @inferred draw(img, CircleThreePoints(CartesianIndex(5,1), CartesianIndex(1,5), CartesianIndex(5,10)))
        @test all(expected .== res)

        res = @inferred draw(img, CircleThreePoints(Point(1,5), Point(5,1), Point(10,5)), Gray{N0f8}(0.5))
        expected = map(i->(i==1 ? Gray{N0f8}(0.5) : Gray{N0f8}(0)), expected)
        @test all(expected .== res) == true

        invalid_circle = CircleThreePoints(Point(1,1), Point(2,2), Point(3,3))
        @test_throws ErrorException draw(img, invalid_circle)

        invalid_circle = CircleThreePoints(Point(1,1), Point(5,5), Point(10,1))
        @test_throws ErrorException draw(img, invalid_circle)

    end
end
