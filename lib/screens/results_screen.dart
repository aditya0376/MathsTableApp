import 'package:flutter/material.dart';

import '../data/history_dao.dart';
import '../models/cartoon_character.dart';
import '../models/session.dart';
import '../widgets/cartoon_character_view.dart';
import 'home_screen.dart';

/// Results screen shown after a practice session.
class ResultsScreen extends StatefulWidget {
  final Session session;

  const ResultsScreen({super.key, required this.session});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final HistoryDao _dao = HistoryDao();
  late final CartoonCharacter _character;

  @override
  void initState() {
    super.initState();
    _save();
    _character = cartoonCharacters[
        DateTime.now().millisecondsSinceEpoch % cartoonCharacters.length];
  }

  Future<void> _save() async {
    await _dao.saveSession(widget.session);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.session;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
              const SizedBox(height: 8),
              Text(
                s.rating,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              _buildCharacterCard(),
              const SizedBox(height: 24),
              _metricCard('Final Score', '${s.score}', Icons.stars),
              const SizedBox(height: 12),
              _metricCard('Accuracy', '${s.accuracy.toStringAsFixed(1)}%',
                  Icons.percent),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _metricCard(
                        'Correct', '${s.correct}', Icons.check_circle),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _metricCard(
                        'Wrong', '${s.wrong}', Icons.cancel),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _metricCard(
                  'Problems', '${s.totalProblems}', Icons.calculate),
              const SizedBox(height: 12),
              _metricCard(
                  'Duration', '${s.durationSeconds}s', Icons.timer),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      ),
                      child: const Text('Home'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Retry'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterCard() {
    return Card(
      color: _character.color.withValues(alpha: 0.15),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CartoonCharacterView(
              type: _character.type,
              size: 72,
              primaryColor: _character.color,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _character.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _character.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _character.commentFor(widget.session.score),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricCard(String label, String value, IconData icon) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        leading: Icon(icon, color: scheme.primary),
        title: Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text(label),
      ),
    );
  }
}