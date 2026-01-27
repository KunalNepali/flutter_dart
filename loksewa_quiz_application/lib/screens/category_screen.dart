import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../models/quiz_category.dart';
import '../services/quiz_service.dart';
import 'quiz_screen.dart';
import 'result_screen.dart';

class CategoryScreen extends StatefulWidget {
  final QuizCategory category;

  const CategoryScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final QuizService _quizService = QuizService();
  bool _hasPreviousAttempt = false;
  double? _previousScore;

  @override
  void initState() {
    super.initState();
    _checkPreviousAttempt();
  }

  Future<void> _checkPreviousAttempt() async {
    final results = await _quizService.getCategoryResults(widget.category.id);
    if (results.isNotEmpty) {
      setState(() {
        _hasPreviousAttempt = true;
        _previousScore = results.last.percentage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      widget.category.icon,
                      style: const TextStyle(fontSize: 48),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.category.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.category.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Stats
            if (_hasPreviousAttempt && _previousScore != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Previous Attempt',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: _previousScore! / 100,
                              backgroundColor:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              color: _getScoreColor(_previousScore!),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${_previousScore!.toStringAsFixed(1)}%',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getScoreColor(_previousScore!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            // Buttons
            PrimaryButton(
              text: 'Start New Quiz',
              onPressed: () async {
                await _quizService.resetQuiz(widget.category.id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      categoryId: widget.category.id,
                    ),
                  ),
                ).then((_) {
                  _checkPreviousAttempt();
                });
              },
              icon: Icons.play_arrow,
            ),
            const SizedBox(height: 12),
            if (_hasPreviousAttempt)
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen(
                        categoryId: widget.category.id,
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'View Previous Results',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            // Instructions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instructions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._buildInstructions(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInstructions() {
    return [
      _buildInstructionItem('Answer all questions before submitting'),
      _buildInstructionItem('You can navigate between questions'),
      _buildInstructionItem('Each question has only one correct answer'),
      _buildInstructionItem('Review explanations after completion'),
    ];
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}