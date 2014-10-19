class RandomMoveStrategy

	getCandidateMoves: (grid) ->
		emptyCellIndices = grid.getEmptyCellIndices()
		indexToSet = emptyCellIndices[0]
		validValues = grid.getValidValuesByIndex(indexToSet)
		return ({index: indexToSet, symbol: symbol} for symbol in validValues)
