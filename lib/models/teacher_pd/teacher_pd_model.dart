enum PDCourseType { pedagogy, artMastery, aiTools, offlineTeaching, assessment, inclusiveEd }
enum CertificationLevel { bronze, silver, gold, master }
enum MentorshipStatus { pending, active, completed }

class TeacherPDCourse {
  final String id;
  final String title;
  final String description;
  final PDCourseType type;
  final int durationHours;
  final String instructor;
  final double rating;
  final int enrolledCount;
  final bool isOfflineAvailable;
  final bool isCertificate;
  final CertificationLevel certificateLevel;
  final List<String> modules;
  final String? thumbnailUrl;
  final bool isCompleted;
  final double progress;

  TeacherPDCourse({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.durationHours,
    required this.instructor,
    required this.rating,
    required this.enrolledCount,
    this.isOfflineAvailable = true,
    this.isCertificate = true,
    this.certificateLevel = CertificationLevel.silver,
    this.modules = const [],
    this.thumbnailUrl,
    this.isCompleted = false,
    this.progress = 0,
  });

  static List<TeacherPDCourse> mockCourses() {
    return [
      TeacherPDCourse(id: 'pd1', title: 'Teaching Loomis Method Effectively', description: 'How to teach Loomis head 3/4 angle without overwhelming students - scaffolding, common mistakes', type: PDCourseType.artMastery, durationHours: 4, instructor: 'Prof. Nike Davies', rating: 4.8, enrolledCount: 234, modules: ['Sphere & Cross', 'Thirds & Fifths', 'Common Mistakes Jaw 10% long'], thumbnailUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800', progress: 0.6),
      TeacherPDCourse(id: 'pd2', title: 'AI Tools for Art Teachers - Tutor, Feedback, Quiz Generator', description: 'Master AI tutor chat, drawing feedback proportion/shading/composition, quiz generator reviewed before use, study planner, privacy safeguards encryption', type: PDCourseType.aiTools, durationHours: 6, instructor: 'Donlee AI Team', rating: 4.9, enrolledCount: 189, modules: ['AI Tutor Setup', 'Drawing Feedback Teacher Review', 'Quiz Generator Approval Workflow', 'Privacy Consent Management'], progress: 0.3),
      TeacherPDCourse(id: 'pd3', title: 'Offline-First Teaching in Low-Connectivity Areas', description: 'Teach effectively when 68% North-East students rely on offline queue 2.3 avg - low-bandwidth mode, smart sync, offline resources', type: PDCourseType.offlineTeaching, durationHours: 3, instructor: 'Zainab Musa - Rural Education Specialist', rating: 4.7, enrolledCount: 156, modules: ['Offline Queue Monitoring', 'Low-Bandwidth Compression', 'Parent Communication Offline'], progress: 0.0),
      TeacherPDCourse(id: 'pd4', title: 'Inclusive Art Education - Accessibility 12% to 20%', description: 'Text scale, high contrast, dyslexia font, color blind modes, screen reader, voice navigation - national equity target 20%', type: PDCourseType.inclusiveEd, durationHours: 5, instructor: 'Inclusive Ed Expert', rating: 4.6, enrolledCount: 98, progress: 0.0),
    ];
  }
}

class CPDRecord {
  final String id;
  final String teacherId;
  final String courseId;
  final DateTime completedAt;
  final int hours;
  final CertificationLevel level;
  final String? certificateNumber;

  CPDRecord({
    required this.id,
    required this.teacherId,
    required this.courseId,
    required this.completedAt,
    required this.hours,
    required this.level,
    this.certificateNumber,
  });
}

class Mentorship {
  final String id;
  final String mentorId;
  final String mentorName;
  final String menteeId;
  final String menteeName;
  final MentorshipStatus status;
  final DateTime startedAt;
  final int sessionsCompleted;
  final int totalSessions;
  final String focusArea;

  Mentorship({
    required this.id,
    required this.mentorId,
    required this.mentorName,
    required this.menteeId,
    required this.menteeName,
    required this.status,
    required this.startedAt,
    required this.sessionsCompleted,
    required this.totalSessions,
    required this.focusArea,
  });
}
