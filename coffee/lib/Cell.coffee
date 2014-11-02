class Cell

	constructor: (@x,@y) ->
		@id = Cell.getId @x,@y
		@value = null

Cell.getId = (x,y) -> "x#{x}y#{y}"
