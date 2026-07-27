import '../../models/ai/ai_models.dart';

class AITeacherToolsService {
  Future<List<AIQuizQuestionGenerated>> generateQuiz({
    required String teacherId,
    required String lessonId,
    required String topic,
    required int questionCount,
    required String difficulty,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    // Mock generation based on topic - real would call AI
    final mockQuestions = [
      AIQuizQuestionGenerated(
        id: 'q1',
        question: 'In Loomis method, where is the brow line located?',
        options: ['Top of sphere', 'Middle of sphere', 'Bottom of sphere', '1/3 down from top'],
        correctIndex: 1,
        explanation: 'Brow line is at middle of sphere, establishing eye line. This is Loomis standard.',
        difficulty: difficulty,
        source: lessonId,
        teacherReviewed: false,
      ),
      AIQuizQuestionGenerated(
        id: 'q2',
        question: 'Which value is darkest ON the object (not cast shadow)?',
        options: ['Highlight', 'Core Shadow', 'Reflected Light', 'Cast Shadow'],
        correctIndex: 1,
        explanation: 'Core Shadow is darkest dark on form itself, before reflected light bounces in.',
        difficulty: difficulty,
        source: lessonId,
        teacherReviewed: false,
      ),
      AIQuizQuestionGenerated(
        id: 'q3',
        question: 'For 2-point perspective, where should vanishing points be placed to avoid distortion?',
        options: ['Close together center', 'Outside the page, far apart', 'Both on same side', 'One above, one below'],
        correctIndex: 1,
        explanation: 'VPs outside page, far apart prevent fish-eye distortion. Common mistake placing too close.',
        difficulty: difficulty,
        source: lessonId,
        teacherReviewed: false,
      ),
    ];

    return mockQuestions.take(questionCount).toList();
  }

  Future<AILessonPlanDraft> generateLessonPlan({
    required String teacherId,
    required String topic,
    required String ageGroup,
    required String level,
    required int durationMinutes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    return AILessonPlanDraft(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      teacherId: teacherId,
      topic: topic,
      ageGroup: ageGroup,
      level: level,
      objectives: 'Students will be able to: 1) Understand $topic fundamentals, 2) Apply in drawing with camera verification, 3) Critique using AI feedback guidance',
      materials: ['Sketchbook A4 100gsm', 'Pencils 2H-6B', 'Kneaded eraser', 'Phone for camera capture', 'Donlee app with offline mode'],
      steps: [
        AILessonStepDraft(title: 'Warm-up - Blind Contour 5 min', description: 'No looking at paper, draw hand. No erasing. Builds hand-eye, breaks perfectionism.', minutes: 5, tip: 'Encourage laughter, no perfect!'),
        AILessonStepDraft(title: 'Demo - $topic 15 min', description: 'Teacher demos step-by-step: big shapes -> refine -> light/shadow -> details. Pause after each. Use Loomis/doc cam.', minutes: 15, tip: 'Show common mistake: details first vs big shapes first'),
        AILessonStepDraft(title: 'Guided Practice 20 min', description: 'Students practice $topic with reference, teacher circulates, gives verbal feedback. Use camera capture for verification. Low-bandwidth students can queue offline.', minutes: 20, tip: 'Focus on one improvement from last artwork'),
        AILessonStepDraft(title: 'AI Feedback Intro 5 min', description: 'Show how AI analyzes proportion/shading/composition - but teacher reviews before student sees. Emphasize teacher-guided, AI assists.', minutes: 5),
        AILessonStepDraft(title: 'Share & Critique 10 min', description: '2 students share, class critiques using 5 criteria, teacher models feedback: strength + improvement', minutes: 10),
        AILessonStepDraft(title: 'Assignment - Camera Upload', description: 'Assign: Draw 5 angles Loomis heads light construction, camera capture required, upload to portfolio, write what learned', minutes: 5),
      ],
      durationMinutes: durationMinutes,
      teacherApproved: false,
      createdAt: DateTime.now(),
      aiMetadata: {'model': 'donlee-lesson-planner-v1', 'basedOn': 'Donlee 10 modules pedagogy', 'privacy': 'No student data used without consent'},
    );
  }

  Future<AILessonPlanDraft> teacherReviewLessonPlan({
    required AILessonPlanDraft draft,
    required String teacherId,
    bool approved = true,
    String? edits,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return AILessonPlanDraft(
      id: draft.id,
      teacherId: draft.teacherId,
      topic: draft.topic,
      ageGroup: draft.ageGroup,
      level: draft.level,
      objectives: edits ?? draft.objectives,
      materials: draft.materials,
      steps: draft.steps,
      durationMinutes: draft.durationMinutes,
      teacherApproved: approved,
      approvedBy: teacherId,
      createdAt: draft.createdAt,
      aiMetadata: {...draft.aiMetadata, 'reviewedAt': DateTime.now().toIso8601String(), 'approved': approved},
    );
  }

  Future<List<AIQuizQuestionGenerated>> teacherReviewQuiz({
    required List<AIQuizQuestionGenerated> questions,
    required String teacherId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return questions.map((q) => AIQuizQuestionGenerated(
      id: q.id,
      question: q.question,
      options: q.options,
      correctIndex: q.correctIndex,
      explanation: q.explanation,
      difficulty: q.difficulty,
      source: q.source,
      teacherReviewed: true,
      reviewedBy: teacherId,
    )).toList();
  }
}
