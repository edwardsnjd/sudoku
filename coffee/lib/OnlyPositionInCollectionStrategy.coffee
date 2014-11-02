class OnlyPositionInCollectionStrategy

	getCandidateMoves: (grid) ->
		moves = []

		for collection in grid.collections

			cellsByValue = {}
			for symbol in grid.symbols
				cellsByValue[symbol] = []
			for cell in collection
				for validValue in grid.getValidValues cell
					cellsByValue[validValue].push cell

			for symbol in grid.symbols
				cellsForSymbol = cellsByValue[symbol]
				if cellsForSymbol.length is 1
					moves.push {
						cell: cellsForSymbol[0]
						symbol: symbol
						strategy: this.constructor.name
					}

		return moves
