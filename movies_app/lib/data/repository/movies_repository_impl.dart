import 'package:dio/dio.dart';
import 'package:movies_app/data/datasources/remote/remote_datasource.dart';
import 'package:movies_app/domain/repository/movies_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movies_app_models/movies_app_models.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final RemoteDatasource _remoteDatasource;

  const MoviesRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Response?, List<Movie>>> getMovies() =>
      _remoteDatasource.getMovies();

  @override
  Future<Either<Response?, Movie>> getMovie(String id) =>
      _remoteDatasource.getMovie(id);
}
