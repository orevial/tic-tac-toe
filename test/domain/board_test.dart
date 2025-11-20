import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/domain/board.dart';
import 'package:tictactoe/domain/cell.dart';
import 'package:tictactoe/domain/game_result.dart';
import 'package:tictactoe/domain/grid_size.dart';
import 'package:tictactoe/domain/player.dart';

void main() {
  group('Board', () {
    test('Board.empty creates a board with all cells empty', () {
      final gridSize = GridSize.three;
      final board = Board.empty(gridSize);

      expect(board.size, 3);
      expect(board.cells.length, 9);
      expect(board.cells.every((cell) => cell.mark == Player.none), isTrue);
    });

    test('markAt returns the correct player at a given position', () {
      // Start board
      // | x |   |   |
      // |   | o |   |
      // |   |   | x |
      final cells = [
        Cell(position: CellPosition(0, 0), mark: Player.human),
        Cell(position: CellPosition(1, 0), mark: Player.none),
        Cell(position: CellPosition(2, 0), mark: Player.none),
        Cell(position: CellPosition(0, 1), mark: Player.none),
        Cell(position: CellPosition(1, 1), mark: Player.ai),
        Cell(position: CellPosition(2, 1), mark: Player.none),
        Cell(position: CellPosition(0, 2), mark: Player.none),
        Cell(position: CellPosition(1, 2), mark: Player.none),
        Cell(position: CellPosition(2, 2), mark: Player.human),
      ];
      final board = Board(cells: cells, gridSize: GridSize.three);

      for (var cell in cells) {
        expect(board.markAt(cell.position.row, cell.position.col), cell.mark);
      }
    });

    test('copyWithMark returns a new board with the updated cell', () {
      final gridSize = GridSize.three;
      final board1 = Board.empty(gridSize);
      final board2 = board1.copyWithMark(CellPosition(1, 1), Player.ai);

      expect(board1.markAt(1, 1), Player.none); // Immutability check
      expect(board2.markAt(1, 1), Player.ai);
      expect(board2.cells.where((c) => c.mark == Player.ai).length, 1);
    });

    group('isFull', () {
      test('returns false with an empty board', () {
        final board = Board.empty(GridSize.three);

        expect(board.isFull, isFalse);
      });

      test('returns false with a a partial board', () {
        var board = Board.empty(GridSize.three);

        board = board.copyWithMark(CellPosition(1, 1), Player.ai);

        expect(board.isFull, isFalse);
      });

      test('returns true when all cells are marked', () {
        // Start board
        // | x | o | x |
        // | o | x | o |
        // | x | o | x |
        final board = Board(
          cells: [
            Cell(position: CellPosition(0, 0), mark: Player.human),
            Cell(position: CellPosition(1, 0), mark: Player.ai),
            Cell(position: CellPosition(2, 0), mark: Player.human),
            Cell(position: CellPosition(0, 1), mark: Player.ai),
            Cell(position: CellPosition(1, 1), mark: Player.human),
            Cell(position: CellPosition(2, 1), mark: Player.ai),
            Cell(position: CellPosition(0, 2), mark: Player.human),
            Cell(position: CellPosition(1, 2), mark: Player.ai),
            Cell(position: CellPosition(2, 2), mark: Player.human),
          ],
          gridSize: GridSize.three,
        );

        expect(board.isFull, isTrue);
      });
    });

    test('availableMoves returns all empty cells', () {
      // Start board
      // | x |   |   |
      // |   | o |   |
      // |   |   | x |
      var board = Board(
        cells: [
          Cell(position: CellPosition(0, 0), mark: Player.human),
          Cell(position: CellPosition(1, 0), mark: Player.none),
          Cell(position: CellPosition(2, 0), mark: Player.none),
          Cell(position: CellPosition(0, 1), mark: Player.none),
          Cell(position: CellPosition(1, 1), mark: Player.ai),
          Cell(position: CellPosition(2, 1), mark: Player.none),
          Cell(position: CellPosition(0, 2), mark: Player.none),
          Cell(position: CellPosition(1, 2), mark: Player.none),
          Cell(position: CellPosition(2, 2), mark: Player.human),
        ],
        gridSize: GridSize.three,
      );

      expect(board.availableMoves.length, 6);

      board = board.copyWithMark(CellPosition(0, 1), Player.ai);
      expect(board.availableMoves.length, 5);
    });

    group('Winner detection', () {
      test('detects row winner', () {
        // Start board
        // | x | x | x |
        // | o | o |   |
        // |   | o |   |
        final board = Board(
          cells: [
            Cell(position: CellPosition(0, 0), mark: Player.human),
            Cell(position: CellPosition(1, 0), mark: Player.human),
            Cell(position: CellPosition(2, 0), mark: Player.human),
            Cell(position: CellPosition(0, 1), mark: Player.ai),
            Cell(position: CellPosition(1, 1), mark: Player.ai),
            Cell(position: CellPosition(2, 1), mark: Player.none),
            Cell(position: CellPosition(0, 2), mark: Player.none),
            Cell(position: CellPosition(1, 2), mark: Player.ai),
            Cell(position: CellPosition(2, 2), mark: Player.none),
          ],
          gridSize: GridSize.three,
        );

        expect(board.winner, isNotNull);
        expect(board.winner!.player, Player.human);
      });

      test('detects column winner', () {
        // Start board
        // | o | x | x |
        // | o | o | x |
        // |   | o | x |
        final board = Board(
          cells: [
            Cell(position: CellPosition(0, 0), mark: Player.ai),
            Cell(position: CellPosition(1, 0), mark: Player.human),
            Cell(position: CellPosition(2, 0), mark: Player.human),
            Cell(position: CellPosition(0, 1), mark: Player.ai),
            Cell(position: CellPosition(1, 1), mark: Player.ai),
            Cell(position: CellPosition(2, 1), mark: Player.human),
            Cell(position: CellPosition(0, 2), mark: Player.none),
            Cell(position: CellPosition(1, 2), mark: Player.ai),
            Cell(position: CellPosition(2, 2), mark: Player.human),
          ],
          gridSize: GridSize.three,
        );

        expect(board.winner, isNotNull);
        expect(board.winner!.player, Player.human);
      });

      test('detects diagonal winner', () {
        // Start board
        // | o | x | x |
        // | o | o | x |
        // | x | o | o |
        final board = Board(
          cells: [
            Cell(position: CellPosition(0, 0), mark: Player.ai),
            Cell(position: CellPosition(1, 0), mark: Player.human),
            Cell(position: CellPosition(2, 0), mark: Player.human),
            Cell(position: CellPosition(0, 1), mark: Player.ai),
            Cell(position: CellPosition(1, 1), mark: Player.ai),
            Cell(position: CellPosition(2, 1), mark: Player.human),
            Cell(position: CellPosition(0, 2), mark: Player.human),
            Cell(position: CellPosition(1, 2), mark: Player.ai),
            Cell(position: CellPosition(2, 2), mark: Player.ai),
          ],
          gridSize: GridSize.three,
        );

        expect(board.winner, isNotNull);
        expect(board.winner!.player, Player.ai);
      });

      test('detects anti-diagonal winner', () {
        // Start board
        // | o | x | x |
        // | o | x | o |
        // | x | o | o |
        final board = Board(
          cells: [
            Cell(position: CellPosition(0, 0), mark: Player.ai),
            Cell(position: CellPosition(1, 0), mark: Player.human),
            Cell(position: CellPosition(2, 0), mark: Player.human),
            Cell(position: CellPosition(0, 1), mark: Player.ai),
            Cell(position: CellPosition(1, 1), mark: Player.human),
            Cell(position: CellPosition(2, 1), mark: Player.ai),
            Cell(position: CellPosition(0, 2), mark: Player.human),
            Cell(position: CellPosition(1, 2), mark: Player.ai),
            Cell(position: CellPosition(2, 2), mark: Player.ai),
          ],
          gridSize: GridSize.three,
        );

        expect(board.winner, isNotNull);
        expect(board.winner!.player, Player.human);
      });

      test('returns null when no winner', () {
        final gridSize = GridSize.three;
        var board = Board.empty(gridSize);

        board = board.copyWithMark(CellPosition(0, 0), Player.human);
        board = board.copyWithMark(CellPosition(0, 1), Player.ai);

        expect(board.winner, isNull);
      });
    });

    group('GameResult', () {
      test('returns win when human wins', () {
        final gridSize = GridSize.three;
        var board = Board.empty(gridSize);

        board = board.copyWithMark(CellPosition(0, 0), Player.human);
        board = board.copyWithMark(CellPosition(0, 1), Player.human);
        board = board.copyWithMark(CellPosition(0, 2), Player.human);

        expect(board.gameResult, GameResult.win);
      });

      test('returns lose when ai wins', () {
        final gridSize = GridSize.three;
        var board = Board.empty(gridSize);

        board = board.copyWithMark(CellPosition(0, 0), Player.ai);
        board = board.copyWithMark(CellPosition(0, 1), Player.ai);
        board = board.copyWithMark(CellPosition(0, 2), Player.ai);

        expect(board.gameResult, GameResult.lose);
      });

      test('returns draw when board is full and no winner', () {
        // Start board
        // | o | x | o |
        // | o | o | x |
        // | x | o | x |
        final board = Board(
          cells: [
            Cell(position: CellPosition(0, 0), mark: Player.ai),
            Cell(position: CellPosition(1, 0), mark: Player.human),
            Cell(position: CellPosition(2, 0), mark: Player.ai),
            Cell(position: CellPosition(0, 1), mark: Player.ai),
            Cell(position: CellPosition(1, 1), mark: Player.ai),
            Cell(position: CellPosition(2, 1), mark: Player.human),
            Cell(position: CellPosition(0, 2), mark: Player.human),
            Cell(position: CellPosition(1, 2), mark: Player.ai),
            Cell(position: CellPosition(2, 2), mark: Player.human),
          ],
          gridSize: GridSize.three,
        );

        expect(board.isFull, isTrue);
        expect(board.winner, isNull);
        expect(board.gameResult, GameResult.draw);
      });

      test('returns null when game is in progress', () {
        final gridSize = GridSize.three;
        final board = Board.empty(gridSize);

        expect(board.gameResult, isNull);
      });
    });

    test('reset returns an empty board', () {
      final gridSize = GridSize.three;
      var board = Board.empty(gridSize);

      board = board.copyWithMark(CellPosition(0, 0), Player.human);

      final resetBoard = board.reset();
      expect(resetBoard.cells.every((c) => c.mark == Player.none), isTrue);
      expect(resetBoard.gridSize, gridSize);
    });
  });
}
