Sudoku
======

Sudoku solver

Features
========

Sudoku solver with some simple strategies falling back onto brute force.

Design
======

Coffeescript implementation.

- Grid holds data and rules
- Solver uses injected strategy to find candidate moves and rolls back if a move results in failure
- Strategies suggest moves to try
	- OnlyAvailableValueStrategy looks for cells that can only contain a single value
	- OnlyPositionInCollectionStrategy looks the only position in collections that can contain a value
	- RandomMoveStrategy suggests a random valid move
	- PrioritisedStrategy is a meta strategy that tries strategies in order until one suggests moves