import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), '/Users/pizzaforpaw/Downloads/DictionaryProject/assets/dictionary.db');
    print("Database Path: $path");

    return await openDatabase(
      path,
      version: 2, // Incremented version for new `favorites` table
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS dictionary (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom_character TEXT,
            linked_nom TEXT,
            vietnamese TEXT NOT NULL UNIQUE,
            definition TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL,
            word TEXT NOT NULL,
            searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS favorites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL,
            word TEXT NOT NULL UNIQUE
          )
        ''');

        print("Database tables created.");
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS favorites (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id TEXT NOT NULL,
              word TEXT NOT NULL UNIQUE
            )
          ''');
          print("Favorites table added.");
        }
      },
    );
  }

  // 🔍 Search Vietnamese word and retrieve all definitions
  Future<List<Map<String, dynamic>>> searchWord(String vietnameseWord) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'dictionary',
      where: 'LOWER(vietnamese) = LOWER(?)',
      whereArgs: [vietnameseWord.trim().toLowerCase()],
    );

    print("Search results for '$vietnameseWord': $results");
    return results;
  }

  // 🔢 Fetch word suggestions (autocomplete)
  Future<List<String>> getSuggestions(String query) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'dictionary',
      where: 'LOWER(vietnamese) LIKE ?',
      whereArgs: ['$query%'],
      orderBy: 'LENGTH(vietnamese), vietnamese',
      limit: 5,
    );

    return results.map((row) => row['vietnamese'] as String).toList();
  }

  // ⭐ Add a word to favorites
  Future<void> addToFavorites(String word) async {
    final db = await database;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user logged in, skipping favorite save.");
      return;
    }

    try {
      await db.insert(
        'favorites',
        {'user_id': user.uid, 'word': word.trim()},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      print("Added to favorites: $word");
    } catch (e) {
      print("Error adding to favorites: $e");
    }
  }

  //  Remove a word from favorites
  Future<void> removeFromFavorites(String word) async {
    final db = await database;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user logged in, skipping favorite removal.");
      return;
    }

    try {
      await db.delete('favorites', where: 'user_id = ? AND word = ?', whereArgs: [user.uid, word]);
      print("Removed from favorites: $word");
    } catch (e) {
      print("Error removing from favorites: $e");
    }
  }

  // 🔎 Check if a word is favorited
  Future<bool> isFavorite(String word) async {
    final db = await database;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user logged in, returning false.");
      return false;
    }

    final result = await db.query('favorites', where: 'user_id = ? AND word = ?', whereArgs: [user.uid, word]);
    return result.isNotEmpty;
  }

  //  Get all favorite words
  Future<List<String>> getFavoriteWords() async {
    final db = await database;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user logged in, returning empty favorites.");
      return [];
    }

    final result = await db.query('favorites', where: 'user_id = ?', whereArgs: [user.uid]);
    return result.map((row) => row['word'] as String).toList();
  }

  // Save search history
  Future<void> saveSearchHistory(String word) async {
    final db = await database;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user logged in, skipping history save.");
      return;
    }

    try {
      await db.insert(
        'history',
        {'user_id': user.uid, 'word': word.trim()},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      print("Search history saved: $word");
    } catch (e) {
      print("Error saving search history: $e");
    }
  }

  // Fetch search history
  Future<List<Map<String, dynamic>>> getSearchHistory() async {
    final db = await database;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user logged in, returning empty history.");
      return [];
    }

    final history = await db.query(
      'history',
      where: 'user_id = ?',
      whereArgs: [user.uid],
      orderBy: 'searched_at DESC',
      limit: 20,
    );

    print("Fetched search history: $history");
    return history;
  }

  // Debugging function to check if history table has data
  Future<void> debugCheckHistoryTable() async {
    final db = await database;
    final result = await db.rawQuery('SELECT * FROM history');
    print("Full history table content: $result");
  }

  //  Add a new word to the dictionary
  Future<void> addNewWord(String vietnamese, String nomCharacter, String linkedNom, String definition) async {
    final db = await database;

    try {
      await db.insert(
        'dictionary',
        {
          'vietnamese': vietnamese.trim().toLowerCase(),
          'nom_character': nomCharacter.trim(),
          'linked_nom': linkedNom.trim(),
          'definition': definition.trim(),
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      print("New word added: $vietnamese");
    } catch (e) {
      print("Error adding new word: $e");
    }
  }
}
