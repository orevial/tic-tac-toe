import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe/data/stats_datasource.dart';
import 'package:tictactoe/domain/stat.dart';

// TODO Decouple with DI: this should be a singleton instead
StatsDatasource statsDatasource = StatsDatasource();

final statsProvider = StreamProvider<AllStats>((ref) {
  return statsDatasource.getStatsStream();
});
