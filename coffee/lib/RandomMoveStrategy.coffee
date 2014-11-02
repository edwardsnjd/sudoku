class RandomMoveStrategy

	getCandidateMoves: (grid) ->
		emptyCells = grid.getEmptyCells()
		cellToSet = emptyCells[0]
		validValues = grid.getValidValues cellToSet
		return ({cell: cellToSet, symbol: symbol, strategy: this.constructor.name} for symbol in validValues)
