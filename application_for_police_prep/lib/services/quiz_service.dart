import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';
import '../models/quiz_category.dart';
import 'storage_service.dart';

class QuizService {
  static final QuizService _instance = QuizService._internal();
  factory QuizService() => _instance;
  QuizService._internal();

  // Load questions from JSON asset
  Future<List<Question>> loadQuestions(String categoryId) async {
    try {
      final data = await rootBundle.loadString('assets/data/questions.json');
      final jsonData = json.decode(data);
      final categoryQuestions = jsonData[categoryId];

      if (categoryQuestions == null) {
        return _getSampleQuestions(categoryId);
      }

      return List<Question>.from(
        categoryQuestions.map((q) => Question.fromJson(q)),
      );
    } catch (e) {
      print('Error loading questions: $e');
      return _getSampleQuestions(categoryId);
    }
  }

  // Get available categories
  Future<List<QuizCategory>> getCategories() async {
    final categories = [
      QuizCategory(
        id: 'geography',
        name: 'Geography',
        description: 'Nepal and world geography',
        totalQuestions: 50,
        icon: '🌍',
      ),
      QuizCategory(
        id: 'history',
        name: 'History',
        description: 'Nepal and world history',
        totalQuestions: 60,
        icon: '📜',
      ),
      QuizCategory(
        id: 'current_affairs',
        name: 'Current Affairs',
        description: 'Latest national and international news',
        totalQuestions: 40,
        icon: '📰',
      ),
      QuizCategory(
        id: 'mathematics',
        name: 'Mathematics',
        description: 'Quantitative aptitude',
        totalQuestions: 45,
        icon: '🧮',
      ),
      QuizCategory(
        id: 'critical_thinking',
        name: 'Critical Thinking',
        description: 'Logical reasoning and analysis',
        totalQuestions: 35,
        icon: '💭',
      ),
      QuizCategory(
        id: 'first_paper',
        name: 'First Paper',
        description: 'General knowledge and aptitude',
        totalQuestions: 100,
        icon: '📄',
      ),
      QuizCategory(
        id: 'second_paper',
        name: 'Second Paper',
        description: 'Professional knowledge',
        totalQuestions: 100,
        icon: '📄',
      ),
      QuizCategory(
        id: 'third_paper',
        name: 'Third Paper',
        description: 'Interview preparation',
        totalQuestions: 80,
        icon: '📄',
      ),
      QuizCategory(
        id: 'asi',
        name: 'ASI',
        description: 'Assistant Sub-Inspector exam',
        totalQuestions: 120,
        icon: '👮',
      ),
      QuizCategory(
        id: 'inspector',
        name: 'Inspector',
        description: 'Police Inspector exam',
        totalQuestions: 150,
        icon: '👮‍♂️',
      ),
    ];

    // Load progress from storage
    final progress = await StorageService.loadCategories();
    if (progress != null) {
      return categories.map((category) {
        final catProgress = progress.firstWhere(
          (p) => p['id'] == category.id,
          orElse: () => {},
        );
        if (catProgress.isNotEmpty) {
          return category.copyWith(
            completedQuestions: catProgress['completedQuestions'],
            progress: catProgress['progress'],
            isCompleted: catProgress['isCompleted'],
          );
        }
        return category;
      }).toList();
    }

    return categories;
  }

  // Calculate score
  Map<String, dynamic> calculateScore(List<Question> questions) {
    final correct = questions.where((q) => q.isCorrect).length;
    final attempted = questions.where((q) => q.isAttempted).length;
    final total = questions.length;
    final score = total > 0 ? (correct / total * 100) : 0;

    return {
      'correct': correct,
      'incorrect': attempted - correct,
      'skipped': total - attempted,
      'total': total,
      'score': score,
      'percentage': score,
    };
  }

  // Sample questions for demo
  List<Question> _getSampleQuestions(String categoryId) {
    return [
      Question(
        id: '1',
        categoryId: categoryId,
        questionText: 'What is the capital of Nepal?',
        options: ['Pokhara', 'Kathmandu', 'Biratnagar', 'Lalitpur'],
        correctAnswerIndex: 1,
        explanation: 'Kathmandu is the capital and largest city of Nepal.',
      ),
      Question(
        id: '2',
        categoryId: categoryId,
        questionText: 'Which is the highest mountain in the world?',
        options: ['K2', 'Kangchenjunga', 'Mount Everest', 'Lhotse'],
        correctAnswerIndex: 2,
        explanation: 'Mount Everest is the highest mountain above sea level.',
      ),
    ];
  }
}
