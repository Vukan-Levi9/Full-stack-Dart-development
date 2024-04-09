import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import '../config/config.dart';

Middleware authorize() => provider<bool>(
      (context) {
        try {
          JWT.verify(
            context.request.headers['Authorization']?.trim() ?? '',
            SecretKey(Config.jwtSecret),
          );

          return true;
        } catch (error) {
          return false;
        }
      },
    );

String issueToken(String userId) =>
    JWT({'id': userId}, issuer: 'vukan', subject: userId).sign(
      SecretKey(Config.jwtSecret),
      expiresIn: const Duration(hours: 24),
    );
