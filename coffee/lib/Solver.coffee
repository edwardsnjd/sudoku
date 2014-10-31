class Solver

	constructor: ->
		oavs =  new OnlyAvailableValueStrategy()
		oaps =  new OnlyPositionInCollectionStrategy()
		rms =  new RandomMoveStrategy()
		@moveStrategy = new PrioritisedStrategy [oavs, oaps, rms]

	solve: (grid) ->
		return null if not grid.isValid()
		return grid if grid.isFilled()

		# Try to solve a cell
		movesToTry = @moveStrategy.getCandidateMoves grid
		for move in movesToTry
			# Recurse. NB This will obviously gobble stack space
			newGrid = grid.clone()
			newGrid.setCellValue move.cell, move.symbol
			solvedNewGrid = @solve newGrid
			if solvedNewGrid?
				return solvedNewGrid

		# Failed to find a move leading to a valid solution
		return null

this.Solver = Solver