import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final String optionText;
  final int optionIndex;
  final bool isSelected;
  final bool isCorrect;
  final bool isAttempted;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.optionText,
    required this.optionIndex,
    required this.isSelected,
    required this.isCorrect,
    required this.isAttempted,
    required this.onTap,
  });

  Color _getOptionColor(BuildContext context) {
    if (!isAttempted) {
      return isSelected
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.surfaceVariant;
    }

    if (isSelected) {
      return isCorrect ? Colors.green : Colors.red;
    }

    if (isCorrect) {
      return Colors.green;
    }

    return Theme.of(context).colorScheme.surfaceVariant;
  }

  Color _getTextColor(BuildContext context) {
    if (!isAttempted) {
      return isSelected
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.onSurface;
    }

    if (isSelected || isCorrect) {
      return Colors.white;
    }

    return Theme.of(context).colorScheme.onSurface;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getOptionColor(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getTextColor(context).withOpacity(0.1),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + optionIndex), // A, B, C, D
                    style: TextStyle(
                      color: _getTextColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  optionText,
                  style: TextStyle(color: _getTextColor(context), fontSize: 16),
                ),
              ),
              if (isAttempted && (isSelected || isCorrect))
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: Colors.white,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
