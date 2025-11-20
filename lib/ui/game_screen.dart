import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe/domain/bot_difficulty.dart';
import 'package:tictactoe/domain/cell.dart';
import 'package:tictactoe/domain/grid_size.dart';
import 'package:tictactoe/domain/player.dart';
import 'package:tictactoe/ui/game_provider.dart';
import 'package:tictactoe/ui/theme/theme.dart';
import 'package:tictactoe/ui/theme/theme_spacings.dart';
import 'package:tictactoe/ui/utils/extensions.dart';

class GameScreen extends ConsumerWidget {
  final GridSize gridSize;
  final BotDifficulty botDifficulty;

  const GameScreen({
    super.key,
    required this.gridSize,
    required this.botDifficulty,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(
      gameProvider(
        GameSettings(gridSize: gridSize, botDifficulty: botDifficulty),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.appName)),
      body: Padding(
        padding: const EdgeInsets.all(ThemeSize.xs),
        child: switch (gameState) {
          AsyncData<GameState>(:final value) => _GameBoard(ref, value),
          AsyncLoading<GameState>() => const Center(
            child: CircularProgressIndicator(),
          ),
          AsyncError<GameState>() => const Center(
            child: Text('Something went wrong'),
          ),
        },
      ),
    );
  }
}

class _GameBoard extends StatelessWidget {
  final WidgetRef ref;
  final GameState gameState;

  const _GameBoard(this.ref, this.gameState);

  @override
  Widget build(BuildContext context) {
    final board = gameState.board;
    final currentPlayer = gameState.currentPlayer;

    final turnMessage = currentPlayer == Player.human
        ? context.l10n.boardHumanPlayerTurn
        : context.l10n.boardAiPlayerTurn;

    String? resultTitle;
    String? resultMessage;
    GridCellColor? cellColor;
    if (gameState.gameResult != null) {
      if (board.winner != null) {
        cellColor = board.winner?.player == Player.human
            ? GridCellColor.green
            : GridCellColor.red;
        resultTitle = board.winner?.player == Player.human
            ? context.l10n.boardVictoryTitle
            : context.l10n.boardDefeatTitle;
        resultMessage = board.winner?.player == Player.human
            ? context.l10n.boardVictoryText
            : context.l10n.boardDefeatText;
      } else if (board.isFull) {
        resultTitle = context.l10n.boardDrawTitle;
        resultMessage = context.l10n.boardDrawText;
      }
    }

    return Column(
      children: [
        if (gameState.gameResult == null)
          Row(
            mainAxisAlignment: .center,
            children: [
              Text(turnMessage),
              if (currentPlayer == Player.ai) ...[
                Space.s,
                SizedBox.square(
                  dimension: ThemeSize.sm,
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                ),
              ],
            ],
          )
        else
          Space.custom(ThemeSize.m),
        Space.s,
        SizedBox(
          height: MediaQuery.sizeOf(context).width - ThemeSize.xs * 2,
          child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: board.gridSize.size,
            crossAxisSpacing: ThemeSize.xs,
            mainAxisSpacing: ThemeSize.xs,
            children: board.cells
                .map(
                  (cell) => GridCell(
                    cell: cell,
                    cellColor:
                        (gameState.board.winner?.winningMove.contains(
                              cell.position,
                            ) ??
                            false)
                        ? cellColor
                        : null,
                    onTap: () {
                      if (currentPlayer == Player.human &&
                          cell.mark == Player.none) {
                        ref
                            .read(
                              gameProvider(
                                GameSettings(
                                  gridSize: board.gridSize,
                                  botDifficulty: gameState.botDifficulty,
                                ),
                              ).notifier,
                            )
                            .play(cell.position);
                      }
                    },
                  ),
                )
                .toList(),
          ),
        ),
        Space.l,
        if (gameState.gameResult != null) ...[
          Text(resultTitle!, style: context.textTheme.headlineMedium),
          Space.xs,
          Text(resultMessage!),
          Space.m,
          FilledButton(
            onPressed: () {
              ref
                  .read(
                    gameProvider(
                      GameSettings(
                        gridSize: board.gridSize,
                        botDifficulty: gameState.botDifficulty,
                      ),
                    ).notifier,
                  )
                  .reset();
            },
            child: Text(context.l10n.boardPlayAgainButtonLabel),
          ),
        ],
      ],
    );
  }
}

class GridCell extends StatelessWidget {
  final Cell cell;
  final void Function() onTap;
  final GridCellColor? cellColor;

  const GridCell({
    super.key,
    required this.cell,
    required this.onTap,
    this.cellColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = switch (cellColor) {
      GridCellColor.green => Colors.green,
      GridCellColor.red => Colors.red,
      null => null,
    };

    return InkWell(
      onTap: cell.mark == Player.none ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: color?.withAlpha(100),
          borderRadius: BorderRadius.all(Radius.circular(ThemeSize.xs)),
          border: Border.all(
            // Ideally extract to theme
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(cell.mark.symbol, style: TextStyle(fontSize: 40)),
        ),
      ),
    );
  }
}

enum GridCellColor { green, red }

extension on Player {
  String get symbol => switch (this) {
    Player.none => '',
    Player.human => 'X',
    Player.ai => 'O',
  };
}
