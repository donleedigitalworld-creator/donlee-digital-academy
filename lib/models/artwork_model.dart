class ArtworkModel {
  final String id;
  final String userId;
  final String userName;
  final String title;
  final String description;
  final String imageUrl;
  final String? lessonId;
  final String? moduleId;
  final List<String> tags;
  final int likes;
  final DateTime createdAt;
  final bool isInGallery; // if approved for public gallery

  ArtworkModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.lessonId,
    this.moduleId,
    this.tags = const [],
    this.likes = 0,
    required this.createdAt,
    this.isInGallery = false,
  });

  factory ArtworkModel.fromMap(Map<String, dynamic> map) {
    return ArtworkModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'Anonymous Artist',
      title: map['title'] ?? 'Untitled',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      lessonId: map['lessonId'],
      moduleId: map['moduleId'],
      tags: List<String>.from(map['tags'] ?? []),
      likes: map['likes'] ?? 0,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      isInGallery: map['isInGallery'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'lessonId': lessonId,
      'moduleId': moduleId,
      'tags': tags,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
      'isInGallery': isInGallery,
    };
  }
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type; // lesson, challenge, general
  final bool isRead;
  final DateTime createdAt;
  final String? actionLink; // lessonId etc

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.createdAt,
    this.actionLink,
  });
}
