import 'package:dart_frog/dart_frog.dart';

import '../../services/tmdb_service.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final movieId = int.tryParse(id);

  if (context.read<bool>()) {
    try {
      if (context.request.method == HttpMethod.get && movieId is int) {
        return Response.json(
          body: {
            'status': 200,
            'message': 'Fetched movie successfully',
            'data': await context.read<TmdbService>().getMovie(movieId),
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
