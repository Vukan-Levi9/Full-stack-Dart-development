import 'package:dart_frog/dart_frog.dart';

import '../../services/tmdb_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.read<bool>()) {
    try {
      if (context.request.method == HttpMethod.get) {
        return Response.json(
          body: {
            'status': 200,
            'message': 'Fetched all movies successfully',
            'data': await context.read<TmdbService>().getMovies(),
          },
        );
      }

      return Response.json(
        statusCode: 404,
        body: {'status': 404, 'message': 'Invalid request'},
      );
    } catch (error) {
      return Response.json(
        statusCode: 500,
        body: {
          'status': 500,
          'message': 'Server error. Something went wrong',
          'error': error.toString(),
        },
      );
    }
  }

  return Response.json(
    statusCode: 401,
    body: {
      'status': 401,
      'message': 'You are not authorized to perform this request',
    },
  );
}
