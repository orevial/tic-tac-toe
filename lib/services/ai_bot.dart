import 'package:tictactoe/domain/board.dart';
import 'package:tictactoe/domain/cell.dart';
import 'package:tictactoe/domain/player.dart';


abstract class AiBot {
  /// Returns the best move position for the given [player] on the [board].
  /// Returns a Future to allow for heavy computation (isolates) in the future.
  Future<CellPosition> findBestMove(Board board, Player player);
}
