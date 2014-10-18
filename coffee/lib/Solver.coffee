class Solver
	dimension = 9
	symbols = [1,2,3,4,5,6,7,8,9]
	indexCollections = []
	allIndices = []

	constructor: () ->
		# Precalculate all indices
		for x in [0...dimension]
			for y in [0...dimension]
				allIndices.push @getCellIndex(x,y)

		# Precalculate collections of indices to check for duplicate symbols
		for y in [0...dimension]
			indexCollections.push (@getCellIndex(x,y) for x in [0...dimension])
		for x in [0...dimension]
			indexCollections.push (@getCellIndex(x,y) for y in [0...dimension])
		# TODO: Calculate the box offsets
		boxCellOffsets = [0,1,2,9,10,11,18,19,20]
		boxStartOffsets = [0,3,6,27,30,33,54,57,60]
		for box in [0...dimension]
			indexCollections.push (boxStartOffsets[box] + cellOffset for cellOffset in boxCellOffsets)

	solve: (grid) ->
		return null if not @isValid grid
		return grid if @isFilled grid

		# Try to solve a cell
		emptyCellIndices = @getEmptyCellIndices grid
		indexToSolve = emptyCellIndices[0]
		for symbol in symbols
			newGrid = grid.slice()
			newGrid[indexToSolve] = symbol
			# Recurse. NB This will obviously gobble stack space
			solvedNewGrid = @solve newGrid
			return solvedNewGrid if solvedNewGrid?

		# Failed to find a valid solution
		return null

	isValid: (grid) ->
		# Look for duplicate symbols in each collection
		for symbol in symbols
			for indices in indexCollections
				indicesWithSymbol = @getIndicesMatchingSymbol grid, indices, symbol
				return false if indicesWithSymbol.length > 1
		# No duplicates, so it's a valid state
		return true

	isFilled: (grid) ->
		emptyCellIndices = @getEmptyCellIndices grid
		return emptyCellIndices.length is 0

	getEmptyCellIndices: (grid) ->
		return @getIndicesMatchingSymbol grid, allIndices, null

	getIndicesMatchingSymbol: (grid, indices, symbol) ->
		return (index for index in indices when grid[index] is symbol)

	getCellIndex: (x,y) ->
		return dimension*y + x

this.Solver = Solver