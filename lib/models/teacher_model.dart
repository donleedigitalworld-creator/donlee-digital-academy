enum UserRole { student, teacher, admin, schoolAdmin }

class TeacherModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String? bio;
  final String? specialization; // e.g. Portrait, Anatomy
  final List<String> classIds;
  final List<String> schoolIds;
  final int totalStudents;
  final int totalAssignments;
  final double avgRating;
  final DateTime joinedAt;
  final bool isVerified;
  final Map<String, dynamic> socialLinks;

  TeacherModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.bio,
    this.specialization,
    this.classIds = const [],
    this.schoolIds = const [],
    this.totalStudents = 0,
    this.totalAssignments = 0,
    this.avgRating = 5.0,
    required this.joinedAt,
    this.isVerified = false,
    this.socialLinks = const {},
  });

  factory TeacherModel.fromMap(Map<String, dynamic> map, String uid) {
    return TeacherModel(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? 'Teacher',
      photoUrl: map['photoUrl'],
      bio: map['bio'],
      specialization: map['specialization'],
      classIds: List<String>.from(map['classIds'] ?? []),
      schoolIds: List<String>.from(map['schoolIds'] ?? []),
      totalStudents: map['totalStudents'] ?? 0,
      totalAssignments: map['totalAssignments'] ?? 0,
      avgRating: (map['avgRating'] ?? 5.0).toDouble(),
      joinedAt: map['joinedAt'] != null ? DateTime.parse(map['joinedAt']) : DateTime.now(),
      isVerified: map['isVerified'] ?? false,
      socialLinks: Map<String, dynamic>.from(map['socialLinks'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'bio': bio,
    'specialization': specialization,
    'classIds': classIds,
    'schoolIds': schoolIds,
    'totalStudents': totalStudents,
    'totalAssignments': totalAssignments,
    'avgRating': avgRating,
    'joinedAt': joinedAt.toIso8601String(),
    'isVerified': isVerified,
    'role': 'teacher',
    'socialLinks': socialLinks,
  };
}

class ExtendedUserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final UserRole role;
  final String? schoolId;
  final String? classId;
  final DateTime createdAt;
  final double overallProgress;

  ExtendedUserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.role = UserRole.student,
    this.schoolId,
    this.classId,
    required this.createdAt,
    this.overallProgress = 0,
  });
}
