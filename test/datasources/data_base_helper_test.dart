import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';
import 'package:omdb_movie_app/data/datasources/data_base_helper.dart';
import 'package:omdb_movie_app/data/models/movie_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Mocking the Database class for testing
class MockDatabase extends Mock implements Database {}

void main() {
  late DatabaseHelper databaseHelper;
  late MockDatabase mockDatabase;

  setUpAll(() {
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    mockDatabase = MockDatabase();
    databaseHelper = DatabaseHelper(database: mockDatabase); 
  });




  group('DatabaseHelper tests', () {

test('get database should initialize database when not already initialized', () async {
      when(() => mockDatabase.insert(any(), any(), conflictAlgorithm: any(named: 'conflictAlgorithm')))
          .thenAnswer((_) async => 1); // Simulating successful insertion

      final db = await databaseHelper.database;

      // Assert: Ensure that the database was initialized
      expect(db, isNotNull);
    });

    test('get database should return existing database if already initialized', () async {
      // Arrange: Mock the database being already initialized
      when(() => mockDatabase.insert(any(), any(), conflictAlgorithm: any(named: 'conflictAlgorithm')))
          .thenAnswer((_) async => 1); // Simulating successful insertion

      // Act: Access the database property twice
      final db1 = await databaseHelper.database;
      final db2 = await databaseHelper.database;

      expect(db1, db2);
    });


    test('addFavorite should insert a movie into the database', () async {
      // Arrange
      final movie = MovieModel(
        title: 'Movie Title',
        year: '2022',
        imdbID: '1',
        poster: 'poster_url',
        isFavorite: true,
      );

      // Mock the insert function to simulate successful insertion
      when(() => mockDatabase.insert(
            any(),
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          )).thenAnswer((_) async => 1); // Simulating success with a row ID

      // Act
      await databaseHelper.addFavorite(movie);

      // Assert
      verify(() => mockDatabase.insert(
            'favorites',
            movie.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          )).called(1);
    });

    test('removeFavorite should delete a movie from the database', () async {
      // Arrange
      final movieId = '1';

      // Mock the delete function to simulate successful removal
      when(() => mockDatabase.delete(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
          )).thenAnswer((_) async => 1); // Simulating successful deletion

      // Act
      await databaseHelper.removeFavorite(movieId);

      // Assert
      verify(() => mockDatabase.delete(
            'favorites',
            where: 'id = ?',
            whereArgs: [movieId],
          )).called(1);
    });

    test('getFavorites should return a list of MovieModel objects', () async {
      // Arrange
      final rawMovies = [
        {
          'id': '1', // Ensure that 'id' is used for the primary key
          'title': 'Movie 1',
          'year': '2021',
          'poster': 'poster_1_url',
          'isFavorite': 1,
        },
        {
          'id': '2', // Same for the second movie
          'title': 'Movie 2',
          'year': '2022',
          'poster': 'poster_2_url',
          'isFavorite': 0,
        },
      ];

      // Mock the query function to return a list of raw data
      when(() => mockDatabase.query('favorites')).thenAnswer((_) async => rawMovies);

      // Act
      final result = await databaseHelper.getFavorites();

      // Assert
      expect(result.length, 2);
      expect(result[0].imdbID, '1');
      expect(result[0].title, 'Movie 1');
      expect(result[0].isFavorite, true);
      expect(result[1].imdbID, '2');
      expect(result[1].isFavorite, false);
    });
  });
}
