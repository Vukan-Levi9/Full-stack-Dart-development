import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movies_app_models/movies_app_models.dart';

abstract class AuthRepository {
  Future<Either<Response?, void>> signUp(User user);
  Future<Either<Response?, void>> signIn(User user);
  Future<void> signOut();
}
