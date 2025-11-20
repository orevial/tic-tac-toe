import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/domain/board.dart';
import 'package:tictactoe/domain/cell.dart';
import 'package:tictactoe/domain/grid_size.dart';
import 'package:tictactoe/domain/player.dart';
import 'package:tictactoe/services/negamax_bot.dart';

void main() {
  final aiBot = NegamaxBot();

  test('ai should choose the win'
      'when directly possible', () async {
    // Start board (o is the ai):
    // |  x |  x |  o |
    // |  x |  o |    |
    // | ✅ |    |    |
    final board = Board(
      cells: [
        Cell(position: CellPosition(0, 0), mark: Player.human),
        Cell(position: CellPosition(0, 1), mark: Player.human),
        Cell(position: CellPosition(0, 2), mark: Player.none),
        Cell(position: CellPosition(1, 0), mark: Player.human),
        Cell(position: CellPosition(1, 1), mark: Player.ai),
        Cell(position: CellPosition(1, 2), mark: Player.none),
        Cell(position: CellPosition(2, 0), mark: Player.ai),
        Cell(position: CellPosition(2, 1), mark: Player.none),
        Cell(position: CellPosition(2, 2), mark: Player.none),
      ],
      gridSize: GridSize.three,
    );

    final bestMove = await aiBot.findBestMove(board, Player.ai);
    expect(bestMove, CellPosition(0, 2));
  });

  test('ai should choose the win'
      'when possible in the future', () async {
    // Start board (o is the ai):
    // | x  | x  | o  |
    // |    | x  |    |
    // |    | o  | ✅ |
    final board = Board(
      cells: [
        Cell(position: CellPosition(0, 0), mark: Player.human),
        Cell(position: CellPosition(0, 1), mark: Player.none),
        Cell(position: CellPosition(0, 2), mark: Player.none),
        Cell(position: CellPosition(1, 0), mark: Player.human),
        Cell(position: CellPosition(1, 1), mark: Player.human),
        Cell(position: CellPosition(1, 2), mark: Player.ai),
        Cell(position: CellPosition(2, 0), mark: Player.ai),
        Cell(position: CellPosition(2, 1), mark: Player.none),
        Cell(position: CellPosition(2, 2), mark: Player.none),
      ],
      gridSize: GridSize.three,
    );

    final bestMove = await aiBot.findBestMove(board, Player.ai);
    expect(bestMove, CellPosition(2, 2));
  });

  test('ai should block opponent wins'
      'with any grid size', () async {
    // Start board (o is the ai):
    // | x | o | o | o |  o |
    // |   | x |   |   |  o |
    // |   |   | x |   |    |
    // |   |   |   | x |    |
    // |   |   |   |   | ✅ |
    final board = Board(
      cells: [
        Cell(position: CellPosition(0, 0), mark: Player.human),
        Cell(position: CellPosition(1, 0), mark: Player.ai),
        Cell(position: CellPosition(2, 0), mark: Player.ai),
        Cell(position: CellPosition(3, 0), mark: Player.ai),
        Cell(position: CellPosition(4, 0), mark: Player.ai),
        Cell(position: CellPosition(0, 1), mark: Player.none),
        Cell(position: CellPosition(1, 1), mark: Player.human),
        Cell(position: CellPosition(2, 1), mark: Player.none),
        Cell(position: CellPosition(3, 1), mark: Player.none),
        Cell(position: CellPosition(4, 1), mark: Player.ai),
        Cell(position: CellPosition(0, 2), mark: Player.none),
        Cell(position: CellPosition(1, 2), mark: Player.none),
        Cell(position: CellPosition(2, 2), mark: Player.human),
        Cell(position: CellPosition(3, 2), mark: Player.none),
        Cell(position: CellPosition(4, 2), mark: Player.none),
        Cell(position: CellPosition(0, 3), mark: Player.none),
        Cell(position: CellPosition(1, 3), mark: Player.none),
        Cell(position: CellPosition(2, 3), mark: Player.none),
        Cell(position: CellPosition(3, 3), mark: Player.human),
        Cell(position: CellPosition(4, 3), mark: Player.none),
        Cell(position: CellPosition(0, 4), mark: Player.none),
        Cell(position: CellPosition(1, 4), mark: Player.none),
        Cell(position: CellPosition(2, 4), mark: Player.none),
        Cell(position: CellPosition(3, 4), mark: Player.none),
        Cell(position: CellPosition(4, 4), mark: Player.none),
      ],
      gridSize: GridSize.five,
    );

    final bestMove = await aiBot.findBestMove(board, Player.ai);
    expect(bestMove, CellPosition(4, 4));
  });
}
