import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/core/injection_container.dart';
import 'package:movies_app/presentation/bloc/bloc/movies_bloc/movies_bloc.dart';
import 'package:movies_app/presentation/pages/movie_page/widgets/movie_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movies_app/core/constants.dart';

class MoviePage extends StatelessWidget {
  const MoviePage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      buildWhen: (_, current) => current is! MoviesLoaded,
      builder: (context, state) {
        if (state is MovieLoaded && state.movie != null) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: !kIsWeb,
              title: Text(state.movie!.title),
            ),
            body: SafeArea(
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Image.network(
                          '${UrlsPath.imagesBaseUrl}${state.movie!.imageUrl}',
                        ),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 800),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            state.movie!.overview,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        MovieInfo(
                          label: AppLocalizations.of(context)!.releaseDate,
                          value: state.movie!.releaseDate,
                        ),
                        MovieInfo(
                          label: AppLocalizations.of(context)!.voteAverage,
                          value: state.movie!.voteAverage.toString(),
                        ),
                        MovieInfo(
                          label: AppLocalizations.of(context)!.voteCount,
                          value: state.movie!.voteCount.toString(),
                        ),
                        if (state.movie!.runtime != null)
                          MovieInfo(
                            label: AppLocalizations.of(context)!.runtime,
                            value: state.movie!.runtime.toString(),
                          ),
                        if (state.movie!.genres.isNotEmpty)
                          MovieInfo(
                            label: AppLocalizations.of(context)!.genres,
                            value: state.movie!.genres
                                .map((genre) => genre.name)
                                .join(', '),
                          ),
                        const Divider(color: Colors.transparent),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (state is MovieLoadingError) {
          return Scaffold(
            appBar: AppBar(automaticallyImplyLeading: !kIsWeb),
            body: Center(
              child: Text(AppLocalizations.of(context)!.loadingMovieError),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(automaticallyImplyLeading: !kIsWeb),
          body: const Center(child: CircularProgressIndicator.adaptive()),
        );
      },
      bloc: IC.getIt<MoviesBloc>()..add(GetMovie(id)),
    );
  }
}
