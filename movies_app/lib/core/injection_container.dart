import 'package:dio/dio.dart';
import 'package:movies_app/core/constants.dart';
import 'package:movies_app/core/helpers/authentication_validator.dart';
import 'package:movies_app/data/datasources/local/local_datasource.dart';
import 'package:movies_app/data/datasources/remote/remote_datasource.dart';
import 'package:movies_app/data/repository/auth_repository_impl.dart';
import 'package:movies_app/data/repository/counter_repository_impl.dart';
import 'package:movies_app/data/repository/movies_repository_impl.dart';
import 'package:movies_app/domain/repository/auth_repository.dart';
import 'package:movies_app/domain/repository/counter_repository.dart';
import 'package:movies_app/domain/repository/movies_repository.dart';
import 'package:movies_app/presentation/bloc/bloc/movies_bloc/movies_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

class IC {
  static final getIt = GetIt.instance;

  static void setUp() {
    getIt
      ..registerLazySingleton(() => AuthenticationValidator())
      ..registerLazySingleton(() => MoviesBloc(getIt()))
      ..registerLazySingleton<MoviesRepository>(
        () => MoviesRepositoryImpl(getIt()),
      )
      ..registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(getIt(), getIt()),
      )
      ..registerLazySingleton<CounterRepository>(() => CounterRepositoryImpl())
      ..registerLazySingleton<RemoteDatasource>(
        () => RemoteDatasourceImpl(getIt(), getIt()),
      )
      ..registerLazySingleton<LocalDatasource>(
        () => LocalDatasourceImpl(getIt()),
      )
      ..registerLazySingleton(
        () => Dio(BaseOptions(baseUrl: UrlsPath.baseUrl)),
      )
      ..registerLazySingleton(
        () => const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        ),
      );
  }
}
