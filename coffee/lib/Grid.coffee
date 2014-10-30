class Grid
	
	constructor: (@data) ->
		@order = 3
		@dimension = @order * @order
		@symbols = [1,2,3,4,5,6,7,8,9]

		# Precalculate all indices
		@allIndices = []
		for x in [0...@dimension]
			for y in [0...@dimension]
				@allIndices.push @getCellIndex(x,y)

		# Precalculate collections of indices to check for duplicate symbols
		@indexCollections = []
		for y in [0...@dimension]
			@indexCollections.push (@getCellIndex(x,y) for x in [0...@dimension])
		for x in [0...@dimension]
			@indexCollections.push (@getCellIndex(x,y) for y in [0...@dimension])
		# Calculate the boxes' indices
		for boxX in [0...@order]
			for boxY in [0...@order]
				indicesForThisBox = []
				startX = boxX * @order
				startY = boxY * @order
				for x in [startX...startX+@order]
					for y in [startY...startY+@order]
						indicesForThisBox.push @getCellIndex(x,y)
				@indexCollections.push indicesForThisBox

	isValid: ->
		# Look for duplicate symbols in each collection
		for symbol in @symbols
			for indices in @indexCollections
				indicesWithSymbol = @getIndicesMatchingSymbol indices, symbol
				return false if indicesWithSymbol.length > 1
		# No duplicates, so it's a valid state
		return true

	isFilled: ->
		return @getEmptyCellIndices().length is 0

	getEmptyCellIndices: ->
		return @getIndicesMatchingSymbol @allIndices, null

	getIndicesMatchingSymbol: (indices, symbol) ->
		return (index for index in indices when @data[index] is symbol)

	getCellIndex: (x,y) ->
		return @dimension*y + x

	clone: ->
		return new Grid(@data.slice())

this.Grid = Grid