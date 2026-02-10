import 'package:flutter/material.dart';
import 'package:application_for_police_prep/models/question.dart';
import 'package:application_for_police_prep/services/storage_service.dart';
import 'package:application_for_police_prep/screens/categories_screen.dart';
import 'package:application_for_police_prep/screens/quiz_screen.dart';
import 'package:application_for_police_prep/widgets/result_summary.dart';
import 'package:application_for_police_prep/widgets/action_button.dart';

class ResultsScreen extends StatefulWidget {
  final String categoryId;
  final Map<String, dynamic> score;
  final Duration timeTaken;
  final List<Question> questions;

  const ResultsScreen({
    super.key,
    required this.categoryId,
    required this.score,
    required this.timeTaken,
    required this.questions,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  void initState() {
    super.initState();
    _saveResult();
  }

  Future<void> _saveResult() async {
    final result = {
      'id': '${widget.categoryId}_${DateTime.now().millisecondsSinceEpoch}',
      'categoryId': widget.categoryId,
      'timestamp': DateTime.now().toIso8601String(),
      'totalQuestions': widget.score['total'],
      'correctAnswers': widget.score['correct'],
      'incorrectAnswers': widget.score['incorrect'],
      'skippedQuestions': widget.score['skipped'],
      'score': widget.score['score'],
      'timeTaken': widget.timeTaken.inMilliseconds,
      'details': {
        'questions': widget.questions.map((q) => q.toJson()).toList(),
      },
    };

    await StorageService.saveResult(result);
  }

  void _restartQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(categoryId: widget.categoryId),
      ),
    );
  }

  void _goToCategories() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const CategoriesScreen()),
      (route) => false,
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 75) return Colors.green;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Results')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    '${widget.score['score']?.toStringAsFixed(1) ?? '0'}%',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: _getScoreColor(widget.score['score'] ?? 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.score['score']! >= 50
                        ? 'Passed!'
                        : 'Needs Improvement',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Correct',
                        widget.score['correct'].toString(),
                        Colors.green,
                      ),
                      _buildStatItem(
                        'Incorrect',
                        widget.score['incorrect'].toString(),
                        Colors.red,
                      ),
                      _buildStatItem(
                        'Skipped',
                        widget.score['skipped'].toString(),
                        Colors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ResultSummary(questions: widget.questions),
            const SizedBox(height: 20),
            Text(
              'Time Taken: ${_formatDuration(widget.timeTaken)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ActionButton(
                  text: 'Retry',
                  icon: Icons.refresh,
                  onPressed: _restartQuiz,
                ),
                ActionButton(
                  text: 'Home',
                  icon: Icons.home,
                  onPressed: _goToCategories,
                  isPrimary: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }
}
