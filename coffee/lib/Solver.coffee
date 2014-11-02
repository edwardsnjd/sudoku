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
			# Make a move then recurse
			# NB This will obviously gobble stack space
			grid.setCellValue move.cell, move.symbol
			solvedGrid = @solve grid
			# If we found a solution then return it
			return solvedGrid if solvedGrid?
			# No valid solution found with this move so back it out
			grid.setCellValue move.cell, null

		# Failed to find a move leading to a valid solution
		return null

this.Solver = Solver