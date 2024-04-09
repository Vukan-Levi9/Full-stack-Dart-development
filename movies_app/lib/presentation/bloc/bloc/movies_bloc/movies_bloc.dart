import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:movies_app/domain/repository/movies_repository.dart';
import 'package:movies_app_models/movies_app_models.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final MoviesRepository _moviesRepository;

  MoviesBloc(this._moviesRepository) : super(MoviesInitial()) {
    on<GetMovies>((event, emit) async {
      emit(Loading());
      final popularMovies = await _moviesRepository.getMovies();

      popularMovies.isRight()
          ? emit(
              MoviesLoaded(
                movies: popularMovies.getRight().fold(() => [], (r) => r),
              ),
            )
          : emit(
              MoviesLoadingError(
                response: popularMovies.getLeft().fold(() => null, (t) => t),
              ),
            );
    });
    on<GetMovie>((event, emit) async {
      emit(Loading());
      final popularMovie = await _moviesRepository.getMovie(event.id);

      popularMovie.isRight()
          ? emit(
              MovieLoaded(
                movie: popularMovie.getRight().fold(() => null, (r) => r),
              ),
            )
          : emit(
              MovieLoadingError(
                response: popularMovie.getLeft().fold(() => null, (t) => t),
              ),
            );
    });
  }
}
