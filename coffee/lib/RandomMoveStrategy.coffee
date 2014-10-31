class RandomMoveStrategy

	getCandidateMoves: (grid) ->
		emptyCells = grid.getEmptyCells()
		cellToSet = emptyCells[0]
		validValues = grid.getValidValues cellToSet
		return ({cell: cellToSet, symbol: symbol} for symbol in validValues)
