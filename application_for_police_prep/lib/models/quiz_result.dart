class QuizResult {
  final String id;
  final String categoryId;
  final DateTime timestamp;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final int skippedQuestions;
  final double score;
  final Duration timeTaken;
  final Map<String, dynamic> details;

  QuizResult({
    required this.id,
    required this.categoryId,
    required this.timestamp,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.skippedQuestions,
    required this.score,
    required this.timeTaken,
    required this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'timestamp': timestamp.toIso8601String(),
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'incorrectAnswers': incorrectAnswers,
      'skippedQuestions': skippedQuestions,
      'score': score,
      'timeTaken': timeTaken.inMilliseconds,
      'details': details,
    };
  }

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['id'],
      categoryId: json['categoryId'],
      timestamp: DateTime.parse(json['timestamp']),
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      incorrectAnswers: json['incorrectAnswers'],
      skippedQuestions: json['skippedQuestions'],
      score: json['score'].toDouble(),
      timeTaken: Duration(milliseconds: json['timeTaken']),
      details: Map<String, dynamic>.from(json['details']),
    );
  }
}
