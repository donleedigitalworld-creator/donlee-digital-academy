import 'package:flutter/material.dart';

enum CompetitionStatus { draft, registrationOpen, registrationClosed, submissionOpen, judging, resultsPublished, archived }
enum CompetitionCategoryType { drawing, painting, digitalArt, sculpture, mixedMedia, portrait, landscape, stillLife, abstract }
enum SubmissionType { online, offline }
enum JudgingRole { judge, chiefJudge, moderator, admin }
enum ExhibitionStatus { pending, selected, exhibited, awarded }

class CompetitionCategory {
  final String id;
  final String name;
  final String description;
  final CompetitionCategoryType type;
  final String ageGroup; // e.g. 8-12, 13-17, 18+, Open
  final int maxSubmissionsPerStudent;

  CompetitionCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.ageGroup,
    this.maxSubmissionsPerStudent = 2,
  });

  factory CompetitionCategory.fromMap(Map<String, dynamic> map) {
    return CompetitionCategory(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      type: CompetitionCategoryType.values.byName(map['type'] ?? 'drawing'),
      ageGroup: map['ageGroup'] ?? 'Open',
      maxSubmissionsPerStudent: map['maxSubmissionsPerStudent'] ?? 2,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'type': type.name,
    'ageGroup': ageGroup,
    'maxSubmissionsPerStudent': maxSubmissionsPerStudent,
  };
}

class JudgingCriteria {
  final String id;
  final String name; // e.g. Creativity, Technique, Composition
  final String description;
  final int maxScore;
  final double weight; // 0-1

  JudgingCriteria({
    required this.id,
    required this.name,
    required this.description,
    this.maxScore = 10,
    this.weight = 1.0,
  });

  factory JudgingCriteria.fromMap(Map<String, dynamic> map) {
    return JudgingCriteria(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      maxScore: map['maxScore'] ?? 10,
      weight: (map['weight'] ?? 1.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'maxScore': maxScore,
    'weight': weight,
  };
}

class CompetitionModel {
  final String id;
  final String title;
  final String description;
  final String theme; // e.g. "Nigeria at 65 - Unity in Diversity"
  final String organizer;
  final String? sponsor;
  final String? coverImageUrl;
  final CompetitionStatus status;
  final List<CompetitionCategory> categories;
  final List<JudgingCriteria> judgingCriteria;
  final DateTime createdAt;
  final DateTime registrationStart;
  final DateTime registrationEnd;
  final DateTime submissionStart;
  final DateTime submissionEnd;
  final DateTime judgingStart;
  final DateTime judgingEnd;
  final DateTime resultsDate;
  final List<String> eligibleSchoolIds; // empty = national open
  final List<String> judgeIds;
  final String chiefJudgeId;
  final Map<String, dynamic> prizes; // e.g. {"1st": "₦500k + Scholarship", "2nd": "₦200k"}
  final bool allowOfflineSubmission;
  final bool lowBandwidthMode;
  final bool isScholarshipLinked;
  final bool isExhibitionLinked;
  final int totalRegistrations;
  final int totalSubmissions;
  final List<String> tags;

  CompetitionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.theme,
    required this.organizer,
    this.sponsor,
    this.coverImageUrl,
    required this.status,
    this.categories = const [],
    this.judgingCriteria = const [],
    required this.createdAt,
    required this.registrationStart,
    required this.registrationEnd,
    required this.submissionStart,
    required this.submissionEnd,
    required this.judgingStart,
    required this.judgingEnd,
    required this.resultsDate,
    this.eligibleSchoolIds = const [],
    this.judgeIds = const [],
    this.chiefJudgeId = '',
    this.prizes = const {},
    this.allowOfflineSubmission = true,
    this.lowBandwidthMode = true,
    this.isScholarshipLinked = false,
    this.isExhibitionLinked = true,
    this.totalRegistrations = 0,
    this.totalSubmissions = 0,
    this.tags = const [],
  });

  factory CompetitionModel.fromMap(Map<String, dynamic> map, String id) {
    return CompetitionModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      theme: map['theme'] ?? '',
      organizer: map['organizer'] ?? 'Donlee Academy',
      sponsor: map['sponsor'],
      coverImageUrl: map['coverImageUrl'],
      status: CompetitionStatus.values.byName(map['status'] ?? 'draft'),
      categories: (map['categories'] as List? ?? []).map((e) => CompetitionCategory.fromMap(e)).toList(),
      judgingCriteria: (map['judgingCriteria'] as List? ?? []).map((e) => JudgingCriteria.fromMap(e)).toList(),
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      registrationStart: map['registrationStart'] != null ? DateTime.parse(map['registrationStart']) : DateTime.now(),
      registrationEnd: map['registrationEnd'] != null ? DateTime.parse(map['registrationEnd']) : DateTime.now().add(const Duration(days: 14)),
      submissionStart: map['submissionStart'] != null ? DateTime.parse(map['submissionStart']) : DateTime.now(),
      submissionEnd: map['submissionEnd'] != null ? DateTime.parse(map['submissionEnd']) : DateTime.now().add(const Duration(days: 30)),
      judgingStart: map['judgingStart'] != null ? DateTime.parse(map['judgingStart']) : DateTime.now().add(const Duration(days: 31)),
      judgingEnd: map['judgingEnd'] != null ? DateTime.parse(map['judgingEnd']) : DateTime.now().add(const Duration(days: 40)),
      resultsDate: map['resultsDate'] != null ? DateTime.parse(map['resultsDate']) : DateTime.now().add(const Duration(days: 45)),
      eligibleSchoolIds: List<String>.from(map['eligibleSchoolIds'] ?? []),
      judgeIds: List<String>.from(map['judgeIds'] ?? []),
      chiefJudgeId: map['chiefJudgeId'] ?? '',
      prizes: Map<String, dynamic>.from(map['prizes'] ?? {}),
      allowOfflineSubmission: map['allowOfflineSubmission'] ?? true,
      lowBandwidthMode: map['lowBandwidthMode'] ?? true,
      isScholarshipLinked: map['isScholarshipLinked'] ?? false,
      isExhibitionLinked: map['isExhibitionLinked'] ?? true,
      totalRegistrations: map['totalRegistrations'] ?? 0,
      totalSubmissions: map['totalSubmissions'] ?? 0,
      tags: List<String>.from(map['tags'] ?? []),
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'theme': theme,
    'organizer': organizer,
    'sponsor': sponsor,
    'coverImageUrl': coverImageUrl,
    'status': status.name,
    'categories': categories.map((e) => e.toMap()).toList(),
    'judgingCriteria': judgingCriteria.map((e) => e.toMap()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'registrationStart': registrationStart.toIso8601String(),
    'registrationEnd': registrationEnd.toIso8601String(),
    'submissionStart': submissionStart.toIso8601String(),
    'submissionEnd': submissionEnd.toIso8601String(),
    'judgingStart': judgingStart.toIso8601String(),
    'judgingEnd': judgingEnd.toIso8601String(),
    'resultsDate': resultsDate.toIso8601String(),
    'eligibleSchoolIds': eligibleSchoolIds,
    'judgeIds': judgeIds,
    'chiefJudgeId': chiefJudgeId,
    'prizes': prizes,
    'allowOfflineSubmission': allowOfflineSubmission,
    'lowBandwidthMode': lowBandwidthMode,
    'isScholarshipLinked': isScholarshipLinked,
    'isExhibitionLinked': isExhibitionLinked,
    'totalRegistrations': totalRegistrations,
    'totalSubmissions': totalSubmissions,
    'tags': tags,
  };

  bool get isRegistrationOpen => status == CompetitionStatus.registrationOpen && DateTime.now().isAfter(registrationStart) && DateTime.now().isBefore(registrationEnd);
  bool get isSubmissionOpen => status == CompetitionStatus.submissionOpen && DateTime.now().isAfter(submissionStart) && DateTime.now().isBefore(submissionEnd);
  bool get isJudging => status == CompetitionStatus.judging;
}

class CompetitionRegistration {
  final String id;
  final String competitionId;
  final String studentId;
  final String studentName;
  final String? studentPhotoUrl;
  final String schoolId;
  final String schoolName;
  final String classId;
  final String categoryId;
  final DateTime registeredAt;
  final bool isApproved;
  final String? approvedBy;

  CompetitionRegistration({
    required this.id,
    required this.competitionId,
    required this.studentId,
    required this.studentName,
    this.studentPhotoUrl,
    required this.schoolId,
    required this.schoolName,
    required this.classId,
    required this.categoryId,
    required this.registeredAt,
    this.isApproved = false,
    this.approvedBy,
  });

  factory CompetitionRegistration.fromMap(Map<String, dynamic> map, String id) {
    return CompetitionRegistration(
      id: id,
      competitionId: map['competitionId'] ?? '',
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      studentPhotoUrl: map['studentPhotoUrl'],
      schoolId: map['schoolId'] ?? '',
      schoolName: map['schoolName'] ?? '',
      classId: map['classId'] ?? '',
      categoryId: map['categoryId'] ?? '',
      registeredAt: map['registeredAt'] != null ? DateTime.parse(map['registeredAt']) : DateTime.now(),
      isApproved: map['isApproved'] ?? false,
      approvedBy: map['approvedBy'],
    );
  }

  Map<String, dynamic> toMap() => {
    'competitionId': competitionId,
    'studentId': studentId,
    'studentName': studentName,
    'studentPhotoUrl': studentPhotoUrl,
    'schoolId': schoolId,
    'schoolName': schoolName,
    'classId': classId,
    'categoryId': categoryId,
    'registeredAt': registeredAt.toIso8601String(),
    'isApproved': isApproved,
    'approvedBy': approvedBy,
  };
}

class CompetitionSubmission {
  final String id;
  final String competitionId;
  final String registrationId;
  final String studentId;
  final String studentName;
  final String? studentPhotoUrl;
  final String schoolId;
  final String schoolName;
  final String categoryId;
  final String title;
  final String description;
  final String? artistStatement;
  final List<String> imageUrls; // high-res
  final List<String> lowResImageUrls; // low bandwidth mode
  final SubmissionType submissionType;
  final DateTime submittedAt;
  final bool isOfflinePending; // true if created offline, waiting sync
  final String? localId; // uuid for offline queue
  final String? offlinePath; // local file path if offline
  final bool isVerified; // camera verified original work
  final Map<String, dynamic> metadata; // camera, location, device

  CompetitionSubmission({
    required this.id,
    required this.competitionId,
    required this.registrationId,
    required this.studentId,
    required this.studentName,
    this.studentPhotoUrl,
    required this.schoolId,
    required this.schoolName,
    required this.categoryId,
    required this.title,
    required this.description,
    this.artistStatement,
    this.imageUrls = const [],
    this.lowResImageUrls = const [],
    this.submissionType = SubmissionType.online,
    required this.submittedAt,
    this.isOfflinePending = false,
    this.localId,
    this.offlinePath,
    this.isVerified = false,
    this.metadata = const {},
  });

  factory CompetitionSubmission.fromMap(Map<String, dynamic> map, String id) {
    return CompetitionSubmission(
      id: id,
      competitionId: map['competitionId'] ?? '',
      registrationId: map['registrationId'] ?? '',
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      studentPhotoUrl: map['studentPhotoUrl'],
      schoolId: map['schoolId'] ?? '',
      schoolName: map['schoolName'] ?? '',
      categoryId: map['categoryId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      artistStatement: map['artistStatement'],
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      lowResImageUrls: List<String>.from(map['lowResImageUrls'] ?? []),
      submissionType: SubmissionType.values.byName(map['submissionType'] ?? 'online'),
      submittedAt: map['submittedAt'] != null ? DateTime.parse(map['submittedAt']) : DateTime.now(),
      isOfflinePending: map['isOfflinePending'] ?? false,
      localId: map['localId'],
      offlinePath: map['offlinePath'],
      isVerified: map['isVerified'] ?? false,
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() => {
    'competitionId': competitionId,
    'registrationId': registrationId,
    'studentId': studentId,
    'studentName': studentName,
    'studentPhotoUrl': studentPhotoUrl,
    'schoolId': schoolId,
    'schoolName': schoolName,
    'categoryId': categoryId,
    'title': title,
    'description': description,
    'artistStatement': artistStatement,
    'imageUrls': imageUrls,
    'lowResImageUrls': lowResImageUrls,
    'submissionType': submissionType.name,
    'submittedAt': submittedAt.toIso8601String(),
    'isOfflinePending': isOfflinePending,
    'localId': localId,
    'offlinePath': offlinePath,
    'isVerified': isVerified,
    'metadata': metadata,
  };
}

class JudgingScore {
  final String id;
  final String competitionId;
  final String submissionId;
  final String judgeId;
  final String judgeName;
  final JudgingRole role;
  final Map<String, int> criteriaScores; // criteriaId -> score
  final int totalScore;
  final double weightedScore;
  final String? feedback;
  final DateTime scoredAt;
  final bool isFinal;

  JudgingScore({
    required this.id,
    required this.competitionId,
    required this.submissionId,
    required this.judgeId,
    required this.judgeName,
    required this.role,
    required this.criteriaScores,
    required this.totalScore,
    required this.weightedScore,
    this.feedback,
    required this.scoredAt,
    this.isFinal = true,
  });

  factory JudgingScore.fromMap(Map<String, dynamic> map, String id) {
    return JudgingScore(
      id: id,
      competitionId: map['competitionId'] ?? '',
      submissionId: map['submissionId'] ?? '',
      judgeId: map['judgeId'] ?? '',
      judgeName: map['judgeName'] ?? '',
      role: JudgingRole.values.byName(map['role'] ?? 'judge'),
      criteriaScores: Map<String, int>.from(map['criteriaScores'] ?? {}),
      totalScore: map['totalScore'] ?? 0,
      weightedScore: (map['weightedScore'] ?? 0).toDouble(),
      feedback: map['feedback'],
      scoredAt: map['scoredAt'] != null ? DateTime.parse(map['scoredAt']) : DateTime.now(),
      isFinal: map['isFinal'] ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
    'competitionId': competitionId,
    'submissionId': submissionId,
    'judgeId': judgeId,
    'judgeName': judgeName,
    'role': role.name,
    'criteriaScores': criteriaScores,
    'totalScore': totalScore,
    'weightedScore': weightedScore,
    'feedback': feedback,
    'scoredAt': scoredAt.toIso8601String(),
    'isFinal': isFinal,
  };
}

class CompetitionResult {
  final String id;
  final String competitionId;
  final String categoryId;
  final String submissionId;
  final String studentId;
  final String studentName;
  final String schoolName;
  final String title;
  final String imageUrl;
  final int rank;
  final double finalScore;
  final double avgScore;
  final int totalJudges;
  final Map<String, dynamic> prize;
  final bool exhibitionSelected;
  final bool scholarshipEligible;
  final ExhibitionStatus exhibitionStatus;

  CompetitionResult({
    required this.id,
    required this.competitionId,
    required this.categoryId,
    required this.submissionId,
    required this.studentId,
    required this.studentName,
    required this.schoolName,
    required this.title,
    required this.imageUrl,
    required this.rank,
    required this.finalScore,
    required this.avgScore,
    required this.totalJudges,
    this.prize = const {},
    this.exhibitionSelected = false,
    this.scholarshipEligible = false,
    this.exhibitionStatus = ExhibitionStatus.pending,
  });

  factory CompetitionResult.fromMap(Map<String, dynamic> map, String id) {
    return CompetitionResult(
      id: id,
      competitionId: map['competitionId'] ?? '',
      categoryId: map['categoryId'] ?? '',
      submissionId: map['submissionId'] ?? '',
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      schoolName: map['schoolName'] ?? '',
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      rank: map['rank'] ?? 0,
      finalScore: (map['finalScore'] ?? 0).toDouble(),
      avgScore: (map['avgScore'] ?? 0).toDouble(),
      totalJudges: map['totalJudges'] ?? 0,
      prize: Map<String, dynamic>.from(map['prize'] ?? {}),
      exhibitionSelected: map['exhibitionSelected'] ?? false,
      scholarshipEligible: map['scholarshipEligible'] ?? false,
      exhibitionStatus: ExhibitionStatus.values.byName(map['exhibitionStatus'] ?? 'pending'),
    );
  }

  Map<String, dynamic> toMap() => {
    'competitionId': competitionId,
    'categoryId': categoryId,
    'submissionId': submissionId,
    'studentId': studentId,
    'studentName': studentName,
    'schoolName': schoolName,
    'title': title,
    'imageUrl': imageUrl,
    'rank': rank,
    'finalScore': finalScore,
    'avgScore': avgScore,
    'totalJudges': totalJudges,
    'prize': prize,
    'exhibitionSelected': exhibitionSelected,
    'scholarshipEligible': scholarshipEligible,
    'exhibitionStatus': exhibitionStatus.name,
  };
}
