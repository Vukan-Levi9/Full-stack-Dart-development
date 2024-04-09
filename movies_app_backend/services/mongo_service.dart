import 'package:mongo_dart/mongo_dart.dart';
import '../config/config.dart';

class MongoService {
  bool _initialized = false;
  late Db? _database;

  bool get isInitialized => _initialized;

  Db get database => _database!;

  Future<void> initializeMongo() async {
    if (!_initialized) {
      _database = await Db.create(Config.mongoDBUrl);
      _initialized = true;
    }
  }

  Future<void> open() async => _database?.open();

  Future<void> close() async => _database?.close();
}
