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
			result = grid.getValidValues({x:0,y:0})
			expect(result.length).toBe(0)

		it "should return all values for unrestricted cell", ->
			grid = new Grid GridData.emptyGrid
			result = grid.getValidValues({x:3,y:4})
			expect(result.length).toBe(9)

		it "should return missing values for single value cell", ->
			grid = new Grid GridData.almostCompleteGrid
			result = grid.getValidValues({x:8,y:8})
			expect(result.length).toBe(1)
			expect(result[0]).toBe(8)

		it "should return missing values for restricted cells", ->
			grid = new Grid GridData.restrictedSquareGrid
			result1 = grid.getValidValues({x:7,y:0})
			expect(result1.length).toBe(3)
			result2 = grid.getValidValues({x:0,y:2})
			expect(result2.length).toBe(3)
			result3 = grid.getValidValues({x:0,y:3})
			expect(result3.length).toBe(7)
