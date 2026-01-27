import '../models/question.dart';
import '../models/quiz_category.dart';
import '../models/quiz_result.dart';
import 'storage_service.dart';

class QuizService {
  // Load all categories
  Future<List<QuizCategory>> getCategories() async {
    return await StorageService.loadCategories();
  }

  // Load questions for a category
  Future<List<Question>> getQuestions(String categoryId) async {
    return await StorageService.loadQuestions(categoryId);
  }

  // Calculate score
  double calculateScore(List<Question> questions) {
    final correctCount = questions
      .where((q) => q.isCorrect)
      .length;
    return (correctCount / questions.length) * 100;
  }

  // Submit quiz and save result
  Future<void> submitQuiz({
    required String categoryId,
    required List<Question> questions,
    required Duration timeTaken,
  }) async {
    final correctAnswers = questions
      .where((q) => q.isCorrect)
      .length;
    
    final score = calculateScore(questions);
    
    final result = QuizResult(
      id: '${DateTime.now().millisecondsSinceEpoch}_$categoryId',
      categoryId: categoryId,
      date: DateTime.now(),
      totalQuestions: questions.length,
      correctAnswers: correctAnswers,
      score: score,
      timeTaken: timeTaken,
      userAnswers: {
        for (var q in questions) 
          q.id: q.selectedAnswerIndex,
      },
    );

    // Save questions with user selections
    await StorageService.saveQuestions(categoryId, questions);
    
    // Save result
    await StorageService.saveResult(result);
    
    // Update category progress
    await StorageService.updateCategoryProgress(categoryId, score);
  }

  // Get results for a category
  Future<List<QuizResult>> getCategoryResults(String categoryId) async {
    final allResults = await StorageService.loadResults();
    return allResults
      .where((result) => result.categoryId == categoryId)
      .toList();
  }

  // Reset quiz for a category
  Future<void> resetQuiz(String categoryId) async {
    final questions = await getQuestions(categoryId);
    final resetQuestions = questions.map((question) {
      return Question(
        id: question.id,
        categoryId: question.categoryId,
        text: question.text,
        options: question.options,
        correctAnswerIndex: question.correctAnswerIndex,
        selectedAnswerIndex: null,
        explanation: question.explanation,
      );
    }).toList();
    
    await StorageService.saveQuestions(categoryId, resetQuestions);
  }
}