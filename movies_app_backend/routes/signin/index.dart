import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:movies_app_models/movies_app_models.dart';

import '../../helpers/authorization.dart';
import '../../helpers/hash.dart';
import '../../services/mongo_service.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    final request = context.request;
    final mongoService = await context.read<Future<MongoService>>();

    if (request.method == HttpMethod.post) {
      await mongoService.open();

      final user = UserModel.fromJson(
        jsonDecode(await request.body()) as Map<String, dynamic>,
      );

      final foundUser = await mongoService.database
          .collection('users')
          .findOne({'email': user.email});

      if (foundUser == null) {
        return Response.json(
          statusCode: 400,
          body: {
            'status': 400,
            'message': 'No user found with the provided credentials',
            'error': 'user_not_found',
          },
        );
      }

      if (hashPassword(user.password) != foundUser['password'] as String) {
        return Response.json(
          statusCode: 400,
          body: {
            'status': 400,
            'message': 'Incorrect email or password',
            'error': 'incorrect_email_password',
          },
        );
      }

      await mongoService.close();

      return Response.json(
        body: {
          'status': 200,
          'message': 'User logged in successfully',
          'token': issueToken((foundUser['_id'] as ObjectId).oid),
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
