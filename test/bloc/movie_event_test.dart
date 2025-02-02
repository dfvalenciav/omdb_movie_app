import 'package:flutter_test/flutter_test.dart';
import 'package:omdb_movie_app/presentation/bloc/movie_event.dart';

void main() {
  group('MovieEvent Tests', () {
    test('SearchMoviesEvent has correct props', () {
      // Create an instance of the event with a query string
      final searchMoviesEvent = SearchMoviesEvent('Inception');

      // Check if the props contain the query string
      expect(searchMoviesEvent.props, equals(['Inception']));
    });

    test('GetMovieDetailsEvent has correct props', () {
      // Create an instance of the event with a movie ID
      final getMovieDetailsEvent = GetMovieDetailsEvent('tt1375666');

      // Check if the props contain the movie ID
      expect(getMovieDetailsEvent.props, equals(['tt1375666']));
    });

    test('AddRemoveFavoriteEvent has correct props', () {
      // Create an instance of the event with a movie ID and favorite status
      final addRemoveFavoriteEvent = AddRemoveFavoriteEvent('tt1375666', true);

      // Check if the props contain both the movie ID and the favorite status
      expect(addRemoveFavoriteEvent.props, equals(['tt1375666', true]));
    });

    test('LoadFavoritesEvent has correct props', () {
      // LoadFavoritesEvent has no properties
      final loadFavoritesEvent = LoadFavoritesEvent();

      // Ensure the props list is empty
      expect(loadFavoritesEvent.props, equals([]));
    });

    test('RemoveFavoriteEvent has correct props', () {
      // Create an instance of the event with a movie ID
      final removeFavoriteEvent = RemoveFavoriteEvent('tt1375666');

      // Check if the props contain the movie ID
      expect(removeFavoriteEvent.props, equals(['tt1375666']));
    });
  });
}
