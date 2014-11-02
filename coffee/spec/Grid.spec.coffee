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

	describe "getEmptyCells", ->

		it "should exist", ->
			grid = new Grid GridData.wellRestrictedCellsGrid
			expect(grid.getEmptyCells).toBeDefined()

		it "should return correct count", ->
			grid = new Grid GridData.wellRestrictedCellsGrid
			result = grid.getEmptyCells()
			expect(result.length).toBe(63)

		it "should return correct count repeatedly", ->
			grid = new Grid GridData.wellRestrictedCellsGrid
			results = [grid.getEmptyCells(), grid.getEmptyCells(), grid.getEmptyCells()]
			for result in results
				expect(result.length).toBe(63)

	describe "getValidValues", ->

		it "should exist", ->
			grid = new Grid GridData.completeGrid
			expect(grid.getValidValues).toBeDefined()

		it "should return empty array for filled cell", ->
			grid = new Grid GridData.completeGrid
			cell = grid._getCell 0,0
			result = grid.getValidValues cell
			expect(result.length).toBe(0)

		it "should return all values for unrestricted cell", ->
			grid = new Grid GridData.emptyGrid
			cell = grid._getCell 3,4
			result = grid.getValidValues cell
			expect(result.length).toBe(9)

		it "should return missing values for single value cell", ->
			grid = new Grid GridData.almostCompleteGrid
			cell = grid._getCell 8,8
			result = grid.getValidValues cell
			expect(result.length).toBe(1)
			expect(result[0]).toBe(8)

		it "should return missing values for restricted cells", ->
			grid = new Grid GridData.restrictedSquareGrid
			cell = grid._getCell 7,0
			result1 = grid.getValidValues cell
			expect(result1.length).toBe(3)
			cell = grid._getCell 0,2
			result2 = grid.getValidValues cell
			expect(result2.length).toBe(3)
			cell = grid._getCell 0,3
			result3 = grid.getValidValues cell
			expect(result3.length).toBe(7)
