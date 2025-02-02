import 'package:equatable/equatable.dart';

/// Entity representing a movie.
/// This is the core representation of a movie used throughout the app.
class Movie extends Equatable {
  final String title;
  final String year;
  final String imdbID;
  final String poster;
  final bool isFavorite;

  // Set isFavorite to false by default
  const Movie({
    required this.title,
    required this.year,
    required this.imdbID,
    required this.poster,
    this.isFavorite = false, // Default value is false
  });

  @override
  List<Object?> get props => [title, year, imdbID, poster, isFavorite];
}
