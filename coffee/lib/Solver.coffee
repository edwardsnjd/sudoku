class Solver

	solve: (grid) ->
		return null if not grid.isValid()
		return grid if grid.isFilled()

		# Try to solve a cell
		movesToTry = @getCandidateMoves grid
		for move in movesToTry
			# Recurse. NB This will obviously gobble stack space
			newGrid = grid.clone()
			newGrid.data[move.index] = move.symbol
			solvedNewGrid = @solve newGrid
			return solvedNewGrid if solvedNewGrid?

		# Failed to find a move leading to a valid solution
		return null

	getCandidateMoves: (grid) ->
		emptyCellIndices = grid.getEmptyCellIndices()
		indexToSet = emptyCellIndices[0]
		return ({index: indexToSet, symbol: symbol} for symbol in grid.symbols)

this.Solver = Solver