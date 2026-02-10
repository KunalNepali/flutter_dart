class Question {
  final String id;
  final String categoryId;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final bool isAttempted;
  final int? selectedAnswerIndex;
  final bool isCorrect;

  Question({
    required this.id,
    required this.categoryId,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    this.isAttempted = false,
    this.selectedAnswerIndex,
    this.isCorrect = false,
  });

  Question copyWith({
    String? id,
    String? categoryId,
    String? questionText,
    List<String>? options,
    int? correctAnswerIndex,
    String? explanation,
    bool? isAttempted,
    int? selectedAnswerIndex,
    bool? isCorrect,
  }) {
    return Question(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
      explanation: explanation ?? this.explanation,
      isAttempted: isAttempted ?? this.isAttempted,
      selectedAnswerIndex: selectedAnswerIndex ?? this.selectedAnswerIndex,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'questionText': questionText,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'isAttempted': isAttempted,
      'selectedAnswerIndex': selectedAnswerIndex,
      'isCorrect': isCorrect,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      categoryId: json['categoryId'],
      questionText: json['questionText'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
      explanation: json['explanation'],
      isAttempted: json['isAttempted'] ?? false,
      selectedAnswerIndex: json['selectedAnswerIndex'],
      isCorrect: json['isCorrect'] ?? false,
    );
  }
}
