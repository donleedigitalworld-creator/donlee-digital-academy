enum LessonStatus { draft, inReview, approved, published, archived, scheduled }
enum AssetType { image, video, pdf, template, reference, audio }

class LessonAsset {
  final String id;
  final String name;
  final AssetType type;
  final String url;
  final String? thumbnailUrl;
  final int sizeKB;
  final bool isOfflineAvailable;
  final DateTime uploadedAt;
  final String uploadedBy;

  LessonAsset({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    required this.sizeKB,
    this.isOfflineAvailable = true,
    required this.uploadedAt,
    required this.uploadedBy,
  });
}

class ReviewComment {
  final String id;
  final String reviewerId;
  final String reviewerName;
  final String comment;
  final DateTime createdAt;
  final bool isResolved;
  final String? attachedAssetId;

  ReviewComment({
    required this.id,
    required this.reviewerId,
    required this.reviewerName,
    required this.comment,
    required this.createdAt,
    this.isResolved = false,
    this.attachedAssetId,
  });
}

class LessonDraft {
  final String id;
  final String title;
  final String moduleId;
  final String moduleTitle;
  final String description;
  final String longDescription;
  final LessonStatus status;
  final String authorId;
  final String authorName;
  final List<String> stepsJson; // json of steps
  final List<LessonAsset> assets;
  final List<ReviewComment> reviewComments;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? scheduledPublishAt;
  final String? rejectionReason;
  final List<String> tags;
  final bool isForNationalCompetition;
  final bool lowBandwidthOptimized;

  LessonDraft({
    required this.id,
    required this.title,
    required this.moduleId,
    required this.moduleTitle,
    required this.description,
    required this.longDescription,
    required this.status,
    required this.authorId,
    required this.authorName,
    this.stepsJson = const [],
    this.assets = const [],
    this.reviewComments = const [],
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.scheduledPublishAt,
    this.rejectionReason,
    this.tags = const [],
    this.isForNationalCompetition = false,
    this.lowBandwidthOptimized = true,
  });

  static List<LessonDraft> mockDrafts() {
    return [
      LessonDraft(
        id: 'draft1',
        title: 'Loomis Head - Common Mistakes & Fixes',
        moduleId: 'facial_drawing',
        moduleTitle: 'Facial Drawing',
        description: 'Deep dive into jaw 10% long, eye placement 5 eye-widths',
        longDescription: 'Based on AI analytics, 32% students struggle with jaw proportion...',
        status: LessonStatus.inReview,
        authorId: 'teacher1',
        authorName: 'Ms. Amara Teacher',
        version: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
        tags: ['Loomis', 'Proportion', 'AI Insight'],
        isForNationalCompetition: false,
        lowBandwidthOptimized: true,
      ),
      LessonDraft(
        id: 'draft2',
        title: 'National Competition Theme: Unity in Diversity - Drawing Ideas',
        moduleId: 'competition_prep',
        moduleTitle: 'Competition Prep',
        description: 'Ideas for Nigeria at 65 theme - mother & child, market, danfo',
        longDescription: 'Theme interpretation guide for National Championship...',
        status: LessonStatus.draft,
        authorId: 'teacher2',
        authorName: 'Prof. Nike Davies',
        version: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
        tags: ['National Competition', 'Unity', 'Exhibition'],
        isForNationalCompetition: true,
        lowBandwidthOptimized: true,
      ),
      LessonDraft(
        id: 'draft3',
        title: 'Offline Teaching Kit - Value Scale Printable',
        moduleId: 'elements_of_art',
        moduleTitle: 'Elements of Art',
        description: 'Printable 9-step value scale for low-connectivity areas',
        longDescription: 'For 68% North-East offline adoption...',
        status: LessonStatus.approved,
        authorId: 'admin1',
        authorName: 'Donlee Admin',
        version: 3,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        scheduledPublishAt: DateTime.now().add(const Duration(days: 1)),
        tags: ['Offline', 'Low-Bandwidth', 'Printable'],
        lowBandwidthOptimized: true,
      ),
    ];
  }
}
