import 'package:tictactoe/domain/cell.dart';

import 'player.dart';

class Winner {
  final Player player;
  final List<CellPosition> winningMove;

  Winner(this.player, this.winningMove);
}
