part of 'movies_bloc.dart';

sealed class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object?> get props => [];
}

final class MoviesInitial extends MoviesState {}

final class Loading extends MoviesState {}

final class MoviesLoadingError extends MoviesState {
  final Response? response;

  const MoviesLoadingError({required this.response});

  @override
  List<Object?> get props => [response];
}

final class MoviesLoaded extends MoviesState {
  final List<Movie> movies;

  const MoviesLoaded({required this.movies});

  @override
  List<Object> get props => [movies];
}

final class MovieLoaded extends MoviesState {
  final Movie? movie;

  const MovieLoaded({required this.movie});

  @override
  List<Object?> get props => [movie];
}

final class MovieLoadingError extends MoviesState {
  final Response? response;

  const MovieLoadingError({required this.response});

  @override
  List<Object?> get props => [response];
}
