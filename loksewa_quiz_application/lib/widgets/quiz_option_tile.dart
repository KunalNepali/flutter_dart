import 'package:flutter/material.dart';

class QuizOptionTile extends StatelessWidget {
  final String option;
  final String optionText;
  final bool isSelected;
  final bool isCorrect;
  final bool showAnswer;
  final VoidCallback onTap;

  const QuizOptionTile({
    Key? key,
    required this.option,
    required this.optionText,
    required this.isSelected,
    required this.isCorrect,
    required this.showAnswer,
    required this.onTap,
  }) : super(key: key);

  Color _getBackgroundColor(BuildContext context) {
    if (showAnswer) {
      if (isCorrect) {
        return Colors.green.withOpacity(0.2);
      } else if (isSelected && !isCorrect) {
        return Colors.red.withOpacity(0.2);
      }
    } else if (isSelected) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.2);
    }
    return Theme.of(context).colorScheme.surface;
  }

  Color _getBorderColor(BuildContext context) {
    if (showAnswer) {
      if (isCorrect) {
        return Colors.green;
      } else if (isSelected && !isCorrect) {
        return Colors.red;
      }
    } else if (isSelected) {
      return Theme.of(context).colorScheme.primary;
    }
    return Theme.of(context).colorScheme.outline.withOpacity(0.5);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showAnswer ? null : onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getBorderColor(context),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getBorderColor(context),
                ),
              ),
              child: Center(
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                optionText,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            if (showAnswer && isCorrect)
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
            if (showAnswer && isSelected && !isCorrect)
              Icon(
                Icons.cancel,
                color: Colors.red,
              ),
          ],
        ),
      ),
    );
  }
}