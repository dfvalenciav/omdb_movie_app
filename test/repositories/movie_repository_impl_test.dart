import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:omdb_movie_app/core/error/exceptions.dart';
import 'package:omdb_movie_app/core/error/failures.dart';
import 'package:omdb_movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:omdb_movie_app/data/models/movie_model.dart';
import 'package:omdb_movie_app/data/repositories/movie_repository_impl.dart';
import 'package:omdb_movie_app/domain/entities/movie.dart';

import 'movie_repository_impl_test.mocks.dart';

@GenerateMocks([MovieRemoteDataSource])
void main() {
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MovieRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    repository = MovieRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('searchMovies', () {
    final tMovieModels = [
      const MovieModel(
          title: 'Inception', year: '2010', imdbID: 'tt1375666', poster: 'N/A'),
    ];

    test(
        'should return movie list when the call to remote data source is successful',
        () async {
      // Arrange
      when(mockRemoteDataSource.searchMovies(any))
          .thenAnswer((_) async => tMovieModels);

      final expectedMovies = [
        const Movie(
            title: 'Inception',
            year: '2010',
            imdbID: 'tt1375666',
            poster: 'N/A'),
      ];

      // Act
      final result = await repository.searchMovies('Inception');

      // Assert
      expect(result.fold((l) => l, (r) => r), expectedMovies);
    });

    test(
        'should return ServerFailure when the call to remote data source fails',
        () async {
      // Arrange
      when(mockRemoteDataSource.searchMovies(any)).thenThrow(ServerException());

      // Act
      final result = await repository.searchMovies('Inception');

      // Assert
      expect(result, equals(Left(ServerFailure())));
    });
  });
}
