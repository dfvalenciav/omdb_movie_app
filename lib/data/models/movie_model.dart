import '../../domain/entities/movie.dart';

/// Model representing a movie fetched from the OMDb API.
/// Extends the core Movie entity and includes JSON parsing methods.
class MovieModel extends Movie {
  const MovieModel({
    required super.title,
    required super.year,
    required super.imdbID,
    required super.poster,
    super.isFavorite,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      title: json['Title'],
      year: json['Year'],
      imdbID: json['imdbID'],
      poster: json['Poster'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': imdbID,
      'title': title,
      'year': year,
      'poster': poster,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }
}
