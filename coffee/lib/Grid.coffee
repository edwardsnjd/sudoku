class Grid

	constructor: (data) ->
		@symbols = [1,2,3,4,5,6,7,8,9]

		@order = 3
		@dimension = @order * @order

		# Create cells
		@_allCells = []
		@_cellsById = {}
		for x in [0...@dimension]
			for y in [0...@dimension]
				cell = new Cell x,y
				@_allCells.push cell
				@_cellsById[cell.id] = cell

		# Add cells to collections
		@collections = []
		for y in [0...@dimension]
			@collections.push (@_getCell(x,y) for x in [0...@dimension])
		for x in [0...@dimension]
			@collections.push (@_getCell(x,y) for y in [0...@dimension])
		for boxX in [0...@order]
			for boxY in [0...@order]
				cellsInThisBox = []
				startX = boxX * @order
				startY = boxY * @order
				for x in [startX...startX+@order]
					for y in [startY...startY+@order]
						cellsInThisBox.push @_getCell(x,y)
				@collections.push cellsInThisBox

		# Index the collections by cell
		@_collectionsByCell = {}
		for cell in @_allCells
			@_collectionsByCell[cell.id] = (
				collection for collection in @collections when Utils.contains(collection, cell)
			)

		# Set data
		@setData data

	isValid: ->
		# Look for duplicate symbols in each collection
		for symbol in @symbols
			for collection in @collections
				cellsWithSymbol = @_getCellsMatchingSymbol collection, symbol
				return false if cellsWithSymbol.length > 1
		# No duplicates, so it's a valid state
		return true

	isFilled: -> return @getEmptyCells().length is 0

	getEmptyCells: -> return @_emptyCells

	setCellValue: (cell, value) ->
		cell.value = value
		@_updateEmptyCells()

	setData: (data) ->
		if data?
			if not data.length is @dimension * @dimension
				throw "Invalid data array"

			for x in [0...@dimension]
				for y in [0...@dimension]
					index = @dimension*y + x
					@_getCell(x,y).value = data[index]

		@_updateEmptyCells()

	getValidValues: (cell) ->
		return [] if cell.value?

		getSymbolsUsed = (cells) => cell.value for cell in cells when cell.value?

		relevantCollections = @_collectionsByCell[cell.id]
		symbolsUsedByRelevantCollection = (getSymbolsUsed cells for cells in relevantCollections)
		usedSymbols = [].concat.apply [], symbolsUsedByRelevantCollection
		unusedSymbols = (symbol for symbol in @symbols when not Utils.contains(usedSymbols, symbol))

		return unusedSymbols

	getData: () ->
		results = []
		for y in [0...@dimension]
			for x in [0...@dimension]
				cellId = Cell.getId(x,y)
				results.push @_cellsById[cellId].value
		return results

	_getCell: (x,y) -> @_cellsById[Cell.getId(x,y)]

	_updateEmptyCells: () -> @_emptyCells = @_getCellsMatchingSymbol @_allCells, null

	_getCellsMatchingSymbol: (cells, symbol) -> return (cell for cell in cells when cell.value is symbol)

this.Grid = Grid