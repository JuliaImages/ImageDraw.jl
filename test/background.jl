
@testset "Background" begin
    @testset "SolidBackground" begin

        res = generatecanvas(Gray{N0f8}, 10,10)
        expected = zeros(Gray{N0f8}, (10,10))

    @test all(expected .== res) == true

    res = generatecanvas(Gray{N0f8}, 10,10, SolidBackground(Gray{N0f8}(1.0)))
    expected = ones(Gray{N0f8}, (10,10))

    @test all(expected .== res) == true


    end

    @testset "StripedBackground" begin

        res = generatecanvas(Gray{N0f8}, [10,10], StripedBackground([Gray{N0f8}(1.0),Gray{N0f8}(.5), Gray{N0f8}(.2)], [2, 5, 8], pi/2))
        expected = Gray{N0f8}[  1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0
                                1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0
                                0.502 0.502 0.502 0.502 0.502 0.502 0.502 0.502 0.502 0.502
                                0.502 0.502 0.502 0.502 0.502 0.502 0.502 0.502 0.502 0.502
                                0.502 0.502 0.502 0.502 0.502 0.502 0.502 0.502 0.502 0.502
                                0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2
                                0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2
                                0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2
                                0 0 0 0 0 0 0 0 0 0
                                0 0 0 0 0 0 0 0 0 0 ]

        @test all(expected .== res) == true

        res = generatecanvas(RGB, [5,5], StripedBackground([RGB(.3,.6,.7),RGB(.5,.2,.9)], [2, 4], 0))
        expected = RGB[ RGB(.3,.6,.7) RGB(.3,.6,.7) RGB(.5,.2,.9) RGB(.5,.2,.9) RGB(0,0,0)
                          RGB(.3,.6,.7) RGB(.3,.6,.7) RGB(.5,.2,.9) RGB(.5,.2,.9) RGB(0,0,0)
                          RGB(.3,.6,.7) RGB(.3,.6,.7) RGB(.5,.2,.9) RGB(.5,.2,.9) RGB(0,0,0)
                          RGB(.3,.6,.7) RGB(.3,.6,.7) RGB(.5,.2,.9) RGB(.5,.2,.9) RGB(0,0,0)
                          RGB(.3,.6,.7) RGB(.3,.6,.7) RGB(.5,.2,.9) RGB(.5,.2,.9) RGB(0,0,0) ]

        @test all(expected .== res) == true

        res = generatecanvas(RGB, [5,5], StripedBackground([RGB(.3,.6,.7),RGB(.5,.2,.9)], [2, 4], pi/4))
        expected = RGB[ RGB(.3,.6,.7) RGB(.3,.6,.7) RGB(.5,.2,.9) RGB(.5,.2,.9) RGB(.5,.2,.9)
                          RGB(.3,.6,.7) RGB(.5,.2,.9) RGB(.5,.2,.9) RGB(.5,.2,.9) RGB(0,0,0)
                          RGB(.5,.2,.9) RGB(.5,.2,.9) RGB(.5,.2,.9) RGB(0,0,0) RGB(0,0,0)
                          RGB(.5,.2,.9) RGB(.5,.2,.9) RGB(0,0,0) RGB(0,0,0) RGB(0,0,0)
                          RGB(.5,.2,.9) RGB(0,0,0) RGB(0,0,0) RGB(0,0,0) RGB(0,0,0) ]

        @test all(expected .== res) == true

    end

end
