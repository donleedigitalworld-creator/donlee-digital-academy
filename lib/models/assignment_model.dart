enum AssignmentStatus { draft, published, closed, archived }
enum SubmissionStatus { pending, submitted, reviewed, late, resubmit }

class AssignmentModel {
  final String id;
  final String title;
  final String description;
  final String instructions;
  final String teacherId;
  final String teacherName;
  final String classId;
  final String schoolId;
  final String? moduleId;
  final String? lessonId;
  final List<String> referenceImageUrls;
  final DateTime createdAt;
  final DateTime dueDate;
  final int maxScore;
  final AssignmentStatus status;
  final List<String> submissionIds;
  final List<String> tags;
  final bool allowLateSubmission;
  final bool requireCameraPhoto; // true means must use camera capture

  AssignmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructions,
    required this.teacherId,
    required this.teacherName,
    required this.classId,
    required this.schoolId,
    this.moduleId,
    this.lessonId,
    this.referenceImageUrls = const [],
    required this.createdAt,
    required this.dueDate,
    this.maxScore = 100,
    this.status = AssignmentStatus.published,
    this.submissionIds = const [],
    this.tags = const [],
    this.allowLateSubmission = true,
    this.requireCameraPhoto = false,
  });

  factory AssignmentModel.fromMap(Map<String, dynamic> map, String id) {
    return AssignmentModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      instructions: map['instructions'] ?? '',
      teacherId: map['teacherId'] ?? '',
      teacherName: map['teacherName'] ?? 'Teacher',
      classId: map['classId'] ?? '',
      schoolId: map['schoolId'] ?? '',
      moduleId: map['moduleId'],
      lessonId: map['lessonId'],
      referenceImageUrls: List<String>.from(map['referenceImageUrls'] ?? []),
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : DateTime.now().add(const Duration(days: 7)),
      maxScore: map['maxScore'] ?? 100,
      status: AssignmentStatus.values.byName(map['status'] ?? 'published'),
      submissionIds: List<String>.from(map['submissionIds'] ?? []),
      tags: List<String>.from(map['tags'] ?? []),
      allowLateSubmission: map['allowLateSubmission'] ?? true,
      requireCameraPhoto: map['requireCameraPhoto'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'instructions': instructions,
    'teacherId': teacherId,
    'teacherName': teacherName,
    'classId': classId,
    'schoolId': schoolId,
    'moduleId': moduleId,
    'lessonId': lessonId,
    'referenceImageUrls': referenceImageUrls,
    'createdAt': createdAt.toIso8601String(),
    'dueDate': dueDate.toIso8601String(),
    'maxScore': maxScore,
    'status': status.name,
    'submissionIds': submissionIds,
    'tags': tags,
    'allowLateSubmission': allowLateSubmission,
    'requireCameraPhoto': requireCameraPhoto,
  };

  bool get isOverdue => DateTime.now().isAfter(dueDate);
  int get daysLeft => dueDate.difference(DateTime.now()).inDays;
}

class SubmissionModel {
  final String id;
  final String assignmentId;
  final String studentId;
  final String studentName;
  final String? studentPhotoUrl;
  final String classId;
  final List<String> artworkImageUrls; // uploaded drawings - camera or gallery
  final String? textResponse;
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final SubmissionStatus status;
  final int? score;
  final String? feedback;
  final List<String> teacherAnnotationUrls; // teacher.drawn corrections
  final bool isLate;

  SubmissionModel({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.studentName,
    this.studentPhotoUrl,
    required this.classId,
    this.artworkImageUrls = const [],
    this.textResponse,
    required this.submittedAt,
    this.reviewedAt,
    this.status = SubmissionStatus.submitted,
    this.score,
    this.feedback,
    this.teacherAnnotationUrls = const [],
    this.isLate = false,
  });

  factory SubmissionModel.fromMap(Map<String, dynamic> map, String id) {
    return SubmissionModel(
      id: id,
      assignmentId: map['assignmentId'] ?? '',
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? 'Student',
      studentPhotoUrl: map['studentPhotoUrl'],
      classId: map['classId'] ?? '',
      artworkImageUrls: List<String>.from(map['artworkImageUrls'] ?? []),
      textResponse: map['textResponse'],
      submittedAt: map['submittedAt'] != null ? DateTime.parse(map['submittedAt']) : DateTime.now(),
      reviewedAt: map['reviewedAt'] != null ? DateTime.parse(map['reviewedAt']) : null,
      status: SubmissionStatus.values.byName(map['status'] ?? 'submitted'),
      score: map['score'],
      feedback: map['feedback'],
      teacherAnnotationUrls: List<String>.from(map['teacherAnnotationUrls'] ?? []),
      isLate: map['isLate'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'assignmentId': assignmentId,
    'studentId': studentId,
    'studentName': studentName,
    'studentPhotoUrl': studentPhotoUrl,
    'classId': classId,
    'artworkImageUrls': artworkImageUrls,
    'textResponse': textResponse,
    'submittedAt': submittedAt.toIso8601String(),
    'reviewedAt': reviewedAt?.toIso8601String(),
    'status': status.name,
    'score': score,
    'feedback': feedback,
    'teacherAnnotationUrls': teacherAnnotationUrls,
    'isLate': isLate,
  };
}
