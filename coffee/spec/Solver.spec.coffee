describe "Solver", ->

	it "should exist", ->
		expect(Solver).toBeDefined()

	describe "solve", ->

		solver = new Solver()

		it "should exist", ->
			expect(solver.solve).toBeDefined()

		it "should return completed grids", ->
			result = solver.solve new Grid(GridData.completeGrid)
			expect(result.getData()).toEqual GridData.completeGrid

		it "should return null for invalid grids", ->
			result = solver.solve new Grid(GridData.invalidRowGrid)
			expect(result).toBeNull()

		it "should solve final missing cell", ->
			result = solver.solve new Grid(GridData.almostCompleteGrid)
			expect(result.getData()).toEqual GridData.completeGrid

		it "should solve mainly complete grid", ->
			result = solver.solve new Grid(GridData.mainlyCompleteGrid)
			expect(result.getData()).toEqual GridData.completeGrid

		it "should solve newspaper grid", ->
			result = solver.solve new Grid(GridData.newspaperGrid)
			expect(result.getData()).not.toBeNull()
