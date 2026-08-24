import 'package:flutter/material.dart';

import '../data/history_dao.dart';
import '../models/session.dart';

/// History screen: chronological list of past sessions with statistics.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryDao _dao = HistoryDao();
  late Future<List<Session>> _sessions;
  Map<String, double> _stats = {};

  @override
  void initState() {
    super.initState();
    _sessions = _dao.getAllSessions();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await _dao.getStatistics();
    if (mounted) setState(() => _stats = stats);
  }

  Future<void> _refresh() async {
    setState(() {
      _sessions = _dao.getAllSessions();
    });
    await _loadStats();
  }

  Future<void> _confirmClear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear history?'),
        content: const Text('This will delete all saved sessions.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _dao.clearHistory();
      await _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _confirmClear,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildStats(),
            const SizedBox(height: 16),
            FutureBuilder<List<Session>>(
              future: _sessions,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                final sessions = snapshot.data ?? [];
                if (sessions.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text('No sessions yet. Start practicing!'),
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final s in sessions) _sessionTile(s),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Statistics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _stat('Sessions', '${_stats['totalSessions']?.toInt() ?? 0}'),
                _stat('Avg Score', '${_stats['averageScore']?.toStringAsFixed(0) ?? 0}'),
                _stat('Best', '${_stats['bestScore']?.toInt() ?? 0}'),
                _stat('Avg Acc', '${_stats['averageAccuracy']?.toStringAsFixed(0) ?? 0}%'),
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
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _sessionTile(Session s) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: scheme.primaryContainer,
          child: Text(
            '${s.score}',
            style: TextStyle(color: scheme.onPrimaryContainer),
          ),
        ),
        title: Text('${s.mode} - ${s.difficulty}'),
        subtitle: Text(
          '${_formatDate(s.date)}  |  ${s.correct}/${s.totalProblems} correct  |  '
          '${s.accuracy.toStringAsFixed(0)}%',
        ),
        trailing: Text(
          s.rating,
          style: TextStyle(
            color: s.accuracy > 90
                ? Colors.green
                : s.accuracy >= 70
                    ? Colors.orange
                    : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day}/${d.month}/${d.year} ${d.hour.toString().padLeft(2, '0')}:'
        '${d.minute.toString().padLeft(2, '0')}';
  }
}