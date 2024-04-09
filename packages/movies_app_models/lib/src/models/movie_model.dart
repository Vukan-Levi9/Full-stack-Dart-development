import 'package:movies_app_models/movies_app_models.dart';
import 'package:movies_app_models/src/models/genre_model.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    required super.genres,
    required super.overview,
    required super.releaseDate,
    required super.runtime,
    required super.voteAverage,
    required super.voteCount,
  });

  factory MovieModel.fromJson(Map<String, dynamic> map) => MovieModel(
        id: map['id'] as int,
        title: map['title'] as String? ?? map['name'] as String,
        imageUrl: map['poster_path'] as String,
        genres: map['genres'] != null
            ? List<GenreModel>.from(
                (map['genres'] as List<dynamic>).map(
                  (genre) => GenreModel.fromJson(genre as Map<String, dynamic>),
                ),
              )
            : [],
        overview: map['overview'] as String,
        releaseDate:
            map['release_date'] as String? ?? map['first_air_date'] as String,
        runtime: map['runtime'] as int?,
        voteAverage: map['vote_average'] as double,
        voteCount: map['vote_count'] as int,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'imageUrl': imageUrl,
        'genres': genres,
        'overview': overview,
        'releaseDate': releaseDate,
        'runtime': runtime,
        'voteAverage': voteAverage,
        'voteCount': voteCount,
      };
}
