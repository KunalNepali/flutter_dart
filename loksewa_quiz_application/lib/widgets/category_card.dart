import 'package:flutter/material.dart';
import '../models/quiz_category.dart';

class CategoryCard extends StatelessWidget {
  final QuizCategory category;
  final VoidCallback onTap;
  final Color? backgroundColor;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.onTap,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: backgroundColor ?? Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category.icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                  if (category.isCompleted)
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                category.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                category.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Chip(
                    label: Text('${category.questionCount} Questions'),
                    backgroundColor: 
                      Theme.of(context).colorScheme.primaryContainer,
                  ),
                  const Spacer(),
                  if (category.highestScore > 0)
                    Chip(
                      label: Text('Best: ${category.highestScore.toStringAsFixed(0)}%'),
                      backgroundColor: 
                        Theme.of(context).colorScheme.secondaryContainer,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}