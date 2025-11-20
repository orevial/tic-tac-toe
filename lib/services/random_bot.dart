import 'dart:math';

import 'package:tictactoe/domain/board.dart';
import 'package:tictactoe/domain/cell.dart';
import 'package:tictactoe/domain/player.dart';
import 'package:tictactoe/services/ai_bot.dart';


/// A dumb bot that just pick its next move randomly
class RandomBot implements AiBot {
  final random = Random();

  @override
  Future<CellPosition> findBestMove(Board board, Player player) async {
    final nAvailableMoves = board.availableMoves.length;

    return board.availableMoves[random.nextInt(nAvailableMoves)].position;
  }
}
