part of 'movies_bloc.dart';

sealed class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object> get props => [];
}

class GetMovies extends MoviesEvent {}

class GetMovie extends MoviesEvent {
  final String id;

  const GetMovie(this.id);

  @override
  List<Object> get props => [id];
}
