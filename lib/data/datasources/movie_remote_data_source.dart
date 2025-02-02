import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/error/exceptions.dart';
import '../models/movie_details_model.dart';
import '../models/movie_model.dart';

/// Interface for fetching movie data from a remote API.
abstract class MovieRemoteDataSource {
  /// Searches for movies based on a query string.
  Future<List<MovieModel>> searchMovies(String query);

  /// Fetches detailed information about a specific movie by its ID.
  Future<MovieDetailsModel> fetchMovieDetails(String movieId);
}

/// Implementation of MovieRemoteDataSource using the OMDb API.
class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final http.Client client;
  final String apiKey = "c14362ea";

  MovieRemoteDataSourceImpl({required this.client});

  /// Fetches a list of movies matching the query string.
  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await client.get(
      Uri.parse('https://www.omdbapi.com/?apikey=$apiKey&s=$query'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Check if 'Search' exists and is a List
      if (data['Search'] != null && data['Search'] is List) {
        return (data['Search'] as List)
            .map((json) => MovieModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(); 
      }
    } else {
      throw ServerException();
    }
  }

  /// Fetches details for a specific movie by its ID.
  @override
  Future<MovieDetailsModel> fetchMovieDetails(String movieId) async {
    final response = await client.get(
      Uri.parse('https://www.omdbapi.com/?apikey=$apiKey&i=$movieId'),
    );

    if (response.statusCode == 200) {
      return MovieDetailsModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }
}
