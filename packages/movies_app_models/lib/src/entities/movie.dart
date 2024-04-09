import 'package:equatable/equatable.dart';
import 'package:movies_app_models/src/entities/genre.dart';

class Movie extends Equatable {
  const Movie({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.genres,
    required this.overview,
    required this.releaseDate,
    required this.runtime,
    required this.voteAverage,
    required this.voteCount,
  });

  final int id;
  final String title;
  final String imageUrl;
  final List<Genre> genres;
  final String overview;
  final String releaseDate;
  final int? runtime;
  final double voteAverage;
  final int voteCount;

  @override
  List<Object?> get props => [
        id,
        title,
        imageUrl,
        genres,
        overview,
        releaseDate,
        runtime,
        voteAverage,
        voteCount,
      ];
}
