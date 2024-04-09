import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movies_app_models/movies_app_models.dart';

abstract class MoviesRepository {
  Future<Either<Response?, List<Movie>>> getMovies();
  Future<Either<Response?, Movie>> getMovie(String id);
}
