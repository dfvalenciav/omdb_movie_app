import 'package:omdb_movie_app/data/models/movie_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper({Database? database}) {
    DatabaseHelper._database = database ?? DatabaseHelper._database; // Allow passing a mock database for testing
    return _instance;
  }

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'favorites.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            id TEXT PRIMARY KEY,
            title TEXT,
            year TEXT,
            poster TEXT,
            isFavorite INTEGER
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> addFavorite(MovieModel movie) async {
    final db = await database;
    await db.insert(
      'favorites',
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String movieId) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [movieId],
    );
  }

  Future<List<MovieModel>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) {
      return MovieModel(
        title: maps[i]['title'],
        year: maps[i]['year'],
        imdbID: maps[i]['id'],
        poster: maps[i]['poster'],
        isFavorite: maps[i]['isFavorite'] == 1,
      );
    });
  }
}
