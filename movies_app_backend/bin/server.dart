// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';


import '../routes/ws.dart' as ws;
import '../routes/index.dart' as index;
import '../routes/signup/index.dart' as signup_index;
import '../routes/signin/index.dart' as signin_index;
import '../routes/movies/index.dart' as movies_index;
import '../routes/movies/[id].dart' as movies_$id;

import '../routes/_middleware.dart' as middleware;

void main() async {
  final address = InternetAddress.anyIPv6;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  createServer(address, port);
}

Future<HttpServer> createServer(InternetAddress address, int port) async {
  final handler = Cascade().add(buildRootHandler()).handler;
  final server = await serve(handler, address, port);
  print('\x1B[92m✓\x1B[0m Running on http://${server.address.host}:${server.port}');
  return server;
}

Handler buildRootHandler() {
  final pipeline = const Pipeline().addMiddleware(middleware.middleware);
  final router = Router()
    ..mount('/movies', (context) => buildMoviesHandler()(context))
    ..mount('/signin', (context) => buildSigninHandler()(context))
    ..mount('/signup', (context) => buildSignupHandler()(context))
    ..mount('/', (context) => buildHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildMoviesHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => movies_index.onRequest(context,))..all('/<id>', (context,id,) => movies_$id.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildSigninHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => signin_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildSignupHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => signup_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/ws', (context) => ws.onRequest(context,))..all('/', (context) => index.onRequest(context,));
  return pipeline.addHandler(router);
}

