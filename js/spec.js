// Generated by CoffeeScript 1.7.1
(function() {
  var Cell, Grid, OnlyAvailableValueStrategy, OnlyPositionInCollectionStrategy, PrioritisedStrategy, RandomMoveStrategy, Solver, Utils;

  Cell = (function() {
    function Cell(x, y) {
      this.x = x;
      this.y = y;
      this.id = Cell.getId(this.x, this.y);
      this.value = null;
    }

    return Cell;

  })();

  Cell.getId = function(x, y) {
    return "x" + x + "y" + y;
  };

  Grid = (function() {
    function Grid(data) {
      var boxX, boxY, cell, cellsInThisBox, collection, startX, startY, x, y, _i, _j, _k, _l, _len, _m, _n, _o, _p, _q, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8;
      this.symbols = [1, 2, 3, 4, 5, 6, 7, 8, 9];
      this.order = 3;
      this.dimension = this.order * this.order;
      this._allCells = [];
      this._cellsById = {};
      for (x = _i = 0, _ref = this.dimension; 0 <= _ref ? _i < _ref : _i > _ref; x = 0 <= _ref ? ++_i : --_i) {
        for (y = _j = 0, _ref1 = this.dimension; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; y = 0 <= _ref1 ? ++_j : --_j) {
          cell = new Cell(x, y);
          this._allCells.push(cell);
          this._cellsById[cell.id] = cell;
        }
      }
      this.collections = [];
      for (y = _k = 0, _ref2 = this.dimension; 0 <= _ref2 ? _k < _ref2 : _k > _ref2; y = 0 <= _ref2 ? ++_k : --_k) {
        this.collections.push((function() {
          var _l, _ref3, _results;
          _results = [];
          for (x = _l = 0, _ref3 = this.dimension; 0 <= _ref3 ? _l < _ref3 : _l > _ref3; x = 0 <= _ref3 ? ++_l : --_l) {
            _results.push(this._getCell(x, y));
          }
          return _results;
        }).call(this));
      }
      for (x = _l = 0, _ref3 = this.dimension; 0 <= _ref3 ? _l < _ref3 : _l > _ref3; x = 0 <= _ref3 ? ++_l : --_l) {
        this.collections.push((function() {
          var _m, _ref4, _results;
          _results = [];
          for (y = _m = 0, _ref4 = this.dimension; 0 <= _ref4 ? _m < _ref4 : _m > _ref4; y = 0 <= _ref4 ? ++_m : --_m) {
            _results.push(this._getCell(x, y));
          }
          return _results;
        }).call(this));
      }
      for (boxX = _m = 0, _ref4 = this.order; 0 <= _ref4 ? _m < _ref4 : _m > _ref4; boxX = 0 <= _ref4 ? ++_m : --_m) {
        for (boxY = _n = 0, _ref5 = this.order; 0 <= _ref5 ? _n < _ref5 : _n > _ref5; boxY = 0 <= _ref5 ? ++_n : --_n) {
          cellsInThisBox = [];
          startX = boxX * this.order;
          startY = boxY * this.order;
          for (x = _o = startX, _ref6 = startX + this.order; startX <= _ref6 ? _o < _ref6 : _o > _ref6; x = startX <= _ref6 ? ++_o : --_o) {
            for (y = _p = startY, _ref7 = startY + this.order; startY <= _ref7 ? _p < _ref7 : _p > _ref7; y = startY <= _ref7 ? ++_p : --_p) {
              cellsInThisBox.push(this._getCell(x, y));
            }
          }
          this.collections.push(cellsInThisBox);
        }
      }
      this._collectionsByCell = {};
      _ref8 = this._allCells;
      for (_q = 0, _len = _ref8.length; _q < _len; _q++) {
        cell = _ref8[_q];
        this._collectionsByCell[cell.id] = (function() {
          var _len1, _r, _ref9, _results;
          _ref9 = this.collections;
          _results = [];
          for (_r = 0, _len1 = _ref9.length; _r < _len1; _r++) {
            collection = _ref9[_r];
            if (Utils.contains(collection, cell)) {
              _results.push(collection);
            }
          }
          return _results;
        }).call(this);
      }
      this.setData(data);
    }

    Grid.prototype.isValid = function() {
      var cellsWithSymbol, collection, symbol, _i, _j, _len, _len1, _ref, _ref1;
      _ref = this.symbols;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        symbol = _ref[_i];
        _ref1 = this.collections;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          collection = _ref1[_j];
          cellsWithSymbol = this._getCellsMatchingSymbol(collection, symbol);
          if (cellsWithSymbol.length > 1) {
            return false;
          }
        }
      }
      return true;
    };

    Grid.prototype.isFilled = function() {
      return this.getEmptyCells().length === 0;
    };

    Grid.prototype.getEmptyCells = function() {
      return this._emptyCells;
    };

    Grid.prototype.setCellValue = function(cell, value) {
      cell.value = value;
      return this._updateEmptyCells();
    };

    Grid.prototype.setData = function(data) {
      var index, x, y, _i, _j, _ref, _ref1;
      if (data != null) {
        if (!data.length === this.dimension * this.dimension) {
          throw "Invalid data array";
        }
        for (x = _i = 0, _ref = this.dimension; 0 <= _ref ? _i < _ref : _i > _ref; x = 0 <= _ref ? ++_i : --_i) {
          for (y = _j = 0, _ref1 = this.dimension; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; y = 0 <= _ref1 ? ++_j : --_j) {
            index = this.dimension * y + x;
            this._getCell(x, y).value = data[index];
          }
        }
      }
      return this._updateEmptyCells();
    };

    Grid.prototype.getValidValues = function(cell) {
      var cells, getSymbolsUsed, relevantCollections, symbol, symbolsUsedByRelevantCollection, unusedSymbols, usedSymbols;
      if (cell.value != null) {
        return [];
      }
      getSymbolsUsed = (function(_this) {
        return function(cells) {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = cells.length; _i < _len; _i++) {
            cell = cells[_i];
            if (cell.value != null) {
              _results.push(cell.value);
            }
          }
          return _results;
        };
      })(this);
      relevantCollections = this._collectionsByCell[cell.id];
      symbolsUsedByRelevantCollection = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = relevantCollections.length; _i < _len; _i++) {
          cells = relevantCollections[_i];
          _results.push(getSymbolsUsed(cells));
        }
        return _results;
      })();
      usedSymbols = [].concat.apply([], symbolsUsedByRelevantCollection);
      unusedSymbols = (function() {
        var _i, _len, _ref, _results;
        _ref = this.symbols;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          symbol = _ref[_i];
          if (!Utils.contains(usedSymbols, symbol)) {
            _results.push(symbol);
          }
        }
        return _results;
      }).call(this);
      return unusedSymbols;
    };

    Grid.prototype.getData = function() {
      var cellId, results, x, y, _i, _j, _ref, _ref1;
      results = [];
      for (y = _i = 0, _ref = this.dimension; 0 <= _ref ? _i < _ref : _i > _ref; y = 0 <= _ref ? ++_i : --_i) {
        for (x = _j = 0, _ref1 = this.dimension; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; x = 0 <= _ref1 ? ++_j : --_j) {
          cellId = Cell.getId(x, y);
          results.push(this._cellsById[cellId].value);
        }
      }
      return results;
    };

    Grid.prototype._getCell = function(x, y) {
      return this._cellsById[Cell.getId(x, y)];
    };

    Grid.prototype._updateEmptyCells = function() {
      return this._emptyCells = this._getCellsMatchingSymbol(this._allCells, null);
    };

    Grid.prototype._getCellsMatchingSymbol = function(cells, symbol) {
      var cell;
      return (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = cells.length; _i < _len; _i++) {
          cell = cells[_i];
          if (cell.value === symbol) {
            _results.push(cell);
          }
        }
        return _results;
      })();
    };

    return Grid;

  })();

  this.Grid = Grid;

  OnlyAvailableValueStrategy = (function() {
    function OnlyAvailableValueStrategy() {}

    OnlyAvailableValueStrategy.prototype.getCandidateMoves = function(grid) {
      var emptyCell, moves, validValues, _i, _len, _ref;
      moves = [];
      _ref = grid.getEmptyCells();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        emptyCell = _ref[_i];
        validValues = grid.getValidValues(emptyCell);
        if (validValues.length === 1) {
          moves.push({
            cell: emptyCell,
            symbol: validValues[0],
            strategy: this.constructor.name
          });
        }
      }
      return moves;
    };

    return OnlyAvailableValueStrategy;

  })();

  OnlyPositionInCollectionStrategy = (function() {
    function OnlyPositionInCollectionStrategy() {}

    OnlyPositionInCollectionStrategy.prototype.getCandidateMoves = function(grid) {
      var cell, cellsByValue, cellsForSymbol, collection, moves, symbol, validValue, _i, _j, _k, _l, _len, _len1, _len2, _len3, _len4, _m, _ref, _ref1, _ref2, _ref3;
      moves = [];
      _ref = grid.collections;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        collection = _ref[_i];
        cellsByValue = {};
        _ref1 = grid.symbols;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          symbol = _ref1[_j];
          cellsByValue[symbol] = [];
        }
        for (_k = 0, _len2 = collection.length; _k < _len2; _k++) {
          cell = collection[_k];
          _ref2 = grid.getValidValues(cell);
          for (_l = 0, _len3 = _ref2.length; _l < _len3; _l++) {
            validValue = _ref2[_l];
            cellsByValue[validValue].push(cell);
          }
        }
        _ref3 = grid.symbols;
        for (_m = 0, _len4 = _ref3.length; _m < _len4; _m++) {
          symbol = _ref3[_m];
          cellsForSymbol = cellsByValue[symbol];
          if (cellsForSymbol.length === 1) {
            moves.push({
              cell: cellsForSymbol[0],
              symbol: symbol,
              strategy: this.constructor.name
            });
          }
        }
      }
      return moves;
    };

    return OnlyPositionInCollectionStrategy;

  })();

  PrioritisedStrategy = (function() {
    function PrioritisedStrategy(strategies) {
      this.strategies = strategies;
    }

    PrioritisedStrategy.prototype.getCandidateMoves = function(grid) {
      var moves, strategy, _i, _len, _ref;
      _ref = this.strategies;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        strategy = _ref[_i];
        moves = strategy.getCandidateMoves(grid);
        if ((moves != null) && moves.length > 0) {
          return moves;
        }
      }
      return [];
    };

    return PrioritisedStrategy;

  })();

  RandomMoveStrategy = (function() {
    function RandomMoveStrategy() {}

    RandomMoveStrategy.prototype.getCandidateMoves = function(grid) {
      var cellToSet, emptyCells, symbol, validValues;
      emptyCells = grid.getEmptyCells();
      cellToSet = emptyCells[0];
      validValues = grid.getValidValues(cellToSet);
      return (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = validValues.length; _i < _len; _i++) {
          symbol = validValues[_i];
          _results.push({
            cell: cellToSet,
            symbol: symbol,
            strategy: this.constructor.name
          });
        }
        return _results;
      }).call(this);
    };

    return RandomMoveStrategy;

  })();

  Solver = (function() {
    function Solver() {
      var oaps, oavs, rms;
      oavs = new OnlyAvailableValueStrategy();
      oaps = new OnlyPositionInCollectionStrategy();
      rms = new RandomMoveStrategy();
      this.moveStrategy = new PrioritisedStrategy([oavs, oaps, rms]);
    }

    Solver.prototype.solve = function(grid) {
      var move, movesToTry, solvedGrid, _i, _len;
      if (!grid.isValid()) {
        return null;
      }
      if (grid.isFilled()) {
        return grid;
      }
      movesToTry = this.moveStrategy.getCandidateMoves(grid);
      for (_i = 0, _len = movesToTry.length; _i < _len; _i++) {
        move = movesToTry[_i];
        grid.setCellValue(move.cell, move.symbol);
        solvedGrid = this.solve(grid);
        if (solvedGrid != null) {
          return solvedGrid;
        }
        grid.setCellValue(move.cell, null);
      }
      return null;
    };

    return Solver;

  })();

  this.Solver = Solver;

  Utils = {
    contains: function(list, item) {
      return list.indexOf(item) >= 0;
    }
  };

  describe("Grid", function() {
    it("should exist", function() {
      return expect(Grid).toBeDefined();
    });
    describe("isValid", function() {
      it("should exist", function() {
        var grid;
        grid = new Grid(GridData.completeGrid);
        return expect(grid.isValid).toBeDefined();
      });
      it("should return true for complete grids", function() {
        var grid, result;
        grid = new Grid(GridData.completeGrid);
        result = grid.isValid();
        return expect(result).toEqual(true);
      });
      it("should return false for invalid row grids", function() {
        var grid, result;
        grid = new Grid(GridData.invalidRowGrid);
        result = grid.isValid();
        return expect(result).toEqual(false);
      });
      it("should return false for invalid column grids", function() {
        var grid, result;
        grid = new Grid(GridData.invalidColumnGrid);
        result = grid.isValid();
        return expect(result).toEqual(false);
      });
      return it("should return false for invalid cell grids", function() {
        var grid, result;
        grid = new Grid(GridData.invalidCellGrid);
        result = grid.isValid();
        return expect(result).toEqual(false);
      });
    });
    describe("getEmptyCells", function() {
      it("should exist", function() {
        var grid;
        grid = new Grid(GridData.wellRestrictedCellsGrid);
        return expect(grid.getEmptyCells).toBeDefined();
      });
      it("should return correct count", function() {
        var grid, result;
        grid = new Grid(GridData.wellRestrictedCellsGrid);
        result = grid.getEmptyCells();
        return expect(result.length).toBe(63);
      });
      return it("should return correct count repeatedly", function() {
        var grid, result, results, _i, _len, _results;
        grid = new Grid(GridData.wellRestrictedCellsGrid);
        results = [grid.getEmptyCells(), grid.getEmptyCells(), grid.getEmptyCells()];
        _results = [];
        for (_i = 0, _len = results.length; _i < _len; _i++) {
          result = results[_i];
          _results.push(expect(result.length).toBe(63));
        }
        return _results;
      });
    });
    return describe("getValidValues", function() {
      it("should exist", function() {
        var grid;
        grid = new Grid(GridData.completeGrid);
        return expect(grid.getValidValues).toBeDefined();
      });
      it("should return empty array for filled cell", function() {
        var cell, grid, result;
        grid = new Grid(GridData.completeGrid);
        cell = grid._getCell(0, 0);
        result = grid.getValidValues(cell);
        return expect(result.length).toBe(0);
      });
      it("should return all values for unrestricted cell", function() {
        var cell, grid, result;
        grid = new Grid(GridData.emptyGrid);
        cell = grid._getCell(3, 4);
        result = grid.getValidValues(cell);
        return expect(result.length).toBe(9);
      });
      it("should return missing values for single value cell", function() {
        var cell, grid, result;
        grid = new Grid(GridData.almostCompleteGrid);
        cell = grid._getCell(8, 8);
        result = grid.getValidValues(cell);
        expect(result.length).toBe(1);
        return expect(result[0]).toBe(8);
      });
      return it("should return missing values for restricted cells", function() {
        var cell, grid, result1, result2, result3;
        grid = new Grid(GridData.restrictedSquareGrid);
        cell = grid._getCell(7, 0);
        result1 = grid.getValidValues(cell);
        expect(result1.length).toBe(3);
        cell = grid._getCell(0, 2);
        result2 = grid.getValidValues(cell);
        expect(result2.length).toBe(3);
        cell = grid._getCell(0, 3);
        result3 = grid.getValidValues(cell);
        return expect(result3.length).toBe(7);
      });
    });
  });

  this.GridData = {
    emptyGrid: [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null],
    invalidRowGrid: [1, null, null, null, 1, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null],
    invalidColumnGrid: [1, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 1, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null],
    invalidCellGrid: [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 1, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 1, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null],
    restrictedSquareGrid: [1, 2, 3, 4, 5, 6, null, null, null, 4, 5, 6, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null],
    completeGrid: [1, 2, 3, 4, 5, 6, 7, 8, 9, 4, 5, 6, 7, 8, 9, 1, 2, 3, 7, 8, 9, 1, 2, 3, 4, 5, 6, 2, 3, 4, 5, 6, 7, 8, 9, 1, 5, 6, 7, 8, 9, 1, 2, 3, 4, 8, 9, 1, 2, 3, 4, 5, 6, 7, 3, 4, 5, 6, 7, 8, 9, 1, 2, 6, 7, 8, 9, 1, 2, 3, 4, 5, 9, 1, 2, 3, 4, 5, 6, 7, 8],
    almostCompleteGrid: [1, 2, 3, 4, 5, 6, 7, 8, 9, 4, 5, 6, 7, 8, 9, 1, 2, 3, 7, 8, 9, 1, 2, 3, 4, 5, 6, 2, 3, 4, 5, 6, 7, 8, 9, 1, 5, 6, 7, 8, 9, 1, 2, 3, 4, 8, 9, 1, 2, 3, 4, 5, 6, 7, 3, 4, 5, 6, 7, 8, 9, 1, 2, 6, 7, 8, 9, 1, 2, 3, 4, 5, 9, 1, 2, 3, 4, 5, 6, 7, null],
    mainlyCompleteGrid: [1, 2, null, 4, 5, 6, 7, null, 9, 4, 5, 6, 7, null, 9, 1, 2, null, 7, 8, 9, 1, 2, 3, null, 5, 6, 2, null, 4, 5, 6, 7, 8, 9, null, 5, 6, 7, 8, 9, 1, 2, 3, 4, 8, 9, null, 2, 3, null, 5, 6, null, 3, 4, 5, 6, 7, 8, 9, 1, 2, 6, 7, 8, 9, 1, null, 3, 4, null, 9, 1, null, 3, 4, 5, 6, 7, null],
    newspaperGrid: [null, null, null, 4, null, null, 2, 9, null, 4, null, null, null, null, 5, null, 1, null, 5, null, 1, null, 2, null, null, 6, null, null, null, null, null, null, 6, null, null, 3, null, null, null, 5, 4, 8, null, null, null, 8, null, null, 1, null, null, null, null, null, null, 6, null, null, 7, null, 5, null, 9, null, 1, null, 2, null, null, null, null, 8, null, 4, 8, null, null, 3, null, null, null],
    wellRestrictedCellsGrid: [1, 2, 3, 4, 5, 6, 7, 8, null, 4, 5, 6, null, null, null, null, null, null, 7, 8, null, null, null, null, null, null, null, 2, null, null, null, null, null, null, null, null, 3, null, null, null, null, null, null, null, null, 5, null, null, null, null, null, null, null, null, 6, null, null, null, null, null, null, null, null, 8, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null],
    onePositionInCollectionGrid: [1, 2, 3, 4, 5, 6, null, null, null, 4, 5, 6, null, null, null, null, null, null, 7, 8, 9, null, null, null, null, null, null, null, null, null, null, null, null, 9, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 9, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null]
  };

  describe("OnlyAvailableValueStrategy", function() {
    it("should exist", function() {
      return expect(OnlyAvailableValueStrategy).toBeDefined();
    });
    return describe("getCandidateMoves", function() {
      var strategy;
      strategy = new OnlyAvailableValueStrategy();
      it("should exist", function() {
        return expect(strategy.getCandidateMoves).toBeDefined();
      });
      return it("should find squares that can only have one number in", function() {
        var gridWithHoles, move, moves, movesFor0x8, movesFor2x2, movesFor8x0;
        gridWithHoles = new Grid(GridData.wellRestrictedCellsGrid);
        moves = strategy.getCandidateMoves(gridWithHoles);
        expect(moves.length).toBe(3);
        movesFor8x0 = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = moves.length; _i < _len; _i++) {
            move = moves[_i];
            if (move.cell.x === 8 && move.cell.y === 0) {
              _results.push(move);
            }
          }
          return _results;
        })();
        movesFor2x2 = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = moves.length; _i < _len; _i++) {
            move = moves[_i];
            if (move.cell.x === 2 && move.cell.y === 2) {
              _results.push(move);
            }
          }
          return _results;
        })();
        movesFor0x8 = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = moves.length; _i < _len; _i++) {
            move = moves[_i];
            if (move.cell.x === 0 && move.cell.y === 8) {
              _results.push(move);
            }
          }
          return _results;
        })();
        expect(movesFor8x0.length).toBe(1);
        expect(movesFor8x0[0].symbol).toBe(9);
        expect(movesFor2x2.length).toBe(1);
        expect(movesFor2x2[0].symbol).toBe(9);
        expect(movesFor0x8.length).toBe(1);
        return expect(movesFor0x8[0].symbol).toBe(9);
      });
    });
  });

  describe("OnlyPositionInCollectionStrategy", function() {
    it("should exist", function() {
      return expect(OnlyPositionInCollectionStrategy).toBeDefined();
    });
    return describe("getCandidateMoves", function() {
      var strategy;
      strategy = new OnlyPositionInCollectionStrategy();
      it("should exist", function() {
        return expect(strategy.getCandidateMoves).toBeDefined();
      });
      return it("should find squares are the only position in collection", function() {
        var gridWithHoles, moves;
        gridWithHoles = new Grid(GridData.onePositionInCollectionGrid);
        moves = strategy.getCandidateMoves(gridWithHoles);
        expect(moves.length).toBe(1);
        expect(moves[0].cell).toBe(gridWithHoles._getCell(8, 0));
        return expect(moves[0].symbol).toBe(9);
      });
    });
  });

  describe("RandomMoveStrategy", function() {
    it("should exist", function() {
      return expect(RandomMoveStrategy).toBeDefined();
    });
    return describe("getCandidateMoves", function() {
      var strategy;
      strategy = new RandomMoveStrategy();
      it("should exist", function() {
        return expect(strategy.getCandidateMoves).toBeDefined();
      });
      return it("should only suggest valid moves", function() {
        var grid, moves;
        grid = new Grid(GridData.almostCompleteGrid);
        moves = strategy.getCandidateMoves(grid);
        expect(moves.length).toBe(1);
        expect(moves[0].cell).toBe(grid._getCell(8, 8));
        return expect(moves[0].symbol).toBe(8);
      });
    });
  });

  describe("Solver", function() {
    it("should exist", function() {
      return expect(Solver).toBeDefined();
    });
    return describe("solve", function() {
      var solver;
      solver = new Solver();
      it("should exist", function() {
        return expect(solver.solve).toBeDefined();
      });
      it("should return completed grids", function() {
        var result;
        result = solver.solve(new Grid(GridData.completeGrid));
        return expect(result.getData()).toEqual(GridData.completeGrid);
      });
      it("should return null for invalid grids", function() {
        var result;
        result = solver.solve(new Grid(GridData.invalidRowGrid));
        return expect(result).toBeNull();
      });
      it("should solve final missing cell", function() {
        var result;
        result = solver.solve(new Grid(GridData.almostCompleteGrid));
        return expect(result.getData()).toEqual(GridData.completeGrid);
      });
      it("should solve mainly complete grid", function() {
        var result;
        result = solver.solve(new Grid(GridData.mainlyCompleteGrid));
        return expect(result.getData()).toEqual(GridData.completeGrid);
      });
      return it("should solve newspaper grid", function() {
        var result;
        result = solver.solve(new Grid(GridData.newspaperGrid));
        return expect(result.getData()).not.toBeNull();
      });
    });
  });

}).call(this);
