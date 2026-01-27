class QuizResult {
  final String id;
  final String categoryId;
  final DateTime date;
  final int totalQuestions;
  final int correctAnswers;
  final double score;
  final Duration timeTaken;
  final Map<String, String?> userAnswers;

  QuizResult({
    required this.id,
    required this.categoryId,
    required this.date,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.score,
    required this.timeTaken,
    required this.userAnswers,
  });

  double get percentage => (correctAnswers / totalQuestions) * 100;

  Map<String, dynamic> toJson() => {
    'id': id,
    'categoryId': categoryId,
    'date': date.toIso8601String(),
    'totalQuestions': totalQuestions,
    'correctAnswers': correctAnswers,
    'score': score,
    'timeTaken': timeTaken.inSeconds,
    'userAnswers': userAnswers,
  };

  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
    id: json['id'],
    categoryId: json['categoryId'],
    date: DateTime.parse(json['date']),
    totalQuestions: json['totalQuestions'],
    correctAnswers: json['correctAnswers'],
    score: json['score'].toDouble(),
    timeTaken: Duration(seconds: json['timeTaken']),
    userAnswers: Map<String, String?>.from(json['userAnswers']),
  );
}