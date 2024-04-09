import 'package:dart_frog/dart_frog.dart';
import 'package:movies_app_backend/counter/middleware/counter_provider.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as shelf;

import '../helpers/authorization.dart';
import '../services/mongo_service.dart';
import '../services/tmdb_service.dart';

Handler middleware(Handler handler) => handler
    .use(
      provider<Future<MongoService>>(
        (_) async {
          final mongoDbService = MongoService();
          await mongoDbService.initializeMongo();
          return mongoDbService;
        },
      ),
    )
    .use(authorize())
    .use(provider<TmdbService>((_) => TmdbService()))
    .use(requestLogger())
    .use(
      fromShelfMiddleware(
        shelf.corsHeaders(
          headers: {
            shelf.ACCESS_CONTROL_ALLOW_ORIGIN: 'http://localhost:8000',
          },
        ),
      ),
    )
    .use(counterProvider);
