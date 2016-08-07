using FactCheck, Base.Test, Images, ImageDraw, ColorTypes

facts("Lines2D") do

	context("Lines API") do
		img = zeros(Gray{U8}, 10, 10)
		expected = copy(img)
		expected[diagind(expected)] = one(Gray{U8})
		res = line(img, 1, 1, 10, 10)
		@fact expected == res --> true
		res = line(img, 1, 1, 10, 10, bresenham)
		@fact expected == res --> true
		res = line(img, 1, 1, 10, 10, one(Gray{U8}), bresenham)
		@fact expected == res --> true
		res = line(img, 1, 1, 10, 10, one(Gray{U8}))
		@fact expected == res --> true
		res = line(img, CartesianIndex(1, 1), CartesianIndex(10, 10))
		@fact expected == res --> true
		res = line(img, CartesianIndex(1, 1), CartesianIndex(10, 10), bresenham)
		@fact expected == res --> true
		res = line(img, CartesianIndex(1, 1), CartesianIndex(10, 10), one(Gray{U8}), bresenham)
		@fact expected == res --> true
		res = line(img, CartesianIndex(1, 1), CartesianIndex(10, 10), one(Gray{U8}))
		@fact expected == res --> true
		expected[diagind(expected)] = Gray{U8}(0.5)
		res = line(img, 1, 1, 10, 10, Gray{U8}(0.5))
		@fact expected == res --> true
		img2 = zeros(RGB, 10, 10)
		expected = copy(img2)
		expected[diagind(expected)] = RGB{U8}(0.2, 0.3, 0.4)
		res = line(img2, 1, 1, 10, 10, RGB{U8}(0.2, 0.3, 0.4))
		@fact expected == res --> true
	end
	
	context("Bresenham") do
		img = zeros(Gray{U8}, 10, 10)
		expected = copy(img)
		expected[diagind(expected)] = one(Gray{U8})
		res = bresenham(copy(img), 1, 1, 10, 10, one(Gray{U8}))
		@fact expected == res --> true
		expected = copy(img)
		expected[diagind(expected)[1:5]] = one(Gray{U8})
		res = bresenham(copy(img), 1, 1, 5, 5, one(Gray{U8}))
		@fact expected == res --> true

		expected = copy(img)
		expected[10, :] = one(Gray{U8})
		res = bresenham(copy(img), 10, 1, 10, 10, one(Gray{U8}))
		@fact expected == res --> true
		expected = copy(img)
		expected[5, :] = one(Gray{U8})
		res = bresenham(copy(img), 5, 1, 5, 10, one(Gray{U8}))
		@fact expected == res --> true
		expected = copy(img)
		expected[5, 1:5] = one(Gray{U8})
		res = bresenham(copy(img), 5, 1, 5, 5, one(Gray{U8}))
		@fact expected == res --> true

		expected = copy(img)
		expected[:, 10] = one(Gray{U8})
		res = bresenham(copy(img), 1, 10, 10, 10, one(Gray{U8}))
		@fact expected == res --> true
		expected = copy(img)
		expected[:, 5] = one(Gray{U8})
		res = bresenham(copy(img), 1, 5, 10, 5, one(Gray{U8}))
		@fact expected == res --> true
		expected = copy(img)
		expected[1:5, 5] = one(Gray{U8})
		res = bresenham(copy(img), 1, 5, 5, 5, one(Gray{U8}))
		@fact expected == res --> true

		expected = copy(img)
		expected[10:9:91] = one(Gray{U8})
		res = bresenham(copy(img), 1, 10, 10, 1, one(Gray{U8}))
		@fact expected == res --> true
		expected = copy(img)
		expected[10:9:55] = one(Gray{U8})
		res = bresenham(copy(img), 10, 1, 5, 6, one(Gray{U8}))
		@fact expected == res --> true

		img2 = zeros(RGB, 10, 10)
		expected = copy(img2)
		expected[diagind(expected)] = RGB{U8}(0.2, 0.3, 0.4)
		res = bresenham(copy(img2), 1, 1, 10, 10, RGB{U8}(0.2, 0.3, 0.4))
		@fact expected == res --> true
	end

	context("Xiaolin-Wu") do
		img = zeros(Gray{U8}, 10, 10)
		expected = copy(img)
		expected[diagind(expected)] = one(Gray{U8})
		expected[1, 1] = Gray{U8}(0.5)
		expected[10, 10] = Gray{U8}(0.5)
		res = xiaolin_wu(copy(img), 1, 1, 10, 10, one(Gray{U8}))
		@fact expected == res --> true
		expected = copy(img)
		expected[diagind(expected)[1:5]] = one(Gray{U8})
		expected[1, 1] = Gray{U8}(0.5)
		expected[5, 5] = Gray{U8}(0.5)
		res = xiaolin_wu(copy(img), 1, 1, 5, 5, one(Gray{U8}))
		@fact expected == res --> true

		expected = copy(img)
		expected[10, :] = one(Gray{U8})
		expected[10, 1] = Gray{U8}(0.5)
		expected[10, 10] = Gray{U8}(0.5)
		res = xiaolin_wu(copy(img), 10, 1, 10, 10, one(Gray{U8}))
		@fact expected == res --> true
		expected = copy(img)
		expected[5, :] = one(Gray{U8})
		expected[5, 1] = Gray{U8}(0.5)
		expected[5, 10] = Gray{U8}(0.5)
		res = xiaolin_wu(copy(img), 5, 1, 5, 10, one(Gray{U8}))
		@fact expected == res --> true
		expected = copy(img)
		expected[5, 1:5] = one(Gray{U8})
		expected[5, 1] = Gray{U8}(0.5)
		expected[5, 5] = Gray{U8}(0.5)
		res = xiaolin_wu(copy(img), 5, 1, 5, 5, one(Gray{U8}))
		@fact expected == res --> true

		expected = copy(img)
		expected[:, 10] = one(Gray{U8})
		expected[1, 10] = Gray{U8}(0.5)
		expected[10, 10] = Gray{U8}(0.5)
		res = xiaolin_wu(copy(img), 1, 10, 10, 10, one(Gray{U8}))
		@fact expected == res --> true
		expected = copy(img)
		expected[:, 5] = one(Gray{U8})
		expected[1, 5] = Gray{U8}(0.5)
		expected[10, 5] = Gray{U8}(0.5)
		res = xiaolin_wu(copy(img), 1, 5, 10, 5, one(Gray{U8}))
		@fact expected == res --> true
		expected = copy(img)
		expected[1:5, 5] = one(Gray{U8})
		expected[1, 5] = Gray{U8}(0.5)
		expected[5, 5] = Gray{U8}(0.5)
		res = xiaolin_wu(copy(img), 1, 5, 5, 5, one(Gray{U8}))
		@fact expected == res --> true

		expected = copy(img)
		expected[10:9:91] = one(Gray{U8})
		expected[10, 1] = Gray{U8}(0.5)
		expected[1, 10] = Gray{U8}(0.5)
		res = xiaolin_wu(copy(img), 1, 10, 10, 1, one(Gray{U8}))
		@fact expected == res --> true
		expected = copy(img)
		expected[10:9:55] = one(Gray{U8})
		expected[10, 1] = Gray{U8}(0.5)
		expected[5, 6] = Gray{U8}(0.5)
		res = xiaolin_wu(copy(img), 10, 1, 5, 6, one(Gray{U8}))
		@fact expected == res --> true
	end

end