import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdb_movie_app/presentation/bloc/movie_event.dart';
import 'package:omdb_movie_app/presentation/bloc/movie_bloc.dart';
import 'package:omdb_movie_app/presentation/bloc/movie_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger the loading of favorites when the page is first loaded
    context.read<MovieBloc>().add(LoadFavoritesEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoritesLoaded) {
            final favoriteMovies = state.favorites;

            // If no favorites exist, show a message
            if (favoriteMovies.isEmpty) {
              return const Center(child: Text('No favorites added yet.'));
            }

            return ListView.builder(
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                return ListTile(
                  leading: Image.network(
                    movie.poster,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                  ),
                  title: Text(movie.title),
                  subtitle: Text(movie.year),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.blue),
                    onPressed: () {
                      // Trigger RemoveFavoriteEvent when delete icon is tapped
                      context
                          .read<MovieBloc>()
                          .add(RemoveFavoriteEvent(movie.imdbID));
                    },
                  ),
                );
              },
            );
          } else if (state is MovieError) {
            return Center(
                child: Text('Error loading favorites: ${state.message}'));
          } else {
            return const Center(child: Text('Unexpected state.'));
          }
        },
      ),
    );
  }
}
