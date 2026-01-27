import 'package:flutter/material.dart';
import '../models/quiz_result.dart';

class ResultSummary extends StatelessWidget {
  final QuizResult result;

  const ResultSummary({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Score Circle
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getScoreColor(result.percentage),
                  width: 8,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${result.percentage.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(result.percentage),
                      ),
                    ),
                    Text(
                      'Score',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildStatCard(
                  context,
                  'Correct',
                  '${result.correctAnswers}',
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildStatCard(
                  context,
                  'Incorrect',
                  '${result.totalQuestions - result.correctAnswers}',
                  Icons.cancel,
                  Colors.red,
                ),
                _buildStatCard(
                  context,
                  'Total',
                  '${result.totalQuestions}',
                  Icons.format_list_numbered,
                  Theme.of(context).colorScheme.primary,
                ),
                _buildStatCard(
                  context,
                  'Time Taken',
                  '${result.timeTaken.inMinutes}:${(result.timeTaken.inSeconds % 60).toString().padLeft(2, '0')}',
                  Icons.timer,
                  Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Date
            Text(
              'Completed on ${_formatDate(result.date)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}