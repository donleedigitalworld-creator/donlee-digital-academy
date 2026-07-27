import 'package:flutter/material.dart';

enum AIMessageRole { user, assistant, system }
enum AITutorPersonality { friendly, professional, encouraging, sokratic }
enum AIFeedbackType { proportion, shading, composition, anatomy, perspective, color, lineQuality }
enum AIChallengeDifficulty { beginner, intermediate, advanced, master }
enum AIStudyGoal { dailyPractice, examPrep, competitionPrep, portfolioBuilding, skillMastery }

class AIMessage {
  final String id;
  final AIMessageRole role;
  final String content;
  final DateTime timestamp;
  final List<String>? imageUrls;
  final Map<String, dynamic>? metadata;
  final bool isVoice;
  final String? audioPath;

  AIMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.imageUrls,
    this.metadata,
    this.isVoice = false,
    this.audioPath,
  });

  factory AIMessage.fromMap(Map<String, dynamic> map) {
    return AIMessage(
      id: map['id'] ?? '',
      role: AIMessageRole.values.byName(map['role'] ?? 'user'),
      content: map['content'] ?? '',
      timestamp: map['timestamp'] != null ? DateTime.parse(map['timestamp']) : DateTime.now(),
      imageUrls: map['imageUrls'] != null ? List<String>.from(map['imageUrls']) : null,
      metadata: map['metadata'] != null ? Map<String, dynamic>.from(map['metadata']) : null,
      isVoice: map['isVoice'] ?? false,
      audioPath: map['audioPath'],
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'role': role.name,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
    'imageUrls': imageUrls,
    'metadata': metadata,
    'isVoice': isVoice,
    'audioPath': audioPath,
  };
}

class AITutorSession {
  final String id;
  final String studentId;
  final String topic; // e.g. "Loomis Method"
  final AITutorPersonality personality;
  final List<AIMessage> messages;
  final DateTime createdAt;
  final DateTime lastActive;
  final List<String> suggestedLessons;
  final Map<String, dynamic> context; // current lesson, progress

  AITutorSession({
    required this.id,
    required this.studentId,
    required this.topic,
    this.personality = AITutorPersonality.encouraging,
    this.messages = const [],
    required this.createdAt,
    required this.lastActive,
    this.suggestedLessons = const [],
    this.context = const {},
  });

  factory AITutorSession.fromMap(Map<String, dynamic> map, String id) {
    return AITutorSession(
      id: id,
      studentId: map['studentId'] ?? '',
      topic: map['topic'] ?? '',
      personality: AITutorPersonality.values.byName(map['personality'] ?? 'encouraging'),
      messages: (map['messages'] as List? ?? []).map((e) => AIMessage.fromMap(e)).toList(),
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      lastActive: map['lastActive'] != null ? DateTime.parse(map['lastActive']) : DateTime.now(),
      suggestedLessons: List<String>.from(map['suggestedLessons'] ?? []),
      context: Map<String, dynamic>.from(map['context'] ?? {}),
    );
  }
}

class AIDrawingFeedback {
  final String id;
  final String studentId;
  final String imageUrl;
  final String? lowResUrl;
  final DateTime analyzedAt;
  final double overallScore;
  final Map<AIFeedbackType, double> scores; // 0-10 per type
  final Map<AIFeedbackType, String> guidance; // detailed feedback per type
  final List<String> strengths;
  final List<String> improvements;
  final List<Offset> proportionMarkers; // x,y normalized for overlay
  final List<String> suggestedExercises;
  final List<String> suggestedLessons;
  final bool isOfflineAnalysis;
  final Map<String, dynamic> aiMetadata;

  AIDrawingFeedback({
    required this.id,
    required this.studentId,
    required this.imageUrl,
    this.lowResUrl,
    required this.analyzedAt,
    required this.overallScore,
    required this.scores,
    required this.guidance,
    this.strengths = const [],
    this.improvements = const [],
    this.proportionMarkers = const [],
    this.suggestedExercises = const [],
    this.suggestedLessons = const [],
    this.isOfflineAnalysis = false,
    this.aiMetadata = const {},
  });

  factory AIDrawingFeedback.mock(String imageUrl, String studentId) {
    return AIDrawingFeedback(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentId: studentId,
      imageUrl: imageUrl,
      analyzedAt: DateTime.now(),
      overallScore: 7.8,
      scores: {
        AIFeedbackType.proportion: 7.5,
        AIFeedbackType.shading: 8.0,
        AIFeedbackType.composition: 7.0,
        AIFeedbackType.anatomy: 7.2,
        AIFeedbackType.lineQuality: 8.5,
      },
      guidance: {
        AIFeedbackType.proportion: "Head proportion: Loomis method shows jaw 10% too long. Check thirds: hairline-brow-nose-chin. Your chin extends 0.5 eye-height beyond. Try measuring with pencil.",
        AIFeedbackType.shading: "Core shadow could be 2 values darker for stronger form. Highlight should be sharper, reflected light in shadow is good! Add cast shadow more defined.",
        AIFeedbackType.composition: "Subject centered, consider rule of thirds for dynamic. Negative space on left could balance. Good use of overlapping for depth.",
        AIFeedbackType.anatomy: "Eye placement correct (5 eye-widths). Nose aligns brow to chin thirds well. Ear top should align with brow line - yours slightly low.",
        AIFeedbackType.lineQuality: "Confident lines, minimal chicken scratches! Vary weight: lighter construction, darker final. Excellent control.",
      },
      strengths: ["Strong line confidence", "Good eye placement", "Reflected light understood"],
      improvements: ["Jaw proportion 10% long", "Core shadow darker", "Composition rule of thirds"],
      proportionMarkers: [const Offset(0.5, 0.3), const Offset(0.5, 0.6)],
      suggestedExercises: ["Loomis head 10 angles light construction", "Value scale 9 steps daily", "Negative space drawing 15 min"],
      suggestedLessons: ["facial_drawing_1", "elements_of_art_2", "principles_design_1"],
      isOfflineAnalysis: false,
      aiMetadata: {"model": "donlee-vision-v1", "confidence": 0.87, "processingTimeMs": 1200},
    );
  }
}

class AIStudyPlan {
  final String id;
  final String studentId;
  final AIStudyGoal goal;
  final DateTime createdAt;
  final DateTime startDate;
  final DateTime endDate;
  final int minutesPerDay;
  final List<AIStudyDay> days;
  final Map<String, dynamic> preferences;
  final double completionRate;

  AIStudyPlan({
    required this.id,
    required this.studentId,
    required this.goal,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    required this.minutesPerDay,
    this.days = const [],
    this.preferences = const {},
    this.completionRate = 0,
  });
}

class AIStudyDay {
  final DateTime date;
  final String theme;
  final List<AIStudyTask> tasks;
  final bool completed;
  final int minutesSpent;

  AIStudyDay({
    required this.date,
    required this.theme,
    this.tasks = const [],
    this.completed = false,
    this.minutesSpent = 0,
  });
}

class AIStudyTask {
  final String id;
  final String title;
  final String type; // lesson, practice, quiz, competition, review
  final String? lessonId;
  final String? assignmentId;
  final int estimatedMinutes;
  final bool completed;
  final String? aiReason; // why AI suggested

  AIStudyTask({
    required this.id,
    required this.title,
    required this.type,
    this.lessonId,
    this.assignmentId,
    required this.estimatedMinutes,
    this.completed = false,
    this.aiReason,
  });
}

class AIPracticeChallenge {
  final String id;
  final String title;
  final String description;
  final String prompt; // AI generated prompt
  final AIChallengeDifficulty difficulty;
  final List<String> tags;
  final int estimatedMinutes;
  final String? referenceImageUrl;
  final List<String> evaluationCriteria;
  final bool isDaily;
  final DateTime createdAt;

  AIPracticeChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.prompt,
    required this.difficulty,
    this.tags = const [],
    required this.estimatedMinutes,
    this.referenceImageUrl,
    this.evaluationCriteria = const [],
    this.isDaily = false,
    required this.createdAt,
  });
}

class AIQuizQuestionGenerated {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String difficulty;
  final String source; // lessonId or topic
  final bool teacherReviewed;
  final String? reviewedBy;

  AIQuizQuestionGenerated({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.difficulty,
    required this.source,
    this.teacherReviewed = false,
    this.reviewedBy,
  });
}

class AILessonPlanDraft {
  final String id;
  final String teacherId;
  final String topic;
  final String ageGroup;
  final String level;
  final String objectives;
  final List<String> materials;
  final List<AILessonStepDraft> steps;
  final int durationMinutes;
  final bool teacherApproved;
  final String? approvedBy;
  final DateTime createdAt;
  final Map<String, dynamic> aiMetadata;

  AILessonPlanDraft({
    required this.id,
    required this.teacherId,
    required this.topic,
    required this.ageGroup,
    required this.level,
    required this.objectives,
    this.materials = const [],
    this.steps = const [],
    required this.durationMinutes,
    this.teacherApproved = false,
    this.approvedBy,
    required this.createdAt,
    this.aiMetadata = const {},
  });
}

class AILessonStepDraft {
  final String title;
  final String description;
  final int minutes;
  final String? tip;

  AILessonStepDraft({required this.title, required this.description, required this.minutes, this.tip});
}

class AIAnalyticsInsight {
  final String id;
  final String studentId;
  final DateTime generatedAt;
  final String type; // trend, engagement, weakness, strength, prediction
  final String title;
  final String description;
  final double confidence;
  final Map<String, dynamic> data;
  final List<String> recommendations;
  final bool isTeacherVisible;
  final bool isStudentVisible;

  AIAnalyticsInsight({
    required this.id,
    required this.studentId,
    required this.generatedAt,
    required this.type,
    required this.title,
    required this.description,
    required this.confidence,
    this.data = const {},
    this.recommendations = const [],
    this.isTeacherVisible = true,
    this.isStudentVisible = true,
  });
}

class PrivacyConsent {
  final String userId;
  final bool aiTutorConsent;
  final bool aiArtAnalysisConsent;
  final bool voiceRecordingConsent;
  final bool dataCollectionConsent;
  final bool analyticsConsent;
  final bool cameraUsageConsent;
  final DateTime consentedAt;
  final String? encryptionKeyId;

  PrivacyConsent({
    required this.userId,
    this.aiTutorConsent = false,
    this.aiArtAnalysisConsent = false,
    this.voiceRecordingConsent = false,
    this.dataCollectionConsent = false,
    this.analyticsConsent = false,
    this.cameraUsageConsent = false,
    required this.consentedAt,
    this.encryptionKeyId,
  });

  factory PrivacyConsent.defaultConsent(String userId) {
    return PrivacyConsent(
      userId: userId,
      aiTutorConsent: false,
      aiArtAnalysisConsent: false,
      voiceRecordingConsent: false,
      dataCollectionConsent: false,
      analyticsConsent: false,
      cameraUsageConsent: false,
      consentedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'aiTutorConsent': aiTutorConsent,
    'aiArtAnalysisConsent': aiArtAnalysisConsent,
    'voiceRecordingConsent': voiceRecordingConsent,
    'dataCollectionConsent': dataCollectionConsent,
    'analyticsConsent': analyticsConsent,
    'cameraUsageConsent': cameraUsageConsent,
    'consentedAt': consentedAt.toIso8601String(),
    'encryptionKeyId': encryptionKeyId,
  };
}
