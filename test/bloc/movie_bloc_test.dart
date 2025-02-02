import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';
import 'package:omdb_movie_app/data/datasources/data_base_helper.dart';
import 'package:omdb_movie_app/data/models/movie_model.dart';
import 'package:omdb_movie_app/domain/entities/movie_details.dart';
import 'package:omdb_movie_app/domain/usecases/get_movie_details.dart';
import 'package:omdb_movie_app/domain/usecases/search_movies.dart';
import 'package:omdb_movie_app/presentation/bloc/movie_bloc.dart';
import 'package:omdb_movie_app/presentation/bloc/movie_event.dart';
import 'package:omdb_movie_app/presentation/bloc/movie_state.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Mocking the required classes
class MockSearchMovies extends Mock implements SearchMovies {}

class MockGetMovieDetails extends Mock implements GetMovieDetails {}

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

class MockDatabase extends Mock implements Database {}

void main() {
  setUpAll(() {
    databaseFactory = databaseFactoryFfi;
  });

  late MovieBloc movieBloc;
  late MockSearchMovies mockSearchMovies;
  late MockGetMovieDetails mockGetMovieDetails;
  late MockDatabaseHelper mockDatabaseHelper;

  late MockDatabase mockDatabase;

  setUpAll(() {
    // Register fallback value for MovieModel
    registerFallbackValue(const MovieModel(
      title: 'Dummy Movie',
      year: '2020',
      imdbID: '0',
      poster: 'dummy_poster_url',
      isFavorite: false,
    ));
  });

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    mockGetMovieDetails = MockGetMovieDetails();
    mockDatabaseHelper = MockDatabaseHelper();
    mockDatabase = MockDatabase();

    movieBloc = MovieBloc(
      searchMovies: mockSearchMovies,
      getMovieDetails: mockGetMovieDetails,
    );
  });

  tearDown(() {
    movieBloc.close();
  });

  group('MovieBloc Tests', () {
    test('initial state is MovieInitial', () {
      expect(movieBloc.state, MovieInitial());
    });

    test('SearchMoviesEvent emits MoviesLoaded on success', () async {
      final movies = [
        const MovieModel(
          title: 'Movie 1',
          year: '2021',
          imdbID: '1',
          poster: 'poster_1_url',
        ),
      ];

      when(() => mockSearchMovies(any()))
          .thenAnswer((_) async => Right(movies));

      movieBloc.add(SearchMoviesEvent('Movie'));

      // Assert: Verify that the MoviesLoaded state is emitted with the correct movies
      await expectLater(
        movieBloc.stream,
        emitsInOrder([MovieLoading(), MoviesLoaded(movies)]),
      );
    });

    test(
        'GetMovieDetailsEvent emits MovieDetailsLoaded with favorites on success',
        () async {
      const movieDetails = MovieDetails(
        title: 'Movie 1',
        year: '2021',
        director: 'Director',
        actors: 'Actors',
        plot: 'Plot',
        runtime: '120 min',
        genre: 'Drama',
        poster: 'poster_url',
      );
      final favorites = [
        const MovieModel(
          title: 'Favorite Movie 1',
          year: '2020',
          imdbID: '1',
          poster: 'favorite_poster_url',
          isFavorite: true,
        ),
      ];

      when(() => mockGetMovieDetails(any()))
          .thenAnswer((_) async => const Right(movieDetails));

      when(() => mockDatabase.query('favorites')).thenAnswer(
        (_) async => [
          {
            'id': '1',
            'title': 'Favorite Movie 1',
            'year': '2020',
            'poster': 'favorite_poster_url',
            'isFavorite': 1,
          },
        ],
      );

      when(() => mockDatabaseHelper.getFavorites()).thenAnswer(
        (_) async => favorites,
      );

      movieBloc.add(GetMovieDetailsEvent('1'));

      // Assert: Verify that the MovieDetailsLoaded state is emitted with movie details and favorites
      await expectLater(
        movieBloc.stream,
        emitsInOrder(
            [MovieLoading(), MovieDetailsLoaded(movieDetails, favorites)]),
      );
    });

    test('LoadFavoritesEvent emits FavoritesLoaded with list of favorites',
        () async {
      final favorites = [
        const MovieModel(
          title: 'Favorite Movie 1',
          year: '2020',
          imdbID: '1',
          poster: 'favorite_poster_url',
          isFavorite: true,
        ),
      ];
      when(() => mockDatabase.query('favorites')).thenAnswer(
        (_) async => [
          {
            'id': '1',
            'title': 'Favorite Movie 1',
            'year': '2020',
            'poster': 'favorite_poster_url',
            'isFavorite': 1,
          },
        ],
      );

      when(() => mockDatabaseHelper.getFavorites()).thenAnswer(
        (_) async => favorites,
      );

      movieBloc.add(LoadFavoritesEvent());

      // Assert: Verify that the FavoritesLoaded state is emitted with the correct list of favorites

      await expectLater(
        movieBloc.stream,
        emitsInOrder([MovieLoading(), FavoritesLoaded(favorites)]),
      );
    });
  });
}
