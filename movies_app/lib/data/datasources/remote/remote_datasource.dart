import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:movies_app/data/datasources/local/local_datasource.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movies_app_models/movies_app_models.dart';

abstract class RemoteDatasource {
  Future<Either<Response?, void>> signUp(User user);
  Future<Either<Response?, void>> signIn(User user);
  Future<Either<Response?, List<Movie>>> getMovies();
  Future<Either<Response?, Movie>> getMovie(String id);
}

class RemoteDatasourceImpl implements RemoteDatasource {
  final Dio _dio;
  final LocalDatasource _localDatasource;

  RemoteDatasourceImpl(this._dio, this._localDatasource);

  Future<Map<String, String>> _getHeaders() async => {
        'Authorization': await _localDatasource.getToken() ?? '',
        'Content-Type': 'application/json',
      };

  @override
  Future<Either<Response?, void>> signUp(User user) async {
    try {
      final response = await _dio.post(
        '/signup',
        data: jsonEncode(UserModel.fromEntity(user).toJson()),
      );

      return response.statusCode == 200
          ? Either.of(none)
          : Either.left(response);
    } on DioException catch (error) {
      return Either.left(error.response);
    } on Exception catch (_) {
      return Either.left(null);
    }
  }

  @override
  Future<Either<Response?, void>> signIn(User user) async {
    try {
      final response = await _dio.post(
        '/signin',
        data: jsonEncode(UserModel.fromEntity(user).toJson()),
      );

      if (response.statusCode == 200) {
        await _localDatasource.storeToken(response.data['token']);
        return Either.of(none);
      }

      return Either.left(response);
    } on DioException catch (error) {
      return Either.left(error.response);
    } on Exception catch (_) {
      return Either.left(null);
    }
  }

  @override
  Future<Either<Response?, List<Movie>>> getMovies() async {
    try {
      final response = await _dio.get(
        '/movies',
        options: Options(headers: await _getHeaders()),
      );

      if (response.statusCode == 200) {
        final movies = response.data['data'];

        return Either.right(
          (movies['results'] as List<dynamic>)
              .map((movie) => MovieModel.fromJson(movie))
              .toList(),
        );
      }

      return Either.left(response);
    } on DioException catch (error) {
      return Either.left(error.response);
    } on Exception catch (_) {
      return Either.left(null);
    }
  }

  @override
  Future<Either<Response?, Movie>> getMovie(String id) async {
    try {
      final response = await _dio.get(
        '/movies/$id',
        options: Options(headers: await _getHeaders()),
      );

      if (response.statusCode == 200) {
        return Either.right(MovieModel.fromJson(response.data['data']));
      }

      return Either.left(response);
    } on DioException catch (error) {
      return Either.left(error.response);
    } on Exception catch (_) {
      return Either.left(null);
    }
  }
}
