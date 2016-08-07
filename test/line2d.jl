using FactCheck, Base.Test, Images, ImageDraw, ColorTypes

facts("Lines2D") do
	img = zeros(Gray, 10, 10)

	context("Bresenham") do
		expected = copy(img)
		expected[diagind(expected)] = one(Gray)
		res = bresenham(img, 1, 1, 10, 10, one(Gray))
		@fact expected == res --> true
		@fact expected == res --> true
		res = line(img, 1, 1, 10, 10)
		@fact expected == res --> true
		res = line(img, 1, 1, 10, 10, bresenham)
		@fact expected == res --> true
		res = line(img, 1, 1, 10, 10, one(Gray), bresenham)
		@fact expected == res --> true
		res = line(img, 1, 1, 10, 10, one(Gray))
		@fact expected == res --> true
		expected[diagind(expected)] = Gray(0.5)
		res = line(img, 1, 1, 10, 10, Gray(0.5))
		@fact expected == res --> true
		expected = copy(img)
		expected[diagind(expected)[1:5]] = one(Gray)
		res = bresenham(img, 1, 1, 5, 5, one(Gray))

		expected = copy(img)
		expected[10, :] = one(Gray)
		res = bresenham(img, 10, 1, 10, 10, one(Gray))
		@fact expected == res --> true
		expected = copy(img)
		expected[5, :] = one(Gray)
		res = bresenham(img, 5, 1, 5, 10, one(Gray))
		@fact expected == res --> true
		expected = copy(img)
		expected[5, 1:5] = one(Gray)
		res = bresenham(img, 5, 1, 5, 5, one(Gray))
		@fact expected == res --> true

		expected = copy(img)
		expected[:, 10] = one(Gray)
		res = bresenham(img, 1, 10, 10, 10, one(Gray))
		@fact expected == res --> true
		expected = copy(img)
		expected[:, 5] = one(Gray)
		res = bresenham(img, 1, 5, 10, 5, one(Gray))
		@fact expected == res --> true
		expected = copy(img)
		expected[1:5, 5] = one(Gray)
		res = bresenham(img, 1, 5, 5, 5, one(Gray))
		@fact expected == res --> true

		expected = copy(img)
		expected[10:9:91] = one(Gray)
		res = bresenham(img, 1, 10, 10, 1, one(Gray))
		@fact expected == res --> true
		expected = copy(img)
		expected[10:9:55] = one(Gray)
		res = bresenham(img, 10, 1, 5, 6, one(Gray))
		@fact expected == res --> true

		img = zeros(RGB, 10, 10)
		expected = copy(img)
		expected[diagind(expected)] = RGB(0.2, 0.3, 0.4)
		res = bresenham(img, 1, 1, 10, 10, RGB(0.2, 0.3, 0.4))
		@fact expected == res --> true
	end

	context("Xiaolin-Wu") do
		
	end

end