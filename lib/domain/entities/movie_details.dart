import 'package:equatable/equatable.dart';

/// Entity representing detailed information about a movie.
/// This is the core representation used in the domain layer.
class MovieDetails extends Equatable {
  final String title;
  final String year;
  final String director;
  final String actors;
  final String plot;
  final String runtime;
  final String genre;
  final String poster;  

  const MovieDetails({
    required this.title,
    required this.year,
    required this.director,
    required this.actors,
    required this.plot,
    required this.runtime,
    required this.genre,
    required this.poster,
  });

  @override
  List<Object?> get props =>
      [title, year, director, actors, plot, runtime, genre, poster]; 
}
