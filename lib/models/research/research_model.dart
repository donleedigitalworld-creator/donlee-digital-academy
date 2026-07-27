enum ResearchStatus { proposal, ethicsReview, approved, dataCollection, analysis, published }
enum DataSensitivity { public, internal, confidential, restricted }

class ResearchStudy {
  final String id;
  final String title;
  final String leadResearcher;
  final String institution;
  final String description;
  final ResearchStatus status;
  final DateTime startedAt;
  final DateTime? completedAt;
  final List<String> dataSources; // e.g. ["anonymized progress", "competition scores", "offline usage"]
  final DataSensitivity sensitivity;
  final bool hasEthicsApproval;
  final int participantsCount;
  final List<String> findings;

  ResearchStudy({
    required this.id,
    required this.title,
    required this.leadResearcher,
    required this.institution,
    required this.description,
    required this.status,
    required this.startedAt,
    this.completedAt,
    this.dataSources = const [],
    required this.sensitivity,
    this.hasEthicsApproval = false,
    this.participantsCount = 0,
    this.findings = const [],
  });

  static List<ResearchStudy> mockStudies() {
    return [
      ResearchStudy(
        id: 'res1',
        title: 'Impact of Offline-First Art Education in North-East Nigeria',
        leadResearcher: 'Dr. Zainab Musa',
        institution: 'University of Lagos - Rural Ed Lab',
        description: 'Study of 68% offline adoption in North-East, smart sync no duplicate, low-bandwidth 41%, completion 54% vs 74% SouthWest - interventions',
        status: ResearchStatus.dataCollection,
        startedAt: DateTime.now().subtract(const Duration(days: 60)),
        dataSources: ['anonymized progress', 'offline queue', 'low-bandwidth usage', 'competition participation'],
        sensitivity: DataSensitivity.confidential,
        hasEthicsApproval: true,
        participantsCount: 723,
        findings: ['Offline queue 2.3 avg, low-BW saves 60% data, completion +12% if teacher training'],
      ),
      ResearchStudy(
        id: 'res2',
        title: 'AI Feedback Effectiveness: Proportion/Shading/Composition - Teacher-Reviewed',
        leadResearcher: 'Donlee AI Team + Prof. Nike Davies',
        institution: 'Donlee Academy',
        description: 'Does AI feedback jaw 10% long, core shadow darker improve student scores? Teacher-reviewed flag ensures quality',
        status: ResearchStatus.analysis,
        startedAt: DateTime.now().subtract(const Duration(days: 90)),
        dataSources: ['ai_feedback', 'teacher_reviewed', 'student_scores'],
        sensitivity: DataSensitivity.internal,
        hasEthicsApproval: true,
        participantsCount: 1247,
        findings: ['AI feedback +12% score improvement, teacher review 100% approval, privacy consent 92%'],
      ),
    ];
  }
}

class ResearchDataset {
  final String id;
  final String title;
  final String description;
  final int recordCount;
  final DataSensitivity sensitivity;
  final bool isAnonymized;
  final DateTime createdAt;
  final List<String> fields; // e.g. ["module_progress", "avg_score"] no PII

  ResearchDataset({
    required this.id,
    required this.title,
    required this.description,
    required this.recordCount,
    required this.sensitivity,
    required this.isAnonymized,
    required this.createdAt,
    this.fields = const [],
  });
}
