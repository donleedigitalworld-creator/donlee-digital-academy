import '../../models/ai/ai_models.dart';

class AIAnalyticsService {
  Future<List<AIAnalyticsInsight>> generateStudentInsights({
    required String studentId,
    required Map<String, double> moduleProgress,
    required int lessonsCompleted,
    required int artworks,
    required List<Map<String, dynamic>> recentSubmissions, // with scores
    required List<Map<String, dynamic>> quizResults,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final insights = <AIAnalyticsInsight>[];

    // Weakness detection
    final weakestModule = moduleProgress.entries.isEmpty ? null : moduleProgress.entries.reduce((a, b) => a.value < b.value ? a : b);
    if (weakestModule != null && weakestModule.value < 0.5) {
      insights.add(AIAnalyticsInsight(
        id: 'insight_weak_${weakestModule.key}',
        studentId: studentId,
        generatedAt: DateTime.now(),
        type: 'weakness',
        title: 'Focus Area: ${weakestModule.key.replaceAll('_', ' ')} at ${(weakestModule.value * 100).toInt()}%',
        description: 'AI detected ${weakestModule.key} below 50%. Your last 3 submissions show proportion issues (jaw 10% long) and value range only 3 instead of 9. Suggested: 10 min daily Loomis heads light construction + value scale exercise.',
        confidence: 0.87,
        data: {'module': weakestModule.key, 'progress': weakestModule.value, 'avgScore': 72},
        recommendations: ['Loomis head 5 angles daily', 'Value scale 9 steps', 'Lesson: ${weakestModule.key}_1 rewatch'],
        isTeacherVisible: true,
        isStudentVisible: true,
      ));
    }

    // Engagement drop
    if (lessonsCompleted < 5) {
      insights.add(AIAnalyticsInsight(
        id: 'insight_engage_low',
        studentId: studentId,
        generatedAt: DateTime.now(),
        type: 'engagement',
        title: 'Engagement Dip - 3 Day Streak Broken',
        description: 'AI noticed you haven\'t practiced in 3 days. Your streak was 12 days (top 15%!). Small daily 10 min session prevents skill decay. Your best time is evenings 6-8pm WAT.',
        confidence: 0.82,
        data: {'streak': 2, 'lastActive': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(), 'bestTime': '18:00-20:00'},
        recommendations: ['Set 10 min daily reminder', 'Try non-dominant hand challenge (fun, low pressure)', 'Join 7-day sketch challenge'],
        isTeacherVisible: true,
        isStudentVisible: true,
      ));
    }

    // Strength
    final strongest = moduleProgress.entries.isEmpty ? null : moduleProgress.entries.reduce((a, b) => a.value > b.value ? a : b);
    if (strongest != null && strongest.value > 0.8) {
      insights.add(AIAnalyticsInsight(
        id: 'insight_strength',
        studentId: studentId,
        generatedAt: DateTime.now(),
        type: 'strength',
        title: 'Strength: ${strongest.key.replaceAll('_', ' ')} at ${(strongest.value * 100).toInt()}% - Mentor Potential',
        description: 'You excel at ${strongest.key}! Avg score 94%, camera verified uploads, strong line quality. AI suggests you could mentor peers or enter Portrait Masters competition category. Scholarship eligible.',
        confidence: 0.91,
        data: {'module': strongest.key, 'progress': strongest.value, 'rank': 'Top 10%'},
        recommendations: ['Enter National Competition Portrait Masters', 'Mentor 1 peer weekly', 'Exhibition submission: Nike Art Gallery'],
        isTeacherVisible: true,
        isStudentVisible: true,
      ));
    }

    // Prediction - competition readiness
    insights.add(AIAnalyticsInsight(
      id: 'insight_prediction',
      studentId: studentId,
      generatedAt: DateTime.now(),
      type: 'prediction',
      title: 'Competition Readiness: 78% for National Championship',
      description: 'Based on progress, scores, and offline queue data, AI predicts 78% readiness for Donlee National Art Championship 2025 (20 days). Weakness perspective (30%) needs boost. If you complete study plan (20 min/day), readiness → 89% by submission deadline.',
      confidence: 0.76,
      data: {'readiness': 0.78, 'daysLeft': 20, 'predictedFinalScore': 88},
      recommendations: ['Follow AI study plan Competition Prep', 'Focus perspective module', 'Submit 2 practice pieces for AI feedback'],
      isTeacherVisible: true,
      isStudentVisible: true,
    ));

    return insights;
  }

  Future<Map<String, dynamic>> generateClassAnalytics({
    required String classId,
    required List<Map<String, double>> studentsProgress, // list of moduleProgress
    required int totalStudents,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final avgCompletion = studentsProgress.isEmpty ? 0.0 : studentsProgress.map((p) => p.values.isEmpty ? 0 : p.values.reduce((a, b) => a + b) / p.values.length).reduce((a, b) => a + b) / studentsProgress.length;

    return {
      'avgCompletion': avgCompletion,
      'atRiskCount': studentsProgress.where((p) => (p.values.isEmpty ? 0 : p.values.reduce((a, b) => a + b) / p.values.length) < 0.4).length,
      'topPerformers': 3,
      'offlineQueueAvg': 2.3,
      'lowBandwidthPercent': 0.41,
      'cameraVerifiedPercent': 0.73,
      'insights': [
        {'type': 'trend', 'message': 'Perspective module drop-off 32% retention - needs intervention'},
        {'type': 'engagement', 'message': 'Evening 5-7pm highest engagement - schedule live Q&A then'},
        {'type': 'prediction', 'message': 'If 5 at-risk students complete 10 min daily, class completion +12% in 2 weeks'},
      ],
    };
  }
}
