import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe/domain/board.dart';
import 'package:tictactoe/domain/bot_difficulty.dart';
import 'package:tictactoe/domain/cell.dart';
import 'package:tictactoe/domain/game_result.dart';
import 'package:tictactoe/domain/grid_size.dart';
import 'package:tictactoe/domain/player.dart';
import 'package:tictactoe/services/negamax_bot.dart';
import 'package:tictactoe/services/random_bot.dart';
import 'package:tictactoe/ui/stats_provider.dart';

const _aiTurnMinDelay = 750;

class GameSettings {
  final GridSize gridSize;
  final BotDifficulty botDifficulty;

  const GameSettings({required this.gridSize, required this.botDifficulty});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameSettings &&
          runtimeType == other.runtimeType &&
          gridSize == other.gridSize &&
          botDifficulty == other.botDifficulty;

  @override
  int get hashCode => gridSize.hashCode ^ botDifficulty.hashCode;
}

class GameState {
  final Board board;
  final Player currentPlayer;
  final BotDifficulty botDifficulty;
  final GameResult? gameResult;

  const GameState({
    required this.board,
    required this.currentPlayer,
    required this.botDifficulty,
    this.gameResult,
  });

  GameState copyWith({
    Board? board,
    Player? currentPlayer,
    GameResult? gameResult,
  }) {
    return GameState(
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      gameResult: gameResult ?? this.gameResult,
      botDifficulty: botDifficulty,
    );
  }
}

final gameProvider = AsyncNotifierProvider.autoDispose
    .family<GameNotifier, GameState, GameSettings>(GameNotifier.new);

class GameNotifier extends AsyncNotifier<GameState> {
  final GameSettings settings;

  GameNotifier(this.settings);

  @override
  Future<GameState> build() async {
    return GameState(
      board: Board.empty(settings.gridSize),
      currentPlayer: Player.human,
      botDifficulty: settings.botDifficulty,
    );
  }

  Future<void> play(CellPosition position) async {
    if (!state.hasValue) {
      return;
    }

    // TODO Add error handling
    var actualState = state.requireValue;

    // Check if move is valid
    if (actualState.board.markAt(position.row, position.col) != Player.none) {
      return;
    }
    if (actualState.board.gameResult != null) return;

    // 1. Human Move
    final newBoard = actualState.board.copyWithMark(
      position,
      actualState.currentPlayer,
    );

    actualState = actualState.copyWith(
      board: newBoard,
      currentPlayer: Player.ai,
      gameResult: newBoard.gameResult,
    );
    state = AsyncValue.data(actualState);

    // Check for game over after human move
    if (actualState.gameResult != null) {
      await _actOnGameFinished(actualState.board.gameResult!);
      return;
    }

    // 2. AI Move
    final aiBot = switch (settings.botDifficulty) {
      BotDifficulty.easy => RandomBot(),
      BotDifficulty.hard => NegamaxBot(),
    };
    // Recalculate best move based on the new board state
    // Note: We access actualState.board again in case it changed (though it shouldn't in this flow)
    final stopwatch = Stopwatch();
    stopwatch.start();
    final aiMove = await aiBot.findBestMove(actualState.board, Player.ai);
    stopwatch.stop();

    // Small delay to make it feel more natural
    final delayDuration = Duration(
      milliseconds: _aiTurnMinDelay - stopwatch.elapsedMilliseconds,
    );
    await Future.delayed(delayDuration);

    final aiBoard = actualState.board.copyWithMark(aiMove, Player.ai);

    actualState = actualState.copyWith(
      board: aiBoard,
      currentPlayer: Player.human,
      gameResult: aiBoard.gameResult,
    );
    state = AsyncValue.data(actualState);

    // Check for game over after AI move
    if (actualState.gameResult != null) {
      await _actOnGameFinished(actualState.board.gameResult!);
      return;
    }
  }

  Future<void> reset() async {
    state = AsyncValue.data(await build());
  }

  Future<void> _actOnGameFinished(GameResult result) async {
    final currentStats = await statsDatasource.fetchStats();
    final botDifficulty = state.requireValue.botDifficulty;
    final gridSize = state.requireValue.board.gridSize;

    final newStats = switch (result) {
      GameResult.win => currentStats.copyWithNewWin(botDifficulty, gridSize),
      GameResult.lose => currentStats.copyWithNewLose(botDifficulty, gridSize),
      GameResult.draw => currentStats.copyWithNewDraw(botDifficulty, gridSize),
    };
    await statsDatasource.saveStats(newStats);
  }
}
