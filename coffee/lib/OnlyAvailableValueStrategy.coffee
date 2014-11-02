class OnlyAvailableValueStrategy

	getCandidateMoves: (grid) ->
		moves = []
		
		for emptyCell in grid.getEmptyCells()
			validValues = grid.getValidValues emptyCell
			if validValues.length == 1
				moves.push {
					cell: emptyCell
					symbol: validValues[0]
					strategy: this.constructor.name
				}
		
		return moves
