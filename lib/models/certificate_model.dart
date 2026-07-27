enum CertificateType { moduleCompletion, courseCompletion, assignmentExcellence, challenge, schoolCertificate }

class CertificateModel {
  final String id;
  final String studentId;
  final String studentName;
  final String studentPhotoUrl;
  final CertificateType type;
  final String title;
  final String description;
  final String? moduleId;
  final String? assignmentId;
  final String? classId;
  final String? schoolId;
  final String issuedBy; // teacher or admin name
  final String issuedById;
  final DateTime issuedAt;
  final DateTime? expiresAt;
  final String certificateNumber;
  final String? qrCodeData;
  final int? score;
  final Map<String, dynamic> metadata;

  CertificateModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentPhotoUrl,
    required this.type,
    required this.title,
    required this.description,
    this.moduleId,
    this.assignmentId,
    this.classId,
    this.schoolId,
    required this.issuedBy,
    required this.issuedById,
    required this.issuedAt,
    this.expiresAt,
    required this.certificateNumber,
    this.qrCodeData,
    this.score,
    this.metadata = const {},
  });

  factory CertificateModel.fromMap(Map<String, dynamic> map, String id) {
    return CertificateModel(
      id: id,
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      studentPhotoUrl: map['studentPhotoUrl'] ?? '',
      type: CertificateType.values.byName(map['type'] ?? 'moduleCompletion'),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      moduleId: map['moduleId'],
      assignmentId: map['assignmentId'],
      classId: map['classId'],
      schoolId: map['schoolId'],
      issuedBy: map['issuedBy'] ?? 'Donlee Academy',
      issuedById: map['issuedById'] ?? '',
      issuedAt: map['issuedAt'] != null ? DateTime.parse(map['issuedAt']) : DateTime.now(),
      expiresAt: map['expiresAt'] != null ? DateTime.parse(map['expiresAt']) : null,
      certificateNumber: map['certificateNumber'] ?? '',
      qrCodeData: map['qrCodeData'],
      score: map['score'],
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() => {
    'studentId': studentId,
    'studentName': studentName,
    'studentPhotoUrl': studentPhotoUrl,
    'type': type.name,
    'title': title,
    'description': description,
    'moduleId': moduleId,
    'assignmentId': assignmentId,
    'classId': classId,
    'schoolId': schoolId,
    'issuedBy': issuedBy,
    'issuedById': issuedById,
    'issuedAt': issuedAt.toIso8601String(),
    'expiresAt': expiresAt?.toIso8601String(),
    'certificateNumber': certificateNumber,
    'qrCodeData': qrCodeData,
    'score': score,
    'metadata': metadata,
  };
}
