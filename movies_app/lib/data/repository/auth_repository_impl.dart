import 'package:dio/dio.dart';
import 'package:movies_app/data/datasources/local/local_datasource.dart';
import 'package:movies_app/data/datasources/remote/remote_datasource.dart';
import 'package:movies_app/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movies_app_models/movies_app_models.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDatasource _remoteDatasource;
  final LocalDatasource _localDatasource;

  const AuthRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<Either<Response?, void>> signUp(User user) =>
      _remoteDatasource.signUp(user);

  @override
  Future<Either<Response?, void>> signIn(User user) =>
      _remoteDatasource.signIn(user);

  @override
  Future<void> signOut() => _localDatasource.clearToken();
}
