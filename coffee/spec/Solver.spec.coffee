describe "Solver", ->
	invalidGrid = [
		1,1,1,1,1,1,1,1,1,
		1,1,1,1,1,1,1,1,1,
		1,1,1,1,1,1,1,1,1,
		1,1,1,1,1,1,1,1,1,
		1,1,1,1,1,1,1,1,1,
		1,1,1,1,1,1,1,1,1,
		1,1,1,1,1,1,1,1,1,
		1,1,1,1,1,1,1,1,1,
		1,1,1,1,1,1,1,1,1
	]

	invalidGrid2 = [
		1,2,3,4,5,6,7,8,9,
		1,1,1,1,1,1,1,1,1,
		1,1,1,1,1,1,1,1,1,
		1,1,1,1,1,1,1,1,1,
		1,1,1,1,1,1,1,1,1,
		1,1,1,1,1,1,1,1,1,
		1,1,1,1,1,1,1,1,1,
		1,1,1,1,1,1,1,1,1,
		1,1,1,1,1,1,1,1,1
	]

	completeGrid = [
		1,2,3,4,5,6,7,8,9,
		4,5,6,7,8,9,1,2,3,
		7,8,9,1,2,3,4,5,6,
		2,3,4,5,6,7,8,9,1,
		5,6,7,8,9,1,2,3,4,
		8,9,1,2,3,4,5,6,7,
		3,4,5,6,7,8,9,1,2,
		6,7,8,9,1,2,3,4,5,
		9,1,2,3,4,5,6,7,8
	]

	almostCompleteGrid = [
		1,2,3,4,5,6,7,8,9,
		4,5,6,7,8,9,1,2,3,
		7,8,9,1,2,3,4,5,6,
		2,3,4,5,6,7,8,9,1,
		5,6,7,8,9,1,2,3,4,
		8,9,1,2,3,4,5,6,7,
		3,4,5,6,7,8,9,1,2,
		6,7,8,9,1,2,3,4,5,
		9,1,2,3,4,5,6,7,null
	]

	mainlyCompleteGrid = [
		1,2,null,4,5,6,7,8,9,
		4,5,6,7,8,9,1,2,3,
		7,8,9,1,2,3,null,5,6,
		2,null,4,5,6,7,8,9,1,
		5,6,7,8,9,1,2,3,4,
		8,9,1,2,3,4,5,6,7,
		3,4,5,6,7,8,9,1,2,
		6,7,8,9,1,null,3,4,5,
		9,1,null,3,4,5,6,7,null
	]

	newspaperGrid = [
		null,null,null,4,null,null,2,9,null,
		4,null,null,null,null,5,null,1,null,
		5,null,1,null,2,null,null,6,null,
		null,null,null,null,null,6,null,null,3,
		null,null,null,5,4,8,null,null,null,
		8,null,null,1,null,null,null,null,null,
		null,6,null,null,7,null,5,null,9,
		null,1,null,2,null,null,null,null,8,
		null,4,8,null,null,3,null,null,null
	]

	it "should exist", ->
		expect(Solver).toBeDefined()

	describe "isValid", ->

		solver = new Solver()

		it "should exist", ->
			expect(solver.isValid).toBeDefined()

		it "should return true for complete grids", ->
			result = solver.isValid completeGrid
			expect(result).toEqual true

		it "should return false for invalid grids", ->
			result1 = solver.isValid invalidGrid
			result2 = solver.isValid invalidGrid2
			expect(result1).toEqual false
			expect(result2).toEqual false

	describe "solve", ->

		solver = new Solver()

		it "should exist", ->
			expect(solver.solve).toBeDefined()

		it "should return completed grids", ->
			result = solver.solve completeGrid
			expect(result).toEqual completeGrid

		it "should return null for invalid grids", ->
			result = solver.solve invalidGrid
			expect(result).toBeNull()

		it "should solve final missing cell", ->
			result = solver.solve almostCompleteGrid
			expect(result).toEqual completeGrid

		it "should solve mainly complete grid", ->
			result = solver.solve mainlyCompleteGrid
			expect(result).toEqual completeGrid

		it "should solve newspaper grid", ->
			result = solver.solve newspaperGrid
			expect(result).not.toBeNull()
