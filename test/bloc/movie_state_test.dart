import 'package:flutter_test/flutter_test.dart';
import 'package:omdb_movie_app/data/models/movie_model.dart';
import 'package:omdb_movie_app/domain/entities/movie.dart';
import 'package:omdb_movie_app/domain/entities/movie_details.dart';
import 'package:omdb_movie_app/presentation/bloc/movie_state.dart';

void main() {
  group('MovieState Tests', () {
    test('MovieInitial has correct props', () {
      // The MovieInitial state should have an empty props list
      final movieInitial = MovieInitial();
      expect(movieInitial.props, equals([]));
    });

    test('MovieLoading has correct props', () {
      // The MovieLoading state should have an empty props list
      final movieLoading = MovieLoading();
      expect(movieLoading.props, equals([]));
    });

    test('MoviesLoaded has correct props', () {
      // Create a dummy list of movies
      final movies = [
        const Movie(
            title: 'Movie 1',
            year: '2023',
            imdbID: 'tt1234567',
            poster: 'url1'),
        const Movie(
            title: 'Movie 2', year: '2022', imdbID: 'tt7654321', poster: 'url2')
      ];

      final moviesLoaded = MoviesLoaded(movies);

      // Check if props contain the list of movies
      expect(moviesLoaded.props, equals([movies]));
    });

    test('MovieDetailsLoaded has correct props', () {
      // Create a dummy MovieDetails object
      const movieDetails = MovieDetails(
        title: 'Inception',
        year: '2010',
        director: 'Christopher Nolan',
        actors: 'Leonardo DiCaprio, Joseph Gordon-Levitt, Ellen Page',
        plot:
            'A thief steals corporate secrets through dream-sharing technology.',
        runtime: '148 min',
        genre: 'Action, Adventure, Sci-Fi',
        poster: 'N/A',
      );

      // Create a dummy list of favorites
      final favorites = [
        const MovieModel(
            title: 'Movie 1',
            year: '2023',
            imdbID: 'tt1234567',
            poster: 'url1',
            isFavorite: true),
      ];

      final movieDetailsLoaded = MovieDetailsLoaded(movieDetails, favorites);

      // Check if props contain movieDetails and favorites
      expect(movieDetailsLoaded.props, equals([movieDetails, favorites]));
    });

    test('MovieError has correct props', () {
      // Create an error message
      const errorMessage = 'Error loading movie details';
      final movieError = MovieError(errorMessage);

      // Check if props contain the error message
      expect(movieError.props, equals([errorMessage]));
    });

    test('FavoritesLoaded has correct props', () {
      // Create a dummy list of favorite movies
      final favorites = [
        const MovieModel(
          title: 'Movie 1',
          year: '2023',
          imdbID: 'tt1234567',
          poster: 'url1',
          isFavorite: true,
        ),
        const MovieModel(
          title: 'Movie 2',
          year: '2022',
          imdbID: 'tt7654321',
          poster: 'url2',
          isFavorite: true,
        ),
      ];

      final favoritesLoaded = FavoritesLoaded(favorites);

      // Check if props contain the list of favorite movies
      expect(favoritesLoaded.props, equals([favorites]));
    });
  });
}
