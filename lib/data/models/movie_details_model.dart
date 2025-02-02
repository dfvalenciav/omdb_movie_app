import '../../domain/entities/movie_details.dart';

/// Model representing detailed movie information fetched from the OMDb API.
/// Extends the core MovieDetails entity and includes JSON parsing methods.
class MovieDetailsModel extends MovieDetails {
  const MovieDetailsModel({
    required super.title,
    required super.year,
    required super.director,
    required super.actors,
    required super.plot,
    required super.runtime,
    required super.genre,
    required super.poster,
  });

  /// Factory method to create a MovieDetailsModel from a JSON map.
  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
      title: json['Title'],
      year: json['Year'],
      director: json['Director'],
      actors: json['Actors'],
      plot: json['Plot'],
      runtime: json['Runtime'],
      genre: json['Genre'],
      poster: json['Poster'],
    );
  }
}
