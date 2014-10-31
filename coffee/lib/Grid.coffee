class Grid

	constructor: (@data) ->
		@symbols = [1,2,3,4,5,6,7,8,9]

		@_order = 3
		@_dimension = @_order * @_order

		# Precalculate all indices
		@_allCells = []
		for x in [0...@_dimension]
			for y in [0...@_dimension]
				@_allCells.push {x:x,y:y}

		# Precalculate collections of indices to check for duplicate symbols
		@collections = []
		for y in [0...@_dimension]
			@collections.push ({x:x,y:y} for x in [0...@_dimension])
		for x in [0...@_dimension]
			@collections.push ({x:x,y:y} for y in [0...@_dimension])
		# Calculate the boxes' indices
		for boxX in [0...@_order]
			for boxY in [0...@_order]
				cellsInThisBox = []
				startX = boxX * @_order
				startY = boxY * @_order
				for x in [startX...startX+@_order]
					for y in [startY...startY+@_order]
						cellsInThisBox.push {x:x,y:y}
				@collections.push cellsInThisBox

	isValid: ->
		# Look for duplicate symbols in each collection
		for symbol in @symbols
			for cells in @collections
				cellsWithSymbol = @_getCellsMatchingSymbol cells, symbol
				return false if cellsWithSymbol.length > 1
		# No duplicates, so it's a valid state
		return true

	isFilled: ->
		return @getEmptyCells().length is 0

	getEmptyCells: ->
		return @_getCellsMatchingSymbol @_allCells, null

	getCellValue: (cell) ->
		index = @_getCellIndex cell
		return @data[index]

	setCellValue: (cell, value) ->
		index = @_getCellIndex cell
		@data[index] = value

	_getCellIndex: (cell) ->
		return @_dimension*cell.y + cell.x

	_getCellsMatchingSymbol: (cells, symbol) ->
		return (cell for cell in cells when @getCellValue(cell) is symbol)

	clone: ->
		return new Grid(@data.slice())

	getValidValues: (cell) ->
		return [] if @data[@_getCellIndex cell]?

		contains = (list, item) ->
			list.indexOf(item) >= 0
		containsCell = (cells, cell) ->
			for testCell in cells
				return true if testCell.x is cell.x and testCell.y is cell.y
			return false
		getSymbolsUsed = (cells) =>
			@getCellValue(cell) for cell in cells when @getCellValue(cell)?

		relevantCollections = (cells for cells in @collections when containsCell(cells, cell))
		symbolsUsedByRelevantCollection = (getSymbolsUsed cells for cells in relevantCollections)
		usedSymbols = [].concat.apply [], symbolsUsedByRelevantCollection
		unusedSymbols = (symbol for symbol in @symbols when not contains(usedSymbols, symbol))

		return unusedSymbols

this.Grid = Grid