import '../../models/teacher_pd/teacher_pd_model.dart';

class TeacherPDService {
  Future<List<TeacherPDCourse>> getCourses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return TeacherPDCourse.mockCourses();
  }

  Future<List<CPDRecord>> getCPDRecords(String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      CPDRecord(id: 'cpd1', teacherId: teacherId, courseId: 'pd1', completedAt: DateTime.now().subtract(const Duration(days: 20)), hours: 4, level: CertificationLevel.silver, certificateNumber: 'DON-PD-2025-A1B2'),
      CPDRecord(id: 'cpd2', teacherId: teacherId, courseId: 'pd2', completedAt: DateTime.now().subtract(const Duration(days: 5)), hours: 6, level: CertificationLevel.gold, certificateNumber: 'DON-PD-2025-C3D4'),
    ];
  }

  Future<List<Mentorship>> getMentorships(String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      Mentorship(id: 'ment1', mentorId: 'mentor1', mentorName: 'Prof. Nike Davies', menteeId: teacherId, menteeName: 'Ms. Amara Teacher', status: MentorshipStatus.active, startedAt: DateTime.now().subtract(const Duration(days: 30)), sessionsCompleted: 3, totalSessions: 6, focusArea: 'Teaching Loomis Method + AI Tools'),
    ];
  }
}
