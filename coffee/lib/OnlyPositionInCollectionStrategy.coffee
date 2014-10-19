class OnlyPositionInCollectionStrategy

	getCandidateMoves: (grid) ->
		moves = []

		for collection in grid.indexCollections

			positions = {}
			for symbol in grid.symbols
				positions[symbol] = []
			for index in collection
				for validValue in grid.getValidValuesByIndex(index)
					positions[validValue].push index

			for symbol in grid.symbols
				symbolPositions = positions[symbol]
				if symbolPositions.length is 1
					moves.push {index: symbolPositions[0], symbol: symbol}

		return moves
