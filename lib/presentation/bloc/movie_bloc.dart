import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdb_movie_app/data/datasources/data_base_helper.dart';
import 'package:omdb_movie_app/data/models/movie_model.dart';
import '../../domain/usecases/get_movie_details.dart';
import '../../domain/usecases/search_movies.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final SearchMovies searchMovies;
  final GetMovieDetails getMovieDetails;
  final DatabaseHelper databaseHelper = DatabaseHelper();

  MovieBloc({required this.searchMovies, required this.getMovieDetails})
      : super(MovieInitial()) {
    // Handle movie search events
    on<SearchMoviesEvent>((event, emit) async {
      emit(MovieLoading());
      final result = await searchMovies(event.query);

      result.fold(
        (failure) => emit(MovieError('Failed to load movies.')),
        (movies) => emit(MoviesLoaded(movies)),
      );
    });

    // Handle movie details events
    on<GetMovieDetailsEvent>((event, emit) async {
      emit(MovieLoading());

      // Await the result of getMovieDetails
      final result = await getMovieDetails(event.movieId);

      await result.fold(
        (failure) {
          // Emit MovieError state when there's a failure
          emit(MovieError('Failed to load movie details.'));
        },
        (details) async {
          // Fetch favorites from the database
          final favorites = await databaseHelper.getFavorites();

          // Emit MovieDetailsLoaded state once everything is complete
          emit(MovieDetailsLoaded(details, favorites));
        },
      );
    });

    // Handle adding/removing from favorites
    on<AddRemoveFavoriteEvent>((event, emit) async {
      final currentState = state;
      if (currentState is MovieDetailsLoaded) {
        // Toggle the favorite status in the database
        if (event.isFavorite) {
          // Add to favorites
          final movie = MovieModel(
            title: currentState.movieDetails.title,
            year: currentState.movieDetails.year,
            imdbID: event.movieId,
            poster: currentState.movieDetails.poster,
            isFavorite: true,
          );
          await databaseHelper.addFavorite(movie);
        } else {
          // Remove from favorites
          await databaseHelper.removeFavorite(event.movieId);
        }

        // Refresh the favorites list after updating the database
        final favorites = await databaseHelper.getFavorites();

        // Emit MovieDetailsLoaded state with updated favorites
        emit(MovieDetailsLoaded(currentState.movieDetails, favorites));
      }
    });

    on<LoadFavoritesEvent>((event, emit) async {
      emit(MovieLoading());

      // Fetch favorites from the database
      final favorites = await databaseHelper.getFavorites();
      emit(FavoritesLoaded(favorites));
    });

        // Handle RemoveFavoriteEvent to remove a movie from the favorites
    on<RemoveFavoriteEvent>((event, emit) async {
      final currentState = state;
      if (currentState is FavoritesLoaded) {
        // Remove the movie from the database
        await databaseHelper.removeFavorite(event.movieId);

        // Fetch updated list of favorites
        final updatedFavorites = await databaseHelper.getFavorites();

        // Emit the updated favorites list
        emit(FavoritesLoaded(updatedFavorites));
      }
    });
  }
}
