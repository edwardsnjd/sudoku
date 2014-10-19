class OnlyAvailableValueStrategy

	getCandidateMoves: (grid) ->
		moves = []
		
		for emptyCellIndex in grid.getEmptyCellIndices()
			validValues = grid.getValidValuesByIndex emptyCellIndex
			if validValues.length == 1
				moves.push {index: emptyCellIndex, symbol: validValues[0]}
		
		return moves
