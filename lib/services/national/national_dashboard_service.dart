import '../../models/national/national_dashboard_model.dart';

class NationalDashboardService {
  Future<NationalStats> getNationalStats() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return NationalStats.mock();
  }

  Future<List<SchoolDetailedProfile>> getTopSchools({int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(limit, (i) => SchoolDetailedProfile(
      id: 'school_$i',
      name: ['Donlee Main - Lagos', 'Greensprings School', 'Abuja Hub', 'Donlee Port Harcourt'][i % 4],
      type: SchoolType.values[i % 5],
      region: Region.values[i % 6],
      state: ['Lagos', 'Oyo', 'Abuja', 'Rivers', 'Kano', 'Enugu'][i % 6],
      lga: 'LGA ${i + 1}',
      totalStudents: 100 + i * 23,
      totalTeachers: 5 + i * 2,
      totalParents: 80 + i * 20,
      totalClasses: 3 + i % 5,
      completionRate: 0.6 + (i % 4) * 0.08,
      competitionParticipation: 0.3 + (i % 5) * 0.1,
      offlineUsage: 0.3 + (i % 6) * 0.08,
      aiUsage: 0.5 + (i % 5) * 0.07,
      certificatesIssued: 50 + i * 10,
      isVerified: i % 3 != 0,
      joinedAt: DateTime.now().subtract(Duration(days: 100 + i * 10)),
      infrastructure: {'power': i % 2 == 0 ? 'Stable' : 'Unstable', 'internet': i % 3 == 0 ? 'Low' : 'Medium'},
    ));
  }

  Future<List<EquityMetric>> getEquityMetrics() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return EquityMetric.mockMetrics();
  }
}

class ParentService {
  Future<ParentProfile> getParentProfile(String parentId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ParentProfile.mock();
  }

  Future<List<ChildProgressSummary>> getChildrenProgress(String parentId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [ChildProgressSummary.mock(), ChildProgressSummary.mock().copyWith(childId: 'student2', childName: 'Chinedu Okafor', overallProgress: 0.65, avgScore: 76)];
  }

  Future<List<ParentNotification>> getParentNotifications(String parentId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      ParentNotification(id: 'n1', parentId: parentId, childId: 'student1', type: CommunicationType.progressUpdate, title: 'Amara completed Color Theory module', body: 'Scored 92% - distinction. AI suggests portrait competition.', isRead: false, createdAt: DateTime.now().subtract(const Duration(hours: 2))),
      ParentNotification(id: 'n2', parentId: parentId, childId: 'student1', type: CommunicationType.competitionAlert, title: 'National Competition: Exhibition Selected!', body: 'Amara\'s artwork selected for Nike Art Gallery exhibition - Top 10. Scholarship eligible.', isRead: false, createdAt: DateTime.now().subtract(const Duration(days: 1)), actionLink: '/exhibitionScholarship'),
      ParentNotification(id: 'n3', parentId: parentId, childId: 'student1', type: CommunicationType.announcement, title: 'Parent-Teacher Conference AI Review', body: 'AI analytics: Amara strong in Elements, needs perspective focus. Meeting Thu 5pm.', isRead: true, createdAt: DateTime.now().subtract(const Duration(days: 2))),
    ];
  }
}

extension ChildProgressCopy on ChildProgressSummary {
  ChildProgressSummary copyWith({String? childId, String? childName, double? overallProgress, double? avgScore}) {
    return ChildProgressSummary(
      childId: childId ?? this.childId,
      childName: childName ?? this.childName,
      overallProgress: overallProgress ?? this.overallProgress,
      lessonsCompleted: lessonsCompleted,
      assignmentsSubmitted: assignmentsSubmitted,
      competitionsParticipated: competitionsParticipated,
      certificatesEarned: certificatesEarned,
      avgScore: avgScore ?? this.avgScore,
      weakestModule: weakestModule,
      strongestModule: strongestModule,
      offlinePendingCount: offlinePendingCount,
      lowBandwidthActive: lowBandwidthActive,
      recentAchievements: recentAchievements,
      aiInsight: aiInsight,
    );
  }
}

class ResourceLibraryService {
  Future<List<ResourceCategory>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      ResourceCategory(id: 'c1', name: 'Loomis & Portrait', icon: '👤', resourceCount: 234),
      ResourceCategory(id: 'c2', name: 'Value & Shading', icon: '◼️', resourceCount: 189),
      ResourceCategory(id: 'c3', name: 'Perspective', icon: '📐', resourceCount: 123),
      ResourceCategory(id: 'c4', name: 'Color Theory', icon: '🌈', resourceCount: 156),
      ResourceCategory(id: 'c5', name: 'Competition Prep', icon: '🏆', resourceCount: 89),
    ];
  }

  Future<List<ResourceModel>> getResources({String? categoryId, String? searchQuery}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(12, (i) => ResourceModel.mock('res_$i'));
  }
}

class CareerService {
  Future<List<CareerPath>> getCareerPaths() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return CareerPath.mockPaths();
  }

  Future<List<OpportunityModel>> getOpportunities({OpportunityType? type}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final types = type != null ? [type] : OpportunityType.values;
    return List.generate(8, (i) => OpportunityModel.mock('opp_$i', types[i % types.length]));
  }
}

class CommunityService {
  Future<List<CommunityPost>> getFeed({int page = 0}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.generate(10, (i) => CommunityPost.mock('post_${page}_$i'));
  }

  Future<List<ForumTopic>> getForumTopics() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return ForumTopic.mockTopics();
  }

  Future<List<CommunityEvent>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return CommunityEvent.mockEvents();
  }
}

class ResourceModel {
  final String id;
  final String title;
  final String description;
  final String? thumbnailUrl;
  final String author;
  final int downloadCount;
  final double rating;
  final bool isOfflineAvailable;
  final bool isDownloaded;
  final bool isFavorite;
  final DateTime createdAt;
  final List<String> tags;
  final int durationMinutes;

  ResourceModel({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnailUrl,
    required this.author,
    this.downloadCount = 0,
    this.rating = 5.0,
    this.isOfflineAvailable = true,
    this.isDownloaded = false,
    this.isFavorite = false,
    required this.createdAt,
    this.tags = const [],
    this.durationMinutes = 0,
  });

  factory ResourceModel.mock(String id) {
    return ResourceModel(
      id: id,
      title: ['Loomis Guide PDF', 'Value Scale Template', 'Perspective Grid', 'Color Wheel Interactive', 'Lagos Market Photo Pack'][id.hashCode % 5],
      description: 'Master resource for Donlee modules - offline downloadable, low-bandwidth optimized',
      thumbnailUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800',
      author: 'Donlee Academy',
      downloadCount: 100 + id.hashCode % 500,
      rating: 4.5 + (id.hashCode % 5) / 10,
      isOfflineAvailable: true,
      isDownloaded: id.hashCode % 3 == 0,
      isFavorite: id.hashCode % 4 == 0,
      createdAt: DateTime.now().subtract(Duration(days: id.hashCode % 30)),
      tags: ['Loomis', 'Portrait'],
      durationMinutes: 5 + id.hashCode % 25,
    );
  }
}
