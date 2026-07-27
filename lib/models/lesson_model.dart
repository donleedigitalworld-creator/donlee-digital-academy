import 'quiz_model.dart';

class LessonStep {
  final int order;
  final String title;
  final String description;
  final String? imageUrl;
  final String? tip;

  LessonStep({
    required this.order,
    required this.title,
    required this.description,
    this.imageUrl,
    this.tip,
  });

  factory LessonStep.fromMap(Map<String, dynamic> map) {
    return LessonStep(
      order: map['order'] ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'],
      tip: map['tip'],
    );
  }
}

class LessonModel {
  final String id;
  final String moduleId;
  final String moduleTitle;
  final String title;
  final String description;
  final String longDescription;
  final String thumbnailUrl;
  final List<String> imageUrls;
  final List<LessonStep> steps;
  final List<QuizQuestion> quiz;
  final int difficulty; // 1-3
  final int estimatedMinutes;
  final bool isFeatured;
  final bool isPremium;

  LessonModel({
    required this.id,
    required this.moduleId,
    required this.moduleTitle,
    required this.title,
    required this.description,
    required this.longDescription,
    required this.thumbnailUrl,
    this.imageUrls = const [],
    this.steps = const [],
    this.quiz = const [],
    this.difficulty = 1,
    this.estimatedMinutes = 15,
    this.isFeatured = false,
    this.isPremium = false,
  });

  factory LessonModel.fromMap(Map<String, dynamic> map) {
    return LessonModel(
      id: map['id'] ?? '',
      moduleId: map['moduleId'] ?? '',
      moduleTitle: map['moduleTitle'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      longDescription: map['longDescription'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      steps: (map['steps'] as List? ?? []).map((e) => LessonStep.fromMap(e)).toList(),
      quiz: (map['quiz'] as List? ?? []).map((e) => QuizQuestion.fromMap(e)).toList(),
      difficulty: map['difficulty'] ?? 1,
      estimatedMinutes: map['estimatedMinutes'] ?? 15,
      isFeatured: map['isFeatured'] ?? false,
      isPremium: map['isPremium'] ?? false,
    );
  }
}

class ModuleModel {
  final String id;
  final String title;
  final String description;
  final String icon; // emoji or icon name for MVP
  final String thumbnailUrl;
  final int lessonCount;
  final int order;
  final List<String> learningOutcomes;

  ModuleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.thumbnailUrl,
    required this.lessonCount,
    required this.order,
    this.learningOutcomes = const [],
  });
}
