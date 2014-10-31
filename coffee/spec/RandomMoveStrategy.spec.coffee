describe "RandomMoveStrategy", ->

	it "should exist", ->
		expect(RandomMoveStrategy).toBeDefined()

	describe "getCandidateMoves", ->

		strategy = new RandomMoveStrategy()

		it "should exist", ->
			expect(strategy.getCandidateMoves).toBeDefined()

		it "should only suggest valid moves", ->
			grid = new Grid GridData.almostCompleteGrid

			moves = strategy.getCandidateMoves grid
			expect(moves.length).toBe(1)
			expect(moves[0].cell).toEqual({x:8,y:8})
			expect(moves[0].symbol).toBe(8)
