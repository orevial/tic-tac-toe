import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe/domain/stat.dart';

const _statsKey = 'statistics';

class StatsDatasource {
  // TODO We should probably close this stream somewhere
  final StreamController<AllStats> _statsStreamController =
      StreamController.broadcast();

  Future<void> saveStats(AllStats stats) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(_statsKey, jsonEncode(stats.toJson()));

    _statsStreamController.add(stats);
  }

  Stream<AllStats> getStatsStream() {
    fetchStats();

    return _statsStreamController.stream;
  }

  Future<AllStats> fetchStats() async {
    final prefs = await SharedPreferences.getInstance();
    final allStatsJson = prefs.getString(_statsKey);

    final AllStats stats;
    if (allStatsJson != null && allStatsJson.isNotEmpty) {
      stats = AllStats.fromJson(
        jsonDecode(allStatsJson) as Map<String, dynamic>,
      );
    } else {
      stats = AllStats.empty();
    }

    _statsStreamController.add(stats);

    return stats;
  }
}
