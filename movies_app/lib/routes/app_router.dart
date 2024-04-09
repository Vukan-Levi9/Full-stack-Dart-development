import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/injection_container.dart';
import 'package:movies_app/data/datasources/local/local_datasource.dart';
import 'package:movies_app/presentation/pages/error_page.dart';
import 'package:movies_app/presentation/pages/movie_page/movie_page.dart';
import 'package:movies_app/presentation/pages/movies_page/movies_page.dart';
import 'package:movies_app/presentation/pages/sign_in_page.dart';
import 'package:movies_app/presentation/pages/sign_up_page.dart';

class AppRouter {
  static GoRouter router({String? initialLocation}) {
    return GoRouter(
      routes: [
        GoRoute(
          path: Routes.movies,
          builder: (_, __) => const MoviesPage(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (_, state) => MoviePage(id: state.pathParameters['id']!),
            ),
          ],
        ),
        GoRoute(
          path: Routes.signUp,
          builder: (_, __) => const SignUpPage(),
        ),
        GoRoute(
          path: Routes.signIn,
          builder: (_, __) => const SignInPage(),
        ),
      ],
      errorBuilder: (_, __) => const ErrorPage(),
      redirect: (_, state) async {
        final uri = state.uri.toString();
        final pagesBeforeAuthentication = [Routes.signUp, Routes.signIn];

        if (await IC.getIt<LocalDatasource>().getToken() != null) {
          if (pagesBeforeAuthentication.contains(uri)) {
            return Routes.movies;
          }
        } else if (!pagesBeforeAuthentication.contains(uri)) {
          return Routes.signIn;
        }

        return null;
      },
      initialLocation: initialLocation ?? Routes.movies,
      debugLogDiagnostics: kDebugMode,
      navigatorKey: GlobalKey<NavigatorState>(),
    );
  }
}

class Routes extends Equatable {
  static const signUp = '/sign-up';
  static const signIn = '/sign-in';
  static const movies = '/movies';

  static String buildMovieRoute(String id) => '$movies/$id';

  @override
  List<Object> get props => [signUp, signIn, movies];
}
