class OnlyPositionInCollectionStrategy

	getCandidateMoves: (grid) ->
		moves = []

		for cells in grid.collections

			positions = {}
			for symbol in grid.symbols
				positions[symbol] = []
			for cell in cells
				for validValue in grid.getValidValues cell
					positions[validValue].push cell

			for symbol in grid.symbols
				symbolPositions = positions[symbol]
				if symbolPositions.length is 1
					moves.push {cell: symbolPositions[0], symbol: symbol, strategy: this.constructor.name}

		return moves
