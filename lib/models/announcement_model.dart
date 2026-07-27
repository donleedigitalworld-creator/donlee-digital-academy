enum AnnouncementPriority { low, normal, high, urgent }
enum AnnouncementAudience { all, school, class_, individual }

class AnnouncementModel {
  final String id;
  final String title;
  final String body;
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String? schoolId;
  final String? classId;
  final AnnouncementAudience audience;
  final AnnouncementPriority priority;
  final List<String> attachmentUrls;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final List<String> readByUserIds;
  final String? actionLink;
  final String? imageUrl;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.body,
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl,
    this.schoolId,
    this.classId,
    this.audience = AnnouncementAudience.class_,
    this.priority = AnnouncementPriority.normal,
    this.attachmentUrls = const [],
    required this.createdAt,
    this.expiresAt,
    this.readByUserIds = const [],
    this.actionLink,
    this.imageUrl,
  });

  factory AnnouncementModel.fromMap(Map<String, dynamic> map, String id) {
    return AnnouncementModel(
      id: id,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? 'Donlee Academy',
      authorPhotoUrl: map['authorPhotoUrl'],
      schoolId: map['schoolId'],
      classId: map['classId'],
      audience: AnnouncementAudience.values.byName(map['audience'] ?? 'class_'),
      priority: AnnouncementPriority.values.byName(map['priority'] ?? 'normal'),
      attachmentUrls: List<String>.from(map['attachmentUrls'] ?? []),
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      expiresAt: map['expiresAt'] != null ? DateTime.parse(map['expiresAt']) : null,
      readByUserIds: List<String>.from(map['readByUserIds'] ?? []),
      actionLink: map['actionLink'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'body': body,
    'authorId': authorId,
    'authorName': authorName,
    'authorPhotoUrl': authorPhotoUrl,
    'schoolId': schoolId,
    'classId': classId,
    'audience': audience.name,
    'priority': priority.name,
    'attachmentUrls': attachmentUrls,
    'createdAt': createdAt.toIso8601String(),
    'expiresAt': expiresAt?.toIso8601String(),
    'readByUserIds': readByUserIds,
    'actionLink': actionLink,
    'imageUrl': imageUrl,
  };
}
