
class Question {
  final String id;
  final String categoryId;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  String? selectedAnswerIndex;
  final String explanation;

  Question({
    required this.id,
    required this.categoryId,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    this.selectedAnswerIndex,
    required this.explanation,
  });

  bool get isCorrect => selectedAnswerIndex != null 
    ? selectedAnswerIndex == correctAnswerIndex.toString()
    : false;

  Map<String, dynamic> toJson() => {
    'id': id,
    'categoryId': categoryId,
    'text': text,
    'options': options,
    'correctAnswerIndex': correctAnswerIndex,
    'selectedAnswerIndex': selectedAnswerIndex,
    'explanation': explanation,
  };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json['id'],
    categoryId: json['categoryId'],
    text: json['text'],
    options: List<String>.from(json['options']),
    correctAnswerIndex: json['correctAnswerIndex'],
    selectedAnswerIndex: json['selectedAnswerIndex'],
    explanation: json['explanation'],
  );
}