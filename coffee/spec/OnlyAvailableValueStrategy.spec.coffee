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

			movesFor8x0 = (move for move in moves when move.cell.x is 8 and move.cell.y is 0)
			movesFor2x2 = (move for move in moves when move.cell.x is 2 and move.cell.y is 2)
			movesFor0x8 = (move for move in moves when move.cell.x is 0 and move.cell.y is 8)
			expect(movesFor8x0.length).toBe(1)
			expect(movesFor8x0[0].symbol).toBe(9)
			expect(movesFor2x2.length).toBe(1)
			expect(movesFor2x2[0].symbol).toBe(9)
			expect(movesFor0x8.length).toBe(1)
			expect(movesFor0x8[0].symbol).toBe(9)
