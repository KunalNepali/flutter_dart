import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../widgets/result_summary.dart';
import '../models/quiz_result.dart';
import '../services/quiz_service.dart';
import 'quiz_screen.dart'; // Add this import

class ResultScreen extends StatefulWidget {
  final String categoryId;
  final bool showLatest;

  const ResultScreen({
    Key? key,
    required this.categoryId,
    this.showLatest = false,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final QuizService _quizService = QuizService();
  List<QuizResult> _results = [];
  QuizResult? _latestResult;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    setState(() => _isLoading = true);
    _results = await _quizService.getCategoryResults(widget.categoryId);
    if (_results.isNotEmpty) {
      _latestResult = _results.last;
    }
    setState(() => _isLoading = false);
  }

  String _getPerformanceMessage(double percentage) {
    if (percentage >= 90) return 'Excellent! You mastered this category.';
    if (percentage >= 75) return 'Great job! You have good understanding.';
    if (percentage >= 60) return 'Good effort! Keep practicing.';
    if (percentage >= 40) return 'You need more practice.';
    return 'Keep studying and try again.';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_results.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('No Results'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.quiz_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                'No quiz results yet',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Complete a quiz to see your results here',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final displayResult = widget.showLatest ? _latestResult : _results.last;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadResults,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Latest result
            if (displayResult != null) ...[
              ResultSummary(result: displayResult),
              const SizedBox(height: 24),
              // Performance message
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        _getPerformanceMessage(displayResult.percentage),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Accuracy: ${displayResult.percentage.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getScoreColor(displayResult.percentage),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            // History
            if (_results.length > 1) ...[
              Text(
                'Previous Attempts',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ..._results.reversed.skip(1).take(3).map((result) {
                return _buildHistoryItem(context, result);
              }).toList(),
            ],
            const SizedBox(height: 32),
            // Action Buttons
            PrimaryButton(
              text: 'Retake Quiz',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      categoryId: widget.categoryId,
                    ),
                  ),
                );
              },
              icon: Icons.replay,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Back to Categories',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, QuizResult result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getScoreColor(result.percentage).withOpacity(0.2),
          child: Text(
            '${result.percentage.toInt()}%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getScoreColor(result.percentage),
            ),
          ),
        ),
        title: Text(
          _formatDate(result.date),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          '${result.correctAnswers}/${result.totalQuestions} correct answers',
        ),
        trailing: Chip(
          label: Text(
            '${result.timeTaken.inMinutes}:${(result.timeTaken.inSeconds % 60).toString().padLeft(2, '0')}',
          ),
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        ),
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}