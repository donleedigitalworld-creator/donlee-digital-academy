enum ParentRelationship { father, mother, guardian, other }
enum CommunicationType { message, announcement, progressUpdate, competitionAlert, feeReminder }

class ChildLink {
  final String childId;
  final String childName;
  final String? childPhotoUrl;
  final String classId;
  final String schoolId;
  final String schoolName;
  final ParentRelationship relationship;
  final bool isPrimary;
  final DateTime linkedAt;
  final bool parentalConsentGiven;

  ChildLink({
    required this.childId,
    required this.childName,
    this.childPhotoUrl,
    required this.classId,
    required this.schoolId,
    required this.schoolName,
    required this.relationship,
    this.isPrimary = true,
    required this.linkedAt,
    this.parentalConsentGiven = false,
  });

  factory ChildLink.mock() {
    return ChildLink(
      childId: 'student1',
      childName: 'Amara Okafor',
      childPhotoUrl: null,
      classId: 'c1',
      schoolId: 's1',
      schoolName: 'Donlee Main - Lagos',
      relationship: ParentRelationship.mother,
      isPrimary: true,
      linkedAt: DateTime.now().subtract(const Duration(days: 90)),
      parentalConsentGiven: true,
    );
  }
}

class ParentProfile {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final List<ChildLink> children;
  final bool hasConsentedAI;
  final bool hasConsentedCompetition;
  final bool hasConsentedExhibition;
  final DateTime createdAt;

  ParentProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    this.children = const [],
    this.hasConsentedAI = false,
    this.hasConsentedCompetition = false,
    this.hasConsentedExhibition = false,
    required this.createdAt,
  });

  factory ParentProfile.mock() {
    return ParentProfile(
      id: 'parent1',
      name: 'Mrs. Okafor',
      email: 'parent.okafor@example.com',
      phone: '+2348012345678',
      children: [ChildLink.mock()],
      hasConsentedAI: true,
      hasConsentedCompetition: true,
      hasConsentedExhibition: true,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    );
  }
}

class ParentNotification {
  final String id;
  final String parentId;
  final String childId;
  final CommunicationType type;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final String? actionLink;

  ParentNotification({
    required this.id,
    required this.parentId,
    required this.childId,
    required this.type,
    required this.title,
    required this.body,
    this.isRead = false,
    required this.createdAt,
    this.actionLink,
  });
}

class ChildProgressSummary {
  final String childId;
  final String childName;
  final double overallProgress;
  final int lessonsCompleted;
  final int assignmentsSubmitted;
  final int competitionsParticipated;
  final int certificatesEarned;
  final double avgScore;
  final String? weakestModule;
  final String? strongestModule;
  final int offlinePendingCount;
  final bool lowBandwidthActive;
  final List<String> recentAchievements;
  final String? aiInsight;

  ChildProgressSummary({
    required this.childId,
    required this.childName,
    required this.overallProgress,
    required this.lessonsCompleted,
    required this.assignmentsSubmitted,
    required this.competitionsParticipated,
    required this.certificatesEarned,
    required this.avgScore,
    this.weakestModule,
    this.strongestModule,
    this.offlinePendingCount = 0,
    this.lowBandwidthActive = false,
    this.recentAchievements = const [],
    this.aiInsight,
  });

  factory ChildProgressSummary.mock() {
    return ChildProgressSummary(
      childId: 'student1',
      childName: 'Amara Okafor',
      overallProgress: 0.82,
      lessonsCompleted: 18,
      assignmentsSubmitted: 12,
      competitionsParticipated: 3,
      certificatesEarned: 5,
      avgScore: 88.5,
      weakestModule: 'Perspective 30%',
      strongestModule: 'Elements of Art 82%',
      offlinePendingCount: 2,
      lowBandwidthActive: false,
      recentAchievements: ['Won 1st in National Championship', 'Exhibition at Nike Art Gallery', 'Completed Color Theory'],
      aiInsight: 'AI predicts 89% competition readiness if perspective practice 10 min daily. Best time evenings 6-8pm.',
    );
  }
}
