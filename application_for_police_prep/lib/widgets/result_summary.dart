import 'package:flutter/material.dart';
import 'package:application_for_police_prep/models/question.dart';

class ResultSummary extends StatelessWidget {
  final List<Question> questions;

  const ResultSummary({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    final correctQuestions = questions.where((q) => q.isCorrect).toList();
    final incorrectQuestions = questions
        .where((q) => q.isAttempted && !q.isCorrect)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Summary', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        if (correctQuestions.isNotEmpty) ...[
          _buildQuestionList('Correct Answers', correctQuestions, Colors.green),
          const SizedBox(height: 20),
        ],
        if (incorrectQuestions.isNotEmpty) ...[
          _buildQuestionList(
            'Incorrect Answers',
            incorrectQuestions,
            Colors.red,
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Widget _buildQuestionList(
    String title,
    List<Question> questions,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              '$title (${questions.length})',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...questions.asMap().entries.map((entry) {
          final index = entry.key;
          final question = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.questionText,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
