import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:movies_app_models/movies_app_models.dart';

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

      user.password = hashPassword(user.password);
      final userCollection = mongoService.database.collection('users');

      if (await userCollection.findOne({'email': user.email}) != null) {
        return Response.json(
          statusCode: 400,
          body: {
            'status': 400,
            'message': 'A user with the provided email already exists',
            'error': 'user_exists',
          },
        );
      }

      await userCollection.insertOne(user.toJson());
      await mongoService.close();

      return Response.json(
        body: {'status': 200, 'message': 'User registered successfully'},
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
