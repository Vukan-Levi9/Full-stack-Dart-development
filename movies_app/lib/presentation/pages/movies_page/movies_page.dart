import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/injection_container.dart';
import 'package:movies_app/domain/repository/auth_repository.dart';
import 'package:movies_app/domain/repository/counter_repository.dart';
import 'package:movies_app/presentation/bloc/bloc/movies_bloc/movies_bloc.dart';
import 'package:movies_app/presentation/pages/movies_page/widgets/movie_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/routes/app_router.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  final _authRepository = IC.getIt<AuthRepository>();
  final _counterRepository = IC.getIt<CounterRepository>()..connect();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.popularMovies),
        actions: [
          StreamBuilder(
            stream: _counterRepository.stream,
            builder: (context, snapshot) => snapshot.hasData
                ? Text(
                    AppLocalizations.of(context)!.numberOfUsers + snapshot.data,
                  )
                : const SizedBox.shrink(),
          ),
          IconButton(onPressed: _signOut, icon: const Icon(Icons.logout)),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer(
          listener: (_, state) {
            if (state is MoviesLoadingError &&
                state.response?.statusCode == 401) {
              _signOut();
            }
          },
          buildWhen: (_, current) =>
              current is MoviesLoaded || current is MoviesLoadingError,
          builder: (context, state) {
            if (state is MoviesLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: MediaQuery.of(context).size.width > 600
                    ? GridView.builder(
                        itemCount: state.movies.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        itemBuilder: (_, index) => MovieItem(
                          movie: state.movies[index],
                        ),
                      )
                    : ListView.builder(
                        restorationId: 'moviesListView',
                        itemCount: state.movies.length,
                        itemBuilder: (_, index) => MovieItem(
                          movie: state.movies[index],
                        ),
                      ),
              );
            }

            if (state is MoviesLoadingError &&
                state.response?.statusCode != 401) {
              return Center(
                child: Text(AppLocalizations.of(context)!.loadingMoviesError),
              );
            }

            return const Center(child: CircularProgressIndicator.adaptive());
          },
          bloc: IC.getIt<MoviesBloc>()..add(GetMovies()),
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await _authRepository.signOut();
    Router.neglect(context, () => context.go(Routes.signIn));
  }

  @override
  void dispose() {
    _counterRepository.close();
    super.dispose();
  }
}
