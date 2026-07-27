class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      id: map['id'] ?? '',
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctIndex: map['correctIndex'] ?? 0,
      explanation: map['explanation'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'question': question,
    'options': options,
    'correctIndex': correctIndex,
    'explanation': explanation,
  };
}

class QuizResult {
  final String lessonId;
  final int score;
  final int total;
  final DateTime completedAt;
  final bool passed;

  QuizResult({
    required this.lessonId,
    required this.score,
    required this.total,
    required this.completedAt,
    required this.passed,
  });

  double get percentage => total == 0 ? 0 : (score / total) * 100;
}
