import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:omdb_movie_app/core/error/exceptions.dart';
import 'package:omdb_movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:omdb_movie_app/data/models/movie_model.dart';

import 'movie_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockHttpClient;
  late MovieRemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = MovieRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('searchMovies', () {
    const tQuery = 'Inception';

    test('should perform a GET request and return a list of MovieModels',
        () async {
      // Arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(
            jsonEncode({
              'Search': [
                {
                  'Title': 'Inception',
                  'Year': '2010',
                  'imdbID': 'tt1375666',
                  'Poster': 'N/A'
                }
              ]
            }),
            200),
      );

      final expectedModels = [
        const MovieModel(
            title: 'Inception',
            year: '2010',
            imdbID: 'tt1375666',
            poster: 'N/A'),
      ];

      // Act
      final result = await dataSource.searchMovies('Inception');

      // Assert
      expect(result, equals(expectedModels));
    });

    test('should throw a ServerException when the response code is not 200',
        () async {
      // Arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response('Something went wrong', 404),
      );

      // Act
      expect(() => dataSource.searchMovies(tQuery),
          throwsA(isA<ServerException>()));
    });
  });

  group('fetchMovieDetails', () {
    const tMovieId = 'tt1375666';

    test('should throw a ServerException when the response code is not 200',
        () async {
      // Arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response('Something went wrong', 404),
      );

      // Act
      expect(() => dataSource.fetchMovieDetails(tMovieId),
          throwsA(isA<ServerException>()));
    });
  });
}
