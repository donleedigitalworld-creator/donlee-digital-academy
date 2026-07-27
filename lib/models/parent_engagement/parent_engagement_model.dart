enum EngagementType { homeworkHelp, volunteer, meeting, challenge, learningResource, feedback }
enum MeetingType { parentTeacher, aiReview, careerGuidance, exhibitionVisit }
enum MeetingStatus { scheduled, completed, cancelled, pending }

class FamilyArtChallenge {
  final String id;
  final String title;
  final String description;
  final String? coverImageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final int participatingFamilies;
  final List<String> tasks;
  final bool isActive;

  FamilyArtChallenge({
    required this.id,
    required this.title,
    required this.description,
    this.coverImageUrl,
    required this.startDate,
    required this.endDate,
    required this.participatingFamilies,
    this.tasks = const [],
    this.isActive = true,
  });

  static List<FamilyArtChallenge> mock() {
    return [
      FamilyArtChallenge(
        id: 'fam1',
        title: 'Family Unity Portrait - Ministry Theme',
        description: 'Create family portrait together reflecting Unity in Diversity - for National Championship family category',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 14)),
        participatingFamilies: 234,
        tasks: ['Sketch family together 20 min', 'Each member draws one family member', 'Combine into collage', 'Camera capture + upload'],
      ),
      FamilyArtChallenge(
        id: 'fam2',
        title: 'Market Day - Parents & Kids Observation',
        description: 'Visit market together, parents help kids observe negative spaces - still life practice',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
        participatingFamilies: 189,
        tasks: ['Visit market together', 'Parents point out light/shadow', 'Kids draw 3 objects', 'Upload with parent note'],
      ),
    ];
  }
}

class MeetingSchedule {
  final String id;
  final String parentId;
  final String childId;
  final String childName;
  final String teacherId;
  final String teacherName;
  final MeetingType type;
  final DateTime scheduledAt;
  final int durationMinutes;
  final MeetingStatus status;
  final String? location; // physical or Google Meet link
  final bool isVirtual;
  final String? notes;

  MeetingSchedule({
    required this.id,
    required this.parentId,
    required this.childId,
    required this.childName,
    required this.teacherId,
    required this.teacherName,
    required this.type,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.status,
    this.location,
    this.isVirtual = false,
    this.notes,
  });

  static List<MeetingSchedule> mock() {
    final now = DateTime.now();
    return [
      MeetingSchedule(
        id: 'meet1',
        parentId: 'parent1',
        childId: 'student1',
        childName: 'Amara Okafor',
        teacherId: 'teacher1',
        teacherName: 'Ms. Amara Teacher',
        type: MeetingType.aiReview,
        scheduledAt: now.add(const Duration(days: 2, hours: 5)),
        durationMinutes: 30,
        status: MeetingStatus.scheduled,
        location: 'Google Meet + Donlee App Live - AI Analytics Review',
        isVirtual: true,
        notes: 'Review AI insights: perspective 30% weakness, best time evenings 6-8pm, competition readiness 78% → 89%',
      ),
      MeetingSchedule(
        id: 'meet2',
        parentId: 'parent1',
        childId: 'student1',
        childName: 'Amara Okafor',
        teacherId: 'teacher1',
        teacherName: 'Ms. Amara Teacher',
        type: MeetingType.exhibitionVisit,
        scheduledAt: now.add(const Duration(days: 15)),
        durationMinutes: 120,
        status: MeetingStatus.scheduled,
        location: 'Nike Art Gallery, Lagos',
        isVirtual: false,
        notes: 'National Exhibition Opening - Amara Top 10, scholarship award',
      ),
    ];
  }
}

class VolunteerOpportunity {
  final String id;
  final String title;
  final String description;
  final String schoolId;
  final DateTime date;
  final int neededVolunteers;
  final int signedUp;
  final List<String> skills;

  VolunteerOpportunity({
    required this.id,
    required this.title,
    required this.description,
    required this.schoolId,
    required this.date,
    required this.neededVolunteers,
    required this.signedUp,
    this.skills = const [],
  });
}

class ParentLearningResource {
  final String id;
  final String title;
  final String description;
  final String type; // video, article, guide
  final String? thumbnailUrl;
  final int durationMinutes;
  final bool isOfflineAvailable;

  ParentLearningResource({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.thumbnailUrl,
    required this.durationMinutes,
    this.isOfflineAvailable = true,
  });

  static List<ParentLearningResource> mock() {
    return [
      ParentLearningResource(id: 'pr1', title: 'How to Support Child\'s Art Without Drawing for Them', description: 'Guide for parents: ask questions not answers, focus on observation not perfection', type: 'article', durationMinutes: 8, isOfflineAvailable: true),
      ParentLearningResource(id: 'pr2', title: 'Understanding AI Feedback - Proportion/Shading Explained for Parents', description: 'AI says jaw 10% long - what does it mean? How parents can help', type: 'video', durationMinutes: 12, isOfflineAvailable: true),
      ParentLearningResource(id: 'pr3', title: 'Low-Bandwidth & Offline Queue - How to Help in Limited Internet', description: 'Explain offline mode, smart sync, low-bandwidth compression to parents in rural areas', type: 'guide', durationMinutes: 6),
    ];
  }
}

class ParentEngagementMetric {
  final String parentId;
  final double meetingAttendanceRate;
  final int familyChallengesCompleted;
  final int volunteerHours;
  final int learningResourcesViewed;
  final double communicationResponseRate;

  ParentEngagementMetric({
    required this.parentId,
    required this.meetingAttendanceRate,
    required this.familyChallengesCompleted,
    required this.volunteerHours,
    required this.learningResourcesViewed,
    required this.communicationResponseRate,
  });
}
