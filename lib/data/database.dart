import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/session.dart';

/// SQLite database wrapper for storing practice session history.
class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const _dbName = 'maths_tables.db';
  static const _dbVersion = 1;

  Database? _database;

  Future<Database> get database async {
    _database ??= await _open();
    return _database!;
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sessions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            mode TEXT NOT NULL,
            difficulty TEXT NOT NULL,
            score INTEGER NOT NULL,
            accuracy REAL NOT NULL,
            totalProblems INTEGER NOT NULL,
            correct INTEGER NOT NULL,
            wrong INTEGER NOT NULL,
            durationSeconds INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertSession(Session session) async {
    final db = await database;
    return db.insert('sessions', session.toMap()..remove('id'));
  }

  Future<List<Session>> getAllSessions() async {
    final db = await database;
    final rows = await db.query('sessions', orderBy: 'date DESC');
    return rows.map(Session.fromMap).toList();
  }

  Future<List<Session>> getSessionsByMode(String mode) async {
    final db = await database;
    final rows = await db.query(
      'sessions',
      where: 'mode = ?',
      whereArgs: [mode],
      orderBy: 'date DESC',
    );
    return rows.map(Session.fromMap).toList();
  }

  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('sessions');
  }

  Future<Map<String, double>> getStatistics() async {
    final sessions = await getAllSessions();
    if (sessions.isEmpty) {
      return {
        'totalSessions': 0,
        'averageScore': 0,
        'bestScore': 0,
        'averageAccuracy': 0,
      };
    }
    final total = sessions.length;
    final avgScore =
        sessions.map((s) => s.score).reduce((a, b) => a + b) / total;
    final bestScore = sessions.map((s) => s.score).reduce((a, b) => a > b ? a : b);
    final avgAccuracy =
        sessions.map((s) => s.accuracy).reduce((a, b) => a + b) / total;
    return {
      'totalSessions': total.toDouble(),
      'averageScore': avgScore,
      'bestScore': bestScore.toDouble(),
      'averageAccuracy': avgAccuracy,
    };
  }
}