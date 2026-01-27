
class QuizCategory {
  final String id;
  final String name;
  final String description;
  final int questionCount;
  final String icon;
  bool isCompleted;
  double highestScore;

  QuizCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.questionCount,
    required this.icon,
    this.isCompleted = false,
    this.highestScore = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'questionCount': questionCount,
    'icon': icon,
    'isCompleted': isCompleted,
    'highestScore': highestScore,
  };

  factory QuizCategory.fromJson(Map<String, dynamic> json) => QuizCategory(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    questionCount: json['questionCount'],
    icon: json['icon'],
    isCompleted: json['isCompleted'] ?? false,
    highestScore: json['highestScore']?.toDouble() ?? 0.0,
  );
}