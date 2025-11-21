import 'package:tictactoe/domain/bot_difficulty.dart';
import 'package:tictactoe/domain/grid_size.dart';

class AllStats {
  final List<ConfigStat> stats;

  AllStats({required this.stats});

  factory AllStats.empty() {
    final allStats = <ConfigStat>[];
    for (final botDifficulty in BotDifficulty.values) {
      for (final gridSize in GridSize.values) {
        allStats.add(
          ConfigStat.empty(botDifficulty: botDifficulty, gridSize: gridSize),
        );
      }
    }

    return AllStats(stats: allStats);
  }

  ConfigStat getStat(BotDifficulty botDifficulty, GridSize gridSize) {
    return stats.firstWhere(
      (stat) =>
          stat.botDifficulty == botDifficulty && stat.gridSize == gridSize,
      orElse: () =>
          ConfigStat.empty(botDifficulty: botDifficulty, gridSize: gridSize),
    );
  }

  AllStats copyWithNewWin(BotDifficulty botDifficulty, GridSize gridSize) =>
      copyWithNewStat(
        botDifficulty,
        gridSize,
        onCopy: (oldStat) => oldStat.copyWith(nWins: oldStat.nWins + 1),
      );

  AllStats copyWithNewLose(BotDifficulty botDifficulty, GridSize gridSize) =>
      copyWithNewStat(
        botDifficulty,
        gridSize,
        onCopy: (oldStat) => oldStat.copyWith(nLoses: oldStat.nLoses + 1),
      );

  AllStats copyWithNewDraw(BotDifficulty botDifficulty, GridSize gridSize) =>
      copyWithNewStat(
        botDifficulty,
        gridSize,
        onCopy: (oldStat) => oldStat.copyWith(nDraws: oldStat.nDraws + 1),
      );

  AllStats copyWithNewStat(
    BotDifficulty botDifficulty,
    GridSize gridSize, {
    required ConfigStat Function(ConfigStat) onCopy,
  }) {
    final index = stats.indexWhere(
      (stat) =>
          stat.botDifficulty == botDifficulty && stat.gridSize == gridSize,
    );

    final List<ConfigStat> newStats;
    if (index == -1) {
      newStats = [
        ...stats,
        onCopy(
          ConfigStat.empty(botDifficulty: botDifficulty, gridSize: gridSize),
        ),
      ];
    } else {
      newStats = [...stats]..[index] = onCopy(stats[index]);
    }

    return AllStats(stats: newStats);
  }

  Map<String, dynamic> toJson() {
    return {'stats': stats.map((x) => x.toJson()).toList()};
  }

  factory AllStats.fromJson(Map<String, dynamic> map) {
    return AllStats(
      stats: List<ConfigStat>.from(
        (map['stats'] as List<dynamic>).map<ConfigStat>(
          (x) => ConfigStat.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}

class ConfigStat {
  BotDifficulty botDifficulty;
  GridSize gridSize;
  int nWins;
  int nLoses;
  int nDraws;

  int get totalGames => nWins + nLoses + nDraws;

  int get winsPercentage =>
      totalGames == 0 ? 0 : (nWins / totalGames * 100).round();

  int get losesPercentage =>
      totalGames == 0 ? 0 : (nLoses / totalGames * 100).round();

  int get drawsPercentage =>
      totalGames == 0 ? 0 : (nDraws / totalGames * 100).round();

  ConfigStat({
    required this.botDifficulty,
    required this.gridSize,
    required this.nWins,
    required this.nLoses,
    required this.nDraws,
  });

  factory ConfigStat.empty({
    required BotDifficulty botDifficulty,
    required GridSize gridSize,
  }) => ConfigStat(
    botDifficulty: botDifficulty,
    gridSize: gridSize,
    nWins: 0,
    nLoses: 0,
    nDraws: 0,
  );

  ConfigStat copyWith({int? nWins, int? nLoses, int? nDraws}) {
    return ConfigStat(
      botDifficulty: botDifficulty,
      gridSize: gridSize,
      nWins: nWins ?? this.nWins,
      nLoses: nLoses ?? this.nLoses,
      nDraws: nDraws ?? this.nDraws,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'botDifficulty': botDifficulty.name,
      'gridSize': gridSize.name,
      'nWins': nWins,
      'nLoses': nLoses,
      'nDraws': nDraws,
    };
  }

  factory ConfigStat.fromJson(Map<String, dynamic> map) {
    return ConfigStat(
      botDifficulty: BotDifficulty.values.byName(map['botDifficulty']),
      gridSize: GridSize.values.byName(map['gridSize']),
      nWins: map['nWins'] as int,
      nLoses: map['nLoses'] as int,
      nDraws: map['nDraws'] as int,
    );
  }
}
