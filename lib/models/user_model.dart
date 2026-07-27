class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final int totalLessonsCompleted;
  final int totalArtworksUploaded;
  final Map<String, double> moduleProgress; // moduleId -> progress 0-1
  final List<String> completedLessonIds;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.createdAt,
    this.totalLessonsCompleted = 0,
    this.totalArtworksUploaded = 0,
    this.moduleProgress = const {},
    this.completedLessonIds = const [],
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? 'Artist',
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      totalLessonsCompleted: map['totalLessonsCompleted'] ?? 0,
      totalArtworksUploaded: map['totalArtworksUploaded'] ?? 0,
      moduleProgress: Map<String, double>.from(map['moduleProgress'] ?? {}),
      completedLessonIds: List<String>.from(map['completedLessonIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'totalLessonsCompleted': totalLessonsCompleted,
      'totalArtworksUploaded': totalArtworksUploaded,
      'moduleProgress': moduleProgress,
      'completedLessonIds': completedLessonIds,
    };
  }

  double get overallProgress {
    if (moduleProgress.isEmpty) return 0;
    return moduleProgress.values.reduce((a, b) => a + b) / moduleProgress.length;
  }
}
