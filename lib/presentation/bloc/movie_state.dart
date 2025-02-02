// Base class for all states
import 'package:equatable/equatable.dart';
import 'package:omdb_movie_app/data/models/movie_model.dart';
import 'package:omdb_movie_app/domain/entities/movie.dart';
import 'package:omdb_movie_app/domain/entities/movie_details.dart';

abstract class MovieState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Initial state
class MovieInitial extends MovieState {}

// Loading state
class MovieLoading extends MovieState {}

// Movies loaded state
class MoviesLoaded extends MovieState {
  final List<Movie> movies;

  MoviesLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

// Movie details loaded state
class MovieDetailsLoaded extends MovieState {
  final MovieDetails movieDetails;
  final List<MovieModel> favorites;

  MovieDetailsLoaded(this.movieDetails, this.favorites);

  @override
  List<Object?> get props => [movieDetails, favorites];
}

// Error state
class MovieError extends MovieState {
  final String message;

  MovieError(this.message);

  @override
  List<Object?> get props => [message];
}

class FavoritesLoaded extends MovieState {
  final List<MovieModel> favorites;

  FavoritesLoaded(this.favorites);

  @override
  List<Object?> get props => [favorites];
}
