import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class LocalDatasource {
  Future<void> storeToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class LocalDatasourceImpl implements LocalDatasource {
  final _tokenKey = 'token';
  final FlutterSecureStorage _storage;

  LocalDatasourceImpl(this._storage);

  @override
  Future<void> storeToken(String token) async =>
      await _storage.write(key: _tokenKey, value: token);

  @override
  Future<String?> getToken() async => _storage.read(key: _tokenKey);

  @override
  Future<void> clearToken() async => await _storage.delete(key: _tokenKey);
}
