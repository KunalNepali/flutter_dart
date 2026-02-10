import 'package:flutter/material.dart';
import 'package:application_for_police_prep/models/quiz_category.dart';
import 'package:application_for_police_prep/services/quiz_service.dart';
import 'package:application_for_police_prep/screens/quiz_screen.dart';
import 'package:application_for_police_prep/screens/syllabus_screen.dart';
import 'package:application_for_police_prep/widgets/category_card.dart';
import 'package:application_for_police_prep/widgets/empty_state.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<List<QuizCategory>> _categoriesFuture;
  final QuizService _quizService = QuizService();

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _quizService.getCategories();
  }

  void _refreshCategories() {
    setState(() {
      _categoriesFuture = _quizService.getCategories();
    });
  }

  void _viewSyllabus() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SyllabusScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
        actions: [
          IconButton(
            icon: const Icon(Icons.book),
            onPressed: _viewSyllabus,
            tooltip: 'View Syllabus',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCategories,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<List<QuizCategory>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return EmptyState(
              icon: Icons.error_outline,
              title: 'Error Loading Categories',
              message: 'Please try again later',
              actionText: 'Retry',
              onAction: _refreshCategories,
            );
          }

          final categories = snapshot.data ?? [];

          if (categories.isEmpty) {
            return EmptyState(
              icon: Icons.category,
              title: 'No Categories Available',
              message: 'Categories will be added soon',
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryCard(
                category: category,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(categoryId: category.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
