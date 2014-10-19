describe "Grid", ->

	it "should exist", ->
		expect(Grid).toBeDefined()

	describe "isValid", ->

		it "should exist", ->
			grid = new Grid GridData.completeGrid
			expect(grid.isValid).toBeDefined()

		it "should return true for complete grids", ->
			grid = new Grid GridData.completeGrid
			result = grid.isValid()
			expect(result).toEqual true

		it "should return false for invalid row grids", ->
			grid = new Grid GridData.invalidRowGrid
			result = grid.isValid()
			expect(result).toEqual false

		it "should return false for invalid column grids", ->
			grid = new Grid GridData.invalidColumnGrid
			result = grid.isValid()
			expect(result).toEqual false

		it "should return false for invalid cell grids", ->
			grid = new Grid GridData.invalidCellGrid
			result = grid.isValid()
			expect(result).toEqual false
