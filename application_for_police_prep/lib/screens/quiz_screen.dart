import 'package:flutter/material.dart';
import 'package:application_for_police_prep/models/question.dart';
import 'package:application_for_police_prep/services/quiz_service.dart';
import 'package:application_for_police_prep/services/storage_service.dart';
import 'package:application_for_police_prep/screens/results_screen.dart';
import 'package:application_for_police_prep/widgets/option_tile.dart';
import 'package:application_for_police_prep/widgets/action_button.dart';

class QuizScreen extends StatefulWidget {
  final String categoryId;

  const QuizScreen({super.key, required this.categoryId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Question>> _questionsFuture;
  final QuizService _quizService = QuizService();
  late PageController _pageController;
  List<Question> _questions = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadQuestions();
    _startTime = DateTime.now();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    final questions = await _quizService.loadQuestions(widget.categoryId);
    final progress = await StorageService.loadProgress(widget.categoryId);

    if (progress != null && progress['answers'] != null) {
      final savedAnswers = Map<String, dynamic>.from(progress['answers']);

      for (var i = 0; i < questions.length; i++) {
        final savedAnswer = savedAnswers[questions[i].id];
        if (savedAnswer != null) {
          final bool isCorrect =
              savedAnswer['selectedIndex'] == questions[i].correctAnswerIndex;
          _questions[i] = questions[i].copyWith(
            isAttempted: true,
            selectedAnswerIndex: savedAnswer['selectedIndex'],
            isCorrect: isCorrect,
          );
        }
      }
    }

    setState(() {
      _questions = questions;
      _isLoading = false;
    });
  }

  void _selectAnswer(int optionIndex) {
    if (_questions[_currentIndex].isAttempted) return;

    final bool isCorrect =
        optionIndex == _questions[_currentIndex].correctAnswerIndex;

    setState(() {
      _questions[_currentIndex] = _questions[_currentIndex].copyWith(
        isAttempted: true,
        selectedAnswerIndex: optionIndex,
        isCorrect: isCorrect,
      );
    });

    // Save progress
    _saveProgress();

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect ? 'Correct!' : 'Incorrect. Try again!',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _saveProgress() async {
    final answers = {};
    for (var question in _questions) {
      if (question.isAttempted) {
        answers[question.id] = {
          'selectedIndex': question.selectedAnswerIndex,
          'isCorrect': question.isCorrect,
        };
      }
    }

    final progress = {
      'answers': answers,
      'lastQuestionIndex': _currentIndex,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await StorageService.saveProgress(widget.categoryId, progress);
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitQuiz() {
    final score = _quizService.calculateScore(_questions);
    final timeTaken = DateTime.now().difference(_startTime!);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          categoryId: widget.categoryId,
          score: score,
          timeTaken: timeTaken,
          questions: _questions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentIndex + 1}/${_questions.length}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: _submitQuiz,
            tooltip: 'Submit Quiz',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                LinearProgressIndicator(
                  value: (_currentIndex + 1) / _questions.length,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _questions.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final question = _questions[index];
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Question ${index + 1}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              question.questionText,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 30),
                            ...question.options.asMap().entries.map((entry) {
                              final optionIndex = entry.key;
                              final optionText = entry.value;
                              return OptionTile(
                                optionText: optionText,
                                optionIndex: optionIndex,
                                isSelected:
                                    question.selectedAnswerIndex == optionIndex,
                                isCorrect:
                                    question.correctAnswerIndex == optionIndex,
                                isAttempted: question.isAttempted,
                                onTap: () => _selectAnswer(optionIndex),
                              );
                            }),
                            const SizedBox(height: 30),
                            if (question.isAttempted &&
                                question.explanation.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Explanation:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(question.explanation),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ActionButton(
                        text: 'Previous',
                        icon: Icons.arrow_back,
                        onPressed: _currentIndex > 0 ? _previousQuestion : null,
                      ),
                      ActionButton(
                        text: _currentIndex == _questions.length - 1
                            ? 'Submit'
                            : 'Next',
                        icon: _currentIndex == _questions.length - 1
                            ? Icons.check
                            : Icons.arrow_forward,
                        onPressed: _currentIndex == _questions.length - 1
                            ? _submitQuiz
                            : _nextQuestion,
                        isPrimary: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
