import 'package:flutter/material.dart';
import '../widgets/quiz_option_tile.dart';
import '../widgets/primary_button.dart';
import '../models/question.dart';
import '../services/quiz_service.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String categoryId;

  const QuizScreen({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizService _quizService = QuizService();
  late PageController _pageController;
  List<Question> _questions = [];
  int _currentPage = 0;
  bool _isSubmitting = false;
  DateTime _startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadQuestions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    final questions = await _quizService.getQuestions(widget.categoryId);
    setState(() {
      _questions = questions;
    });
  }

  void _selectAnswer(String answerIndex) {
    setState(() {
      _questions[_currentPage].selectedAnswerIndex = answerIndex;
    });
  }

  Future<void> _submitQuiz() async {
    setState(() => _isSubmitting = true);

    final timeTaken = DateTime.now().difference(_startTime);

    await _quizService.submitQuiz(
      categoryId: widget.categoryId,
      questions: _questions,
      timeTaken: timeTaken,
    );

    // Navigate to result screen
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          categoryId: widget.categoryId,
          showLatest: true,
        ),
      ),
    );
  }

  void _showSubmitConfirmation() {
    final answeredCount = _questions
        .where((q) => q.selectedAnswerIndex != null)
        .length;
    final totalQuestions = _questions.length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Quiz'),
        content: Text(
          'You have answered $answeredCount out of $totalQuestions questions. '
          'Are you sure you want to submit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _submitQuiz,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentQuestion = _questions[_currentPage];
    final totalQuestions = _questions.length;
    final answeredCount = _questions
        .where((q) => q.selectedAnswerIndex != null)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentPage + 1}/$totalQuestions'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Chip(
                label: Text('$answeredCount/$totalQuestions'),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: (_currentPage + 1) / totalQuestions,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            color: Theme.of(context).colorScheme.primary,
            minHeight: 4,
          ),
          // Question area
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: totalQuestions,
              itemBuilder: (context, index) {
                final question = _questions[index];
                return _buildQuestionPage(question);
              },
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
            ),
          ),
          // Navigation
          _buildNavigationButtons(),
        ],
      ),
      bottomNavigationBar: _isSubmitting
          ? const LinearProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: PrimaryButton(
                text: 'Submit Quiz',
                onPressed: _showSubmitConfirmation,
                icon: Icons.send,
              ),
            ),
    );
  }

  Widget _buildQuestionPage(Question question) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question text
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                question.text,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Options
          ...List.generate(question.options.length, (index) {
            final option = String.fromCharCode(65 + index); // A, B, C, D
            return QuizOptionTile(
              option: option,
              optionText: question.options[index],
              isSelected: question.selectedAnswerIndex == index.toString(),
              isCorrect: index == question.correctAnswerIndex,
              showAnswer: false,
              onTap: () => _selectAnswer(index.toString()),
            );
          }),
          const SizedBox(height: 24),
          // Explanation (if answered)
          if (question.selectedAnswerIndex != null)
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explanation:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(question.explanation),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _currentPage > 0
                  ? () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  : null,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back),
                  SizedBox(width: 8),
                  Text('Previous'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _currentPage < _questions.length - 1
                  ? () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Next'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}