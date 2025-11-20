import 'package:tictactoe/domain/cell.dart';
import 'package:tictactoe/domain/game_result.dart';
import 'package:tictactoe/domain/player.dart';
import 'package:tictactoe/domain/winner.dart';

import 'grid_size.dart';

class Board {
  final List<Cell> cells;
  final GridSize gridSize;

  Board({required this.cells, required this.gridSize})
    : assert(cells.length == gridSize.nCells, 'Board size mismatch');

  int get size => gridSize.size;

  factory Board.empty(GridSize gridSize) {
    final size = gridSize.size;
    return Board(
      gridSize: gridSize,
      cells: List.generate(
        gridSize.nCells,
        (index) => Cell(
          position: CellPosition(index ~/ size, index % size),
          mark: Player.none,
        ),
      ),
    );
  }

  Player markAt(int row, int col) => cells[row + col * gridSize.size].mark;

  Board copyWithMark(CellPosition position, Player mark) {
    final index = position.row + position.col * gridSize.size;
    final updated = [...cells]..[index] = cells[index].copyWith(mark);
    return Board(cells: updated, gridSize: gridSize);
  }

  bool get isFull => cells.every((cell) => cell.mark != Player.none);

  List<Cell> get availableMoves =>
      cells.where((cell) => cell.mark == Player.none).toList();

  GameResult? get gameResult {
    if (winner != null) {
      return winner?.player == Player.human ? GameResult.win : GameResult.lose;
    } else if (isFull) {
      return GameResult.draw;
    }

    return null;
  }

  Winner? get winner {
    // TODO Merge rows & columns check by just using an unamed index "i" ?
    // Check rows
    for (int row = 0; row < size; row++) {
      final rowCells = List.generate(size, (col) => CellPosition(col, row));
      final rowMarks = rowCells
          .map((cell) => markAt(cell.row, cell.col))
          .toList();
      final winner = _hasWinnerOnLine(rowMarks);
      if (winner != null) {
        return Winner(winner, rowCells);
      }
    }

    // Check columns
    for (int col = 0; col < size; col++) {
      final columnCells = List.generate(size, (row) => CellPosition(col, row));
      final columnMarks = columnCells
          .map((cell) => markAt(cell.row, cell.col))
          .toList();
      final winner = _hasWinnerOnLine(columnMarks);
      if (winner != null) {
        return Winner(winner, columnCells);
      }
    }

    // Check first diagonal
    final diagonalCells = List.generate(size, (i) => CellPosition(i, i));
    final diagonalMarks = diagonalCells
        .map((cell) => markAt(cell.row, cell.col))
        .toList();
    final diagonalWinner = _hasWinnerOnLine(diagonalMarks);
    if (diagonalWinner != null) {
      return Winner(diagonalWinner, diagonalCells);
    }

    // Check antidiagonal
    final antidiagonalCells = List.generate(
      size,
      (i) => CellPosition(size - i - 1, i),
    );
    final antidiagonalMarks = antidiagonalCells
        .map((cell) => markAt(cell.row, cell.col))
        .toList();
    final antidiagonalWinner = _hasWinnerOnLine(antidiagonalMarks);
    if (antidiagonalWinner != null) {
      return Winner(antidiagonalWinner, antidiagonalCells);
    }

    return null;
  }

  Player? _hasWinnerOnLine(List<Player> marks) {
    if (marks.every((mark) => mark == Player.human) ||
        marks.every((mark) => mark == Player.ai)) {
      return marks.first;
    }
    return null;
  }

  Board reset() {
    return Board.empty(gridSize);
  }

  @override
  String toString() {
    var str = "";
    for (int row = 0; row < size; row++) {
      var rowString = "| ";
      for (int col = 0; col < size; col++) {
        final mark = markAt(row, col);
        rowString += "${_markSymbol(mark)} | ";
      }
      str += "$rowString\n";
    }

    return str;
  }

  String _markSymbol(Player mark) => switch (mark) {
    Player.none => " ",
    Player.human => "x",
    Player.ai => "o",
  };
}
