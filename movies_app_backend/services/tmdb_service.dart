import 'package:tmdb_api/tmdb_api.dart';

import '../config/config.dart';

class TmdbService {
  final tmdbWithCustomLogs = TMDB(
    ApiKeys(Config.tmdbAPIKey, 'apiReadAccessTokenv4'),
    logConfig: const ConfigLogger(
      showLogs: true,
      showErrorLogs: true,
      showInfoLogs: true,
      showUrlLogs: true,
      showWarningLogs: true,
    ),
  );

  Future<Map<dynamic, dynamic>> getMovies() =>
      tmdbWithCustomLogs.v3.trending.getTrending();

  Future<Map<dynamic, dynamic>> getMovie(int movieId) =>
      tmdbWithCustomLogs.v3.movies.getDetails(movieId);
}
