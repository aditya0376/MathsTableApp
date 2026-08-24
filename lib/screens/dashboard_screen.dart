import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/history_dao.dart';
import '../main.dart';
import '../models/session.dart';

/// Performance dashboard with detailed analysis and weak-area detection.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final HistoryDao _dao = HistoryDao();
  late Future<List<Session>> _sessions;

  @override
  void initState() {
    super.initState();
    _sessions = _dao.getAllSessions();
  }

  Future<void> _refresh() async {
    setState(() {
      _sessions = _dao.getAllSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Performance Dashboard')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Session>>(
          future: _sessions,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final sessions = snapshot.data ?? [];
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _greeting(appState, scheme),
                const SizedBox(height: 16),
                if (sessions.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text('No sessions yet. Start practicing!'),
                    ),
                  )
                else ...[
                  _overview(sessions, scheme),
                  const SizedBox(height: 16),
                  _operationBreakdown(sessions, scheme),
                  const SizedBox(height: 16),
                  _weakAreas(sessions, scheme),
                  const SizedBox(height: 16),
                  _recentSessions(sessions),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _greeting(AppState appState, ColorScheme scheme) {
    final name = appState.hasKidName ? appState.kidName : 'Champion';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: scheme.primary,
              child: const Icon(Icons.emoji_events, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, $name!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Here is how you are doing. Keep it up!'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _overview(List<Session> sessions, ColorScheme scheme) {
    final total = sessions.length;
    final avgScore =
        sessions.map((s) => s.score).reduce((a, b) => a + b) / total;
    final bestScore = sessions.map((s) => s.score).reduce((a, b) => a > b ? a : b);
    final avgAccuracy =
        sessions.map((s) => s.accuracy).reduce((a, b) => a + b) / total;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _stat('Sessions', '$total'),
                _stat('Avg Score', avgScore.toStringAsFixed(0)),
                _stat('Best', '$bestScore'),
                _stat('Avg Acc', '${avgAccuracy.toStringAsFixed(0)}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _operationBreakdown(List<Session> sessions, ColorScheme scheme) {
    // Aggregate correct counts per operation across all sessions.
    final Map<String, int> correctByOp = {};
    final Map<String, int> totalByOp = {};
    for (final s in sessions) {
      s.operationStats.forEach((op, correct) {
        correctByOp[op] = (correctByOp[op] ?? 0) + correct;
        totalByOp[op] = (totalByOp[op] ?? 0) + 1;
      });
    }
    if (correctByOp.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No operation data yet.'),
        ),
      );
    }
    final ops = correctByOp.keys.toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Operation Performance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            for (final op in ops)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: Text(op,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (correctByOp[op] ?? 0) /
                            ((totalByOp[op] ?? 1) * 10).clamp(1, 100),
                        backgroundColor: scheme.surfaceContainerHighest,
                        color: scheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${correctByOp[op]} correct'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _weakAreas(List<Session> sessions, ColorScheme scheme) {
    // Identify operations with low accuracy across sessions.
    final Map<String, int> correctByOp = {};
    final Map<String, int> attemptedByOp = {};
    for (final s in sessions) {
      s.operationStats.forEach((op, correct) {
        correctByOp[op] = (correctByOp[op] ?? 0) + correct;
        attemptedByOp[op] = (attemptedByOp[op] ?? 0) + 1;
      });
    }
    final weak = <String>[];
    correctByOp.forEach((op, correct) {
      final attempted = attemptedByOp[op] ?? 1;
      final accuracy = correct / attempted;
      if (accuracy < 0.7) weak.add(op);
    });
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Areas to Improve',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (weak.isEmpty)
              const Text('Great job! No weak areas detected. 🎉')
            else
              for (final op in weak)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Practice "$op" more to improve your score!',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _recentSessions(List<Session> sessions) {
    final recent = sessions.take(5).toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recent Sessions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final s in recent)
              ListTile(
                dense: true,
                leading: Icon(
                  s.accuracy > 90
                      ? Icons.check_circle
                      : s.accuracy >= 70
                          ? Icons.trending_up
                          : Icons.trending_down,
                  color: s.accuracy > 90
                      ? Colors.green
                      : s.accuracy >= 70
                          ? Colors.orange
                          : Colors.red,
                ),
                title: Text('${s.mode} - ${s.difficulty}'),
                subtitle: Text(
                    '${s.score} pts | ${s.accuracy.toStringAsFixed(0)}% | ${s.correct}/${s.totalProblems}'),
              ),
          ],
        ),
      ),
    );
  }
}