
import 'package:tictactoe/domain/player.dart';

class CellPosition {
  final int row;
  final int col;

  CellPosition(this.col, this.row);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CellPosition &&
              runtimeType == other.runtimeType &&
              row == other.row &&
              col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;

  @override
  String toString() {
    return 'CellPosition(row: $row, col: $col)';
  }
}

class Cell {
  final CellPosition position;
  final Player mark;

  Cell({required this.position, required this.mark});

  Cell copyWith(Player mark) => Cell(position: position, mark: mark);
}
