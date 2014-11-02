describe "OnlyPositionInCollectionStrategy", ->

	it "should exist", ->
		expect(OnlyPositionInCollectionStrategy).toBeDefined()

	describe "getCandidateMoves", ->

		strategy = new OnlyPositionInCollectionStrategy()

		it "should exist", ->
			expect(strategy.getCandidateMoves).toBeDefined()

		it "should find squares are the only position in collection", ->
			gridWithHoles = new Grid GridData.onePositionInCollectionGrid

			moves = strategy.getCandidateMoves gridWithHoles
			expect(moves.length).toBe 1
			expect(moves[0].cell).toBe gridWithHoles._getCell 8,0
			expect(moves[0].symbol).toBe 9
