import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';

/// Page displaying detailed information about a selected movie.
class DetailsPage extends StatelessWidget {
  final String movieId;
  final String poster;

  const DetailsPage({super.key, required this.movieId, required this.poster});

  @override
  Widget build(BuildContext context) {
    // Fetch movie details when the page is built
    context.read<MovieBloc>().add(GetMovieDetailsEvent(movieId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieDetailsLoaded) {
            final details = state.movieDetails;
            final favorites = state.favorites;

            // Check if the movie is in favorites
            bool isFavorite = favorites.any((movie) => movie.imdbID == movieId);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        poster,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            // Toggle favorite status
                            bool newFavoriteStatus = !isFavorite;
                            context.read<MovieBloc>().add(
                                  AddRemoveFavoriteEvent(
                                      movieId, newFavoriteStatus),
                                );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    details.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Year: ${details.year}', style: const TextStyle(fontSize: 16)),
                  Text('Director: ${details.director}',
                      style: const TextStyle(fontSize: 16)),
                  Text('Actors: ${details.actors}',
                      style: const TextStyle(fontSize: 16)),
                  Text('Runtime: ${details.runtime}',
                      style: const TextStyle(fontSize: 16)),
                  Text('Genre: ${details.genre}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  const Text(
                    'Plot',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(details.plot, style: const TextStyle(fontSize: 16)),
                ],
              ),
            );
          } else if (state is MovieError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<MovieBloc>()
                          .add(GetMovieDetailsEvent(movieId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Unexpected error occurred.'));
          }
        },
      ),
    );
  }
}
