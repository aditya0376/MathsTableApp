import '../models/session.dart';
import 'database.dart';

/// Data access layer for session history.
class HistoryDao {
  final AppDatabase _db = AppDatabase.instance;

  Future<int> saveSession(Session session) => _db.insertSession(session);

  Future<List<Session>> getAllSessions() => _db.getAllSessions();

  Future<List<Session>> getSessionsByMode(String mode) =>
      _db.getSessionsByMode(mode);

  Future<void> clearHistory() => _db.clearHistory();

  Future<Map<String, double>> getStatistics() => _db.getStatistics();
}