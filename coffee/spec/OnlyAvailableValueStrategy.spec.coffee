describe "OnlyAvailableValueStrategy", ->

	it "should exist", ->
		expect(OnlyAvailableValueStrategy).toBeDefined()

	describe "getCandidateMoves", ->

		strategy = new OnlyAvailableValueStrategy()

		it "should exist", ->
			expect(strategy.getCandidateMoves).toBeDefined()

		it "should find squares that can only have one number in", ->
			gridWithHoles = new Grid GridData.wellRestrictedCellsGrid

			moves = strategy.getCandidateMoves gridWithHoles
			expect(moves.length).toBe(3)

			movesFor8 = (move for move in moves when move.index is 8)
			movesFor21 = (move for move in moves when move.index is 8)
			movesFor72 = (move for move in moves when move.index is 8)
			expect(movesFor8.length).toBe(1)
			expect(movesFor8[0].symbol).toBe(9)
			expect(movesFor21.length).toBe(1)
			expect(movesFor21[0].symbol).toBe(9)
			expect(movesFor72.length).toBe(1)
			expect(movesFor72[0].symbol).toBe(9)
