class PrioritisedStrategy

	constructor: (@strategies) ->

	getCandidateMoves: (grid) ->
		for strategy in @strategies
			moves = strategy.getCandidateMoves grid
			return moves if moves? and moves.length > 0
		return []
