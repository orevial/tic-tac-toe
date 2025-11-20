import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/domain/board.dart';
import 'package:tictactoe/domain/grid_size.dart';
import 'package:tictactoe/domain/player.dart';
import 'package:tictactoe/services/random_bot.dart';

void main() {
  final aiBot = RandomBot();

  test('ai should choose a move randomly', () async {
    final board = Board.empty(GridSize.five);

    // We generate a few random moves based on the same board to make sure random moves are picked each time
    final bestMoves = await List.generate(
      5,
      (_) => aiBot.findBestMove(board, Player.ai),
    ).wait;
    var allMovesAreSimilar = true;

    final previousMove = bestMoves.first;
    for (int i = 1; i < bestMoves.length; i++) {
      if (bestMoves[i] != previousMove) {
        allMovesAreSimilar = false;
        continue;
      }
    }

    expect(allMovesAreSimilar, isFalse);
  });
}
