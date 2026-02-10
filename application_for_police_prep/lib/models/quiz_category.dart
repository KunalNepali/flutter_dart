class QuizCategory {
  final String id;
  final String name;
  final String description;
  final int totalQuestions;
  final int completedQuestions;
  final double progress;
  final bool isCompleted;
  final String icon;

  QuizCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.totalQuestions,
    this.completedQuestions = 0,
    this.progress = 0.0,
    this.isCompleted = false,
    required this.icon,
  });

  QuizCategory copyWith({
    String? id,
    String? name,
    String? description,
    int? totalQuestions,
    int? completedQuestions,
    double? progress,
    bool? isCompleted,
    String? icon,
  }) {
    return QuizCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      completedQuestions: completedQuestions ?? this.completedQuestions,
      progress: progress ?? this.progress,
      isCompleted: isCompleted ?? this.isCompleted,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'totalQuestions': totalQuestions,
      'completedQuestions': completedQuestions,
      'progress': progress,
      'isCompleted': isCompleted,
      'icon': icon,
    };
  }

  factory QuizCategory.fromJson(Map<String, dynamic> json) {
    return QuizCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      totalQuestions: json['totalQuestions'],
      completedQuestions: json['completedQuestions'] ?? 0,
      progress: json['progress']?.toDouble() ?? 0.0,
      isCompleted: json['isCompleted'] ?? false,
      icon: json['icon'],
    );
  }
}
