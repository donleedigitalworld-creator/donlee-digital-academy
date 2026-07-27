import '../../models/ai/ai_models.dart';

class AIStudyPlannerService {
  Future<AIStudyPlan> generateStudyPlan({
    required String studentId,
    required AIStudyGoal goal,
    required int minutesPerDay,
    required DateTime startDate,
    required DateTime endDate,
    required Map<String, double> currentProgress, // moduleId -> progress
    List<String>? weakAreas,
    List<String>? strongAreas,
    bool lowBandwidth = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final totalDays = endDate.difference(startDate).inDays;
    List<AIStudyDay> days = [];

    // Simple algorithm: allocate time based on weakness, goal, low-bandwidth
    final modules = [
      {'id': 'intro_fine_art', 'name': 'Intro Fine Art'},
      {'id': 'elements_of_art', 'name': 'Elements of Art'},
      {'id': 'facial_drawing', 'name': 'Facial Drawing'},
      {'id': 'perspective', 'name': 'Perspective'},
      {'id': 'color_theory', 'name': 'Color Theory'},
    ];

    for (int i = 0; i < totalDays.clamp(1, 30); i++) {
      final date = startDate.add(Duration(days: i));
      final weekDay = date.weekday;
      final isWeekend = weekDay == 6 || weekDay == 7;

      // Theme rotates based on goal
      String theme;
      switch (goal) {
        case AIStudyGoal.competitionPrep:
          theme = i % 3 == 0 ? "Competition Piece" : i % 3 == 1 ? "Anatomy & Proportion" : "Composition & Storytelling";
          break;
        case AIStudyGoal.portfolioBuilding:
          theme = i % 2 == 0 ? "Portfolio Polish" : "New Exploration";
          break;
        case AIStudyGoal.examPrep:
          theme = "Review Weak: ${weakAreas?.first ?? 'Perspective'}";
          break;
        default:
          theme = modules[i % modules.length]['name'] as String;
      }

      List<AIStudyTask> tasks = [];
      int remaining = minutesPerDay;

      // Lesson task (if progress low)
      if (remaining >= 15) {
        final weakModule = weakAreas?.isNotEmpty == true ? weakAreas!.first : modules[i % modules.length]['id'] as String;
        tasks.add(AIStudyTask(
          id: 'task_${i}_1',
          title: 'Lesson: $weakModule - deep dive',
          type: 'lesson',
          lessonId: '${weakModule}_1',
          estimatedMinutes: 20,
          aiReason: 'AI detected $weakModule at ${currentProgress[weakModule] != null ? (currentProgress[weakModule]! * 100).toInt() : 30}% - needs boost. Low-bandwidth: ${lowBandwidth ? 'compressed video' : 'full quality'}',
        ));
        remaining -= 20;
      }

      // Practice task
      if (remaining >= 10) {
        tasks.add(AIStudyTask(
          id: 'task_${i}_2',
          title: 'Practice: Blind contour + Gesture 30 sec',
          type: 'practice',
          estimatedMinutes: 10,
          aiReason: 'Daily practice builds hand-eye, streak multiplier active',
        ));
        remaining -= 10;
      }

      // Quiz or assignment
      if (remaining >= 15 && !isWeekend) {
        tasks.add(AIStudyTask(
          id: 'task_${i}_3',
          title: i % 2 == 0 ? 'Quiz: Elements of Art - Value' : 'Assignment: Camera upload Loomis heads',
          type: i % 2 == 0 ? 'quiz' : 'assignment',
          estimatedMinutes: 15,
          aiReason: 'Retrieval practice strengthens memory - quiz offline sync OK',
        ));
      }

      days.add(AIStudyDay(
        date: date,
        theme: theme,
        tasks: tasks,
        completed: false,
        minutesSpent: 0,
      ));
    }

    return AIStudyPlan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentId: studentId,
      goal: goal,
      createdAt: DateTime.now(),
      startDate: startDate,
      endDate: endDate,
      minutesPerDay: minutesPerDay,
      days: days,
      preferences: {
        'lowBandwidth': lowBandwidth,
        'weakAreas': weakAreas,
        'strongAreas': strongAreas,
        'model': 'donlee-planner-v1',
      },
      completionRate: 0,
    );
  }

  Future<List<AIPracticeChallenge>> generateChallenges({
    required String studentId,
    required AIChallengeDifficulty difficulty,
    required List<String> interests,
    int count = 5,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final challenges = [
      AIPracticeChallenge(
        id: 'ch1',
        title: 'Non-Dominant Hand Portrait - 5 Min',
        description: 'Draw self-portrait with opposite hand, no erasing',
        prompt: 'Set timer 5 min, mirror, non-dominant hand, focus on big shapes not details. Camera capture required for original proof. Why? Breaks perfectionism, builds confidence.',
        difficulty: AIChallengeDifficulty.beginner,
        tags: ['Portrait', 'Mindset', 'Line Quality'],
        estimatedMinutes: 7,
        evaluationCriteria: ['Big shapes first', 'No erasing', '5 min exactly'],
        isDaily: true,
        createdAt: DateTime.now(),
      ),
      AIPracticeChallenge(
        id: 'ch2',
        title: 'Lagos Market Negative Space - 12 Min',
        description: 'Draw spaces BETWEEN stalls, not stalls themselves',
        prompt: 'Go to market or use photo. Instead of drawing objects, draw negative gaps. Squint. This rewires brain to see shapes not symbols. Upload 2 photos: negative space drawing + original reference.',
        difficulty: AIChallengeDifficulty.intermediate,
        tags: ['Still Life', 'Observation', 'Composition'],
        estimatedMinutes: 15,
        evaluationCriteria: ['Negative accuracy', 'Composition balance', 'Line confidence'],
        isDaily: false,
        createdAt: DateTime.now(),
      ),
      AIPracticeChallenge(
        id: 'ch3',
        title: 'Complementary Color Self-Portrait - Limited Palette',
        description: 'Use only orange + blue (complementary) to paint portrait',
        prompt: 'Mix orange & blue only -> creates browns, grays, vibrant contrast. Focus on temperature: warm light, cool shadows. Why? Teaches harmony, limits choices boosts creativity. Upload with artist statement about mood.',
        difficulty: AIChallengeDifficulty.advanced,
        tags: ['Color Theory', 'Portrait', 'Emotion'],
        estimatedMinutes: 25,
        evaluationCriteria: ['Limited palette adherence', 'Temperature use', 'Mood'],
        isDaily: false,
        createdAt: DateTime.now(),
      ),
    ];

    // Filter by difficulty
    return challenges.where((c) => c.difficulty.index <= difficulty.index + 1).take(count).toList();
  }
}
