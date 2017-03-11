@testset "Lines2D" begin

	@testset "Lines API" begin
		img = zeros(Gray{N0f8}, 10, 10)
		expected = copy(img)
		expected[diagind(expected)] = one(Gray{N0f8})
		res = line(img, 1, 1, 10, 10)
		@test expected == res
		res = line(img, 1, 1, 10, 10, bresenham)
		@test expected == res
		res = line(img, 1, 1, 10, 10, one(Gray{N0f8}), bresenham)
		@test expected == res
		res = line(img, 1, 1, 10, 10, one(Gray{N0f8}))
		@test expected == res
		res = line(img, CartesianIndex(1, 1), CartesianIndex(10, 10))
		@test expected == res
		res = line(img, CartesianIndex(1, 1), CartesianIndex(10, 10), bresenham)
		@test expected == res
		res = line(img, CartesianIndex(1, 1), CartesianIndex(10, 10), one(Gray{N0f8}), bresenham)
		@test expected == res
		res = line(img, CartesianIndex(1, 1), CartesianIndex(10, 10), one(Gray{N0f8}))
		@test expected == res
		expected[diagind(expected)] = Gray{N0f8}(0.5)
		res = line(img, 1, 1, 10, 10, Gray{N0f8}(0.5))
		@test expected == res
		img2 = zeros(RGB, 10, 10)
		expected = copy(img2)
		expected[diagind(expected)] = RGB{N0f8}(0.2, 0.3, 0.4)
		res = line(img2, 1, 1, 10, 10, RGB{N0f8}(0.2, 0.3, 0.4))
		@test expected == res
	end

	@testset "Bresenham" begin
		img = zeros(Gray{N0f8}, 10, 10)
		expected = copy(img)
		expected[diagind(expected)] = one(Gray{N0f8})
		res = bresenham(copy(img), 1, 1, 10, 10, one(Gray{N0f8}))
		@test expected == res
		expected = copy(img)
		expected[diagind(expected)[1:5]] = one(Gray{N0f8})
		res = bresenham(copy(img), 1, 1, 5, 5, one(Gray{N0f8}))
		@test expected == res

		expected = copy(img)
		expected[10, :] = one(Gray{N0f8})
		res = bresenham(copy(img), 10, 1, 10, 10, one(Gray{N0f8}))
		@test expected == res
		expected = copy(img)
		expected[5, :] = one(Gray{N0f8})
		res = bresenham(copy(img), 5, 1, 5, 10, one(Gray{N0f8}))
		@test expected == res
		expected = copy(img)
		expected[5, 1:5] = one(Gray{N0f8})
		res = bresenham(copy(img), 5, 1, 5, 5, one(Gray{N0f8}))
		@test expected == res

		expected = copy(img)
		expected[:, 10] = one(Gray{N0f8})
		res = bresenham(copy(img), 1, 10, 10, 10, one(Gray{N0f8}))
		@test expected == res
		expected = copy(img)
		expected[:, 5] = one(Gray{N0f8})
		res = bresenham(copy(img), 1, 5, 10, 5, one(Gray{N0f8}))
		@test expected == res
		expected = copy(img)
		expected[1:5, 5] = one(Gray{N0f8})
		res = bresenham(copy(img), 1, 5, 5, 5, one(Gray{N0f8}))
		@test expected == res

		expected = copy(img)
		expected[10:9:91] = one(Gray{N0f8})
		res = bresenham(copy(img), 1, 10, 10, 1, one(Gray{N0f8}))
		@test expected == res
		expected = copy(img)
		expected[10:9:55] = one(Gray{N0f8})
		res = bresenham(copy(img), 10, 1, 5, 6, one(Gray{N0f8}))
		@test expected == res

		img2 = zeros(RGB, 10, 10)
		expected = copy(img2)
		expected[diagind(expected)] = RGB{N0f8}(0.2, 0.3, 0.4)
		res = bresenham(copy(img2), 1, 1, 10, 10, RGB{N0f8}(0.2, 0.3, 0.4))
		@test expected == res
	end

	@testset "Xiaolin-Wu" begin
		img = zeros(Gray{N0f8}, 10, 10)
		expected = copy(img)
		expected[diagind(expected)] = one(Gray{N0f8})
		expected[1, 1] = Gray{N0f8}(0.5)
		expected[10, 10] = Gray{N0f8}(0.5)
		res = xiaolin_wu(copy(img), 1, 1, 10, 10, one(Gray{N0f8}))
		@test expected == res
		expected = copy(img)
		expected[diagind(expected)[1:5]] = one(Gray{N0f8})
		expected[1, 1] = Gray{N0f8}(0.5)
		expected[5, 5] = Gray{N0f8}(0.5)
		res = xiaolin_wu(copy(img), 1, 1, 5, 5, one(Gray{N0f8}))
		@test expected == res

		expected = copy(img)
		expected[10, :] = one(Gray{N0f8})
		expected[10, 1] = Gray{N0f8}(0.5)
		expected[10, 10] = Gray{N0f8}(0.5)
		res = xiaolin_wu(copy(img), 10, 1, 10, 10, one(Gray{N0f8}))
		@test expected == res
		expected = copy(img)
		expected[5, :] = one(Gray{N0f8})
		expected[5, 1] = Gray{N0f8}(0.5)
		expected[5, 10] = Gray{N0f8}(0.5)
		res = xiaolin_wu(copy(img), 5, 1, 5, 10, one(Gray{N0f8}))
		@test expected == res
		expected = copy(img)
		expected[5, 1:5] = one(Gray{N0f8})
		expected[5, 1] = Gray{N0f8}(0.5)
		expected[5, 5] = Gray{N0f8}(0.5)
		res = xiaolin_wu(copy(img), 5, 1, 5, 5, one(Gray{N0f8}))
		@test expected == res

		expected = copy(img)
		expected[:, 10] = one(Gray{N0f8})
		expected[1, 10] = Gray{N0f8}(0.5)
		expected[10, 10] = Gray{N0f8}(0.5)
		res = xiaolin_wu(copy(img), 1, 10, 10, 10, one(Gray{N0f8}))
		@test expected == res
		expected = copy(img)
		expected[:, 5] = one(Gray{N0f8})
		expected[1, 5] = Gray{N0f8}(0.5)
		expected[10, 5] = Gray{N0f8}(0.5)
		res = xiaolin_wu(copy(img), 1, 5, 10, 5, one(Gray{N0f8}))
		@test expected == res
		expected = copy(img)
		expected[1:5, 5] = one(Gray{N0f8})
		expected[1, 5] = Gray{N0f8}(0.5)
		expected[5, 5] = Gray{N0f8}(0.5)
		res = xiaolin_wu(copy(img), 1, 5, 5, 5, one(Gray{N0f8}))
		@test expected == res

		expected = copy(img)
		expected[10:9:91] = one(Gray{N0f8})
		expected[10, 1] = Gray{N0f8}(0.5)
		expected[1, 10] = Gray{N0f8}(0.5)
		res = xiaolin_wu(copy(img), 1, 10, 10, 1, one(Gray{N0f8}))
		@test expected == res
		expected = copy(img)
		expected[10:9:55] = one(Gray{N0f8})
		expected[10, 1] = Gray{N0f8}(0.5)
		expected[5, 6] = Gray{N0f8}(0.5)
		res = xiaolin_wu(copy(img), 10, 1, 5, 6, one(Gray{N0f8}))
		@test expected == res
	end

end
