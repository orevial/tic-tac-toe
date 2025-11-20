import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/domain/bot_difficulty.dart';
import 'package:tictactoe/domain/cell.dart';
import 'package:tictactoe/domain/grid_size.dart';
import 'package:tictactoe/domain/player.dart';
import 'package:tictactoe/ui/game_provider.dart';

void main() {
  late ProviderSubscription<AsyncValue<GameState>> subscription;
  late ProviderContainer container;
  const GameSettings settings = GameSettings(
    gridSize: GridSize.three,
    botDifficulty: BotDifficulty.easy,
  );

  setUp(() {
    // Create a ProviderContainer to hold the state
    container = ProviderContainer();

    // Initialize the provider
    // We listen to it to ensure it stays alive and to trigger the build
    subscription = container.listen(
      gameProvider(settings),
      (previous, next) {},
    );
  });

  tearDown(() {
    subscription.close();
    container.dispose();
  });

  test('GameNotifier plays human move then waits for AI move', () async {
    // Wait for the initial build to verify initial state
    final initialState = await container.read(gameProvider(settings).future);
    expect(initialState.currentPlayer, Player.human);
    // expect(initialState.board, true);

    // Human plays at (0,0)
    await container
        .read(gameProvider(settings).notifier)
        .play(CellPosition(0, 0));

    final state = container.read(gameProvider(settings));
    final board = state.requireValue.board;

    // Verify both human and AI move have been recorded
    expect(board.markAt(0, 0), Player.human);
    expect(board.cells.any((cell) => cell.mark == Player.ai), isTrue);
    expect(board.availableMoves.length, 7);

    // Turn should be back to human (unless game over, which is impossible in 2 moves on 3x3)
    expect(state.requireValue.currentPlayer, Player.human);
  });

  test('GameNotifier resets the game', () async {
    // Initialize
    await container.read(gameProvider(settings).future);

    // Play one move and verify board is not empty
    await container
        .read(gameProvider(settings).notifier)
        .play(CellPosition(0, 0));
    expect(
      container
          .read(gameProvider(settings))
          .requireValue
          .board
          .availableMoves
          .length,
      7,
    );

    // Reset
    await container.read(gameProvider(settings).notifier).reset();

    // Assert: Board should be empty again
    final state = container.read(gameProvider(settings));
    expect(state.requireValue.board.availableMoves.length, 9);
    expect(state.requireValue.currentPlayer, Player.human);
  });
}
