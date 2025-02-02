import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:omdb_movie_app/presentation/bloc/signin_bloc.dart';
import 'package:omdb_movie_app/presentation/pages/favorites_page.dart';
import 'package:omdb_movie_app/presentation/pages/search_page.dart';

import 'presentation/pages/signin_page.dart';

import 'data/datasources/movie_remote_data_source.dart';
import 'data/repositories/movie_repository_impl.dart';
import 'domain/usecases/get_movie_details.dart';
import 'domain/usecases/search_movies.dart';

import 'presentation/bloc/movie_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dependency Injection:
    // Initialize HTTP client
    final http.Client client = http.Client();

    // Create instances for data source, repository, and use cases
    final movieRemoteDataSource = MovieRemoteDataSourceImpl(client: client);
    final movieRepository = MovieRepositoryImpl(remoteDataSource: movieRemoteDataSource);
    final searchMovies = SearchMovies(movieRepository);
    final getMovieDetails = GetMovieDetails(movieRepository);

    // Initialize the SignInBloc (for sign-in logic)
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SignInBloc(),
        ),
        BlocProvider(
          create: (_) => MovieBloc(
            searchMovies: searchMovies,
            getMovieDetails: getMovieDetails,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OMDb Movie Search',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // Set the home screen to SignInPage, which will later navigate to SearchPage on success.
        home: SignInPage(),
      ),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    SearchPage(),
    FavoritesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('OMDb Movie Search'),
      // ),
      body: _pages[_selectedIndex], // Display selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
