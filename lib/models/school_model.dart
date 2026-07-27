class SchoolModel {
  final String id;
  final String name;
  final String? logoUrl;
  final String email;
  final String? phone;
  final String? address;
  final String? city;
  final String ownerId; // admin or schoolAdmin uid
  final List<String> teacherIds;
  final List<String> classIds;
  final int totalStudents;
  final DateTime createdAt;
  final bool isActive;
  final String? description;

  SchoolModel({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.email,
    this.phone,
    this.address,
    this.city,
    required this.ownerId,
    this.teacherIds = const [],
    this.classIds = const [],
    this.totalStudents = 0,
    required this.createdAt,
    this.isActive = true,
    this.description,
  });

  factory SchoolModel.fromMap(Map<String, dynamic> map, String id) {
    return SchoolModel(
      id: id,
      name: map['name'] ?? '',
      logoUrl: map['logoUrl'],
      email: map['email'] ?? '',
      phone: map['phone'],
      address: map['address'],
      city: map['city'],
      ownerId: map['ownerId'] ?? '',
      teacherIds: List<String>.from(map['teacherIds'] ?? []),
      classIds: List<String>.from(map['classIds'] ?? []),
      totalStudents: map['totalStudents'] ?? 0,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      isActive: map['isActive'] ?? true,
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'logoUrl': logoUrl,
    'email': email,
    'phone': phone,
    'address': address,
    'city': city,
    'ownerId': ownerId,
    'teacherIds': teacherIds,
    'classIds': classIds,
    'totalStudents': totalStudents,
    'createdAt': createdAt.toIso8601String(),
    'isActive': isActive,
    'description': description,
  };
}

class ClassModel {
  final String id;
  final String schoolId;
  final String name; // e.g. JSS2 Art Club, Advanced Portrait
  final String? description;
  final String teacherId;
  final List<String> studentIds;
  final List<String> assignmentIds;
  final String? coverImageUrl;
  final String level; // beginner, intermediate, advanced
  final int maxStudents;
  final DateTime createdAt;
  final bool isActive;
  final String? schedule; // e.g. Mon & Wed 4pm

  ClassModel({
    required this.id,
    required this.schoolId,
    required this.name,
    this.description,
    required this.teacherId,
    this.studentIds = const [],
    this.assignmentIds = const [],
    this.coverImageUrl,
    this.level = 'beginner',
    this.maxStudents = 30,
    required this.createdAt,
    this.isActive = true,
    this.schedule,
  });

  factory ClassModel.fromMap(Map<String, dynamic> map, String id) {
    return ClassModel(
      id: id,
      schoolId: map['schoolId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      teacherId: map['teacherId'] ?? '',
      studentIds: List<String>.from(map['studentIds'] ?? []),
      assignmentIds: List<String>.from(map['assignmentIds'] ?? []),
      coverImageUrl: map['coverImageUrl'],
      level: map['level'] ?? 'beginner',
      maxStudents: map['maxStudents'] ?? 30,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      isActive: map['isActive'] ?? true,
      schedule: map['schedule'],
    );
  }

  Map<String, dynamic> toMap() => {
    'schoolId': schoolId,
    'name': name,
    'description': description,
    'teacherId': teacherId,
    'studentIds': studentIds,
    'assignmentIds': assignmentIds,
    'coverImageUrl': coverImageUrl,
    'level': level,
    'maxStudents': maxStudents,
    'createdAt': createdAt.toIso8601String(),
    'isActive': isActive,
    'schedule': schedule,
  };

  double get occupancy => studentIds.length / maxStudents;
}
