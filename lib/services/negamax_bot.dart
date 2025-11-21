import 'dart:math';

import 'package:tictactoe/domain/board.dart';
import 'package:tictactoe/domain/cell.dart';
import 'package:tictactoe/domain/player.dart';
import 'package:tictactoe/services/ai_bot.dart';

const _minScore = -9999;
const _maxScore = -_minScore;

/// A game‑solving AI based on an iterative Negamax search with depth limiting
/// and alpha‑beta pruning.
///
/// ## Overview
///
/// This AI evaluates the best move for a player on an N×N grid (3×3, 4×4, ...),
/// using the **Negamax** variant of the Minimax algorithm.
///
/// Negamax relies on the fact that Tic‑Tac‑Toe–style games are *zero‑sum*:
/// what is good for one player is equally bad for the opponent.
/// Instead of handling “max” and “min” nodes separately, Negamax simplifies
/// the logic by flipping the sign of the score at each depth:
///
/// ```
/// score = -negamax(nextState, opponent)
/// ```
///
/// The algorithm explores all possible future states, computes their scores,
/// and selects the move that leads to the best guaranteed outcome.
///
///
/// ## Iterative Implementation
///
/// Instead of using recursion — which quickly leads to `StackOverflowError`
/// for board sizes above 3×3 — this AI uses an **explicit stack of frames** to
/// simulate recursion.
///
/// This makes the algorithm stable for deeper trees and prevents crashes in
/// Dart, which does not support tail‑call optimization.
///
///
/// ## Depth Limiting
///
/// A full search on large grids (4×4, 5×5…) becomes combinatorially explosive.
/// To keep computation bounded and responsive, the AI introduces a configurable
/// **maximum depth cutoff**.
///
/// When the search reaches this depth:
///
/// * the node is treated as “non‑terminal”
/// * the algorithm stops exploring deeper
/// * a neutral/heuristic score is returned
///
/// This allows the AI to play “reasonably well” even when a full computation is
/// impossible.
///
///
/// ## Alpha–Beta Pruning
///
/// To further reduce the number of explored nodes, the AI implements
/// **alpha‑beta pruning**, which tracks:
///
/// * **α (alpha)** — the best score the current player can guarantee
/// * **β (beta)** — the best score the opponent can force
///
/// Whenever the window becomes invalid (`alpha ≥ beta`), the remaining
/// branches of that subtree are **pruned**, since they cannot influence the
/// final result.
///
/// Alpha‑beta dramatically improves performance and allows deeper search even
/// on 4×4 boards.
///
///
/// ## Potential Future Improvements
///
/// Several optimizations can further strengthen the AI:
///
/// * **Heuristic Board Evaluation**
///   Instead of returning a neutral score at depth cutoff, implement heuristics:
///   - number of aligned marks in a row/column/diagonal
///   - center or corner occupation bonuses
///   - blocking threats (e.g., opponent almost winning)
///
/// * **Move Ordering**
///   Trying “strong” moves first (center, corners) increases pruning efficiency.
///
/// * **Iterative Deepening**
///   Search depth 1, then 2, then 3… until time runs out (common in chess engines).
///
/// * **Transposition Tables**
///   Cache previously encountered board states (Zobrist hashing) to avoid
///   recomputing equivalent positions.
///
/// * **Parallel or Isolate‑based Computation**
///   Running the AI inside a Dart `Isolate` allows deep thinking without
///   blocking the Flutter UI thread.
///
/// * **Difficulty Levels**
///   Lower difficulty: low depth limit + randomization
///   High difficulty: deep search + heuristics + pruning
///
///
/// ## Summary
///
/// This class provides a stable, scalable, and efficient Negamax‑based AI
/// suitable for classic Tic‑Tac‑Toe and larger grid variants.
/// Depth‑limiting and alpha‑beta pruning ensure predictable performance, while
/// the architecture leaves room for advanced AI techniques in the future.
///
///
/// Usage:
/// ```dart
/// final move = AiEngine.getBestMove(board, PlayerMark.x);
/// ```
///
class NegamaxBot implements AiBot {
  @override
  Future<CellPosition> findBestMove(Board board, Player player) async {
    CellPosition? bestMove;
    int bestScore = _minScore;

    for (final move in board.availableMoves) {
      final nextBoard = board.copyWithMark(move.position, player);
      final score = -_negamax(nextBoard, player.opponent);
      if (score > bestScore) {
        bestScore = score;
        bestMove = move.position;
      }
    }

    return bestMove!;
  }

  static int _negamax(Board rootBoard, Player rootPlayer) {
    final stack = <_NegamaxFrame>[
      _NegamaxFrame(
        board: rootBoard,
        player: rootPlayer,
        depth: 0,
        alpha: _minScore,
        beta: _maxScore,
      ),
    ];
    final maxDepth = _maxDepth(rootBoard);

    while (stack.isNotEmpty) {
      final frame = stack.last;

      final winner = frame.board.winner?.player;
      final isCutOff = frame.depth > maxDepth;

      if (winner != null || frame.board.isFull || isCutOff) {
        stack.removeLast();

        final result = switch (winner) {
          Player.human || Player.ai => (winner == frame.player) ? 1 : -1,
          _ => 0,
        };

        if (stack.isNotEmpty) {
          final parent = stack.last;
          final negated = -result;

          parent.scores.add(negated);
          parent.alpha = max(parent.alpha, negated);

          // Prune if necessary
          if (parent.alpha >= parent.beta) {
            stack.removeLast();
          }
        } else {
          return result;
        }
        continue;
      }

      // If all moves evaluated → collapse
      if (frame.moveIndex >= frame.moves.length) {
        final best = frame.scores.isNotEmpty
            ? frame.scores.reduce((a, b) => a > b ? a : b)
            : 0;
        stack.removeLast();

        if (stack.isNotEmpty) {
          final parent = stack.last;
          final negated = -best;
          parent.scores.add(negated);
          parent.alpha = max(parent.alpha, negated);

          // Prune
          if (parent.alpha >= parent.beta) {
            stack.removeLast();
          }
        } else {
          return best;
        }
        continue;
      }

      final move = frame.moves[frame.moveIndex++];
      final nextBoard = frame.board.copyWithMark(move.position, frame.player);
      final nextPlayer = frame.player.opponent;

      stack.add(
        _NegamaxFrame(
          board: nextBoard,
          player: nextPlayer,
          depth: frame.depth + 1,
          alpha: -frame.beta,
          beta: -frame.alpha,
        ),
      );
    }

    throw StateError('Unexpected termination');
  }

  // We need to limit the exploration depth to avoid very long searches
  static int _maxDepth(Board board) {
    final availableMoves = board.availableMoves.length;

    return switch (availableMoves) {
      <= 7 => 10,
      <= 8 => 6,
      <= 10 => 5,
      <= 12 => 4,
      <= 20 => 3,
      <= 30 => 2,
      _ => 1,
    };
  }
}

class _NegamaxFrame {
  final Board board;
  final Player player;
  final int depth;
  final List<Cell> moves;
  final List<int> scores = [];
  int moveIndex = 0;
  int? bestScore;
  int alpha;
  int beta;

  _NegamaxFrame({
    required this.board,
    required this.player,
    required this.depth,
    required this.alpha,
    required this.beta,
  }) : moves = board.availableMoves;
}
