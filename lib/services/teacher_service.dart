import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/teacher_model.dart';
import '../models/school_model.dart';
import '../models/assignment_model.dart';
import '../core/constants/app_constants.dart';

class TeacherService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Teacher Profile
  Future<TeacherModel?> getTeacher(String uid) async {
    try {
      final doc = await _firestore.collection('teachers').doc(uid).get();
      if (!doc.exists) return null;
      return TeacherModel.fromMap(doc.data()!, uid);
    } catch (e) {
      debugPrint("Get teacher failed: $e");
      return null;
    }
  }

  Stream<TeacherModel?> teacherStream(String uid) {
    return _firestore.collection('teachers').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return TeacherModel.fromMap(doc.data()!, uid);
    });
  }

  Future<void> createOrUpdateTeacher(TeacherModel teacher) async {
    await _firestore.collection('teachers').doc(teacher.uid).set(teacher.toMap(), SetOptions(merge: true));
    // Also ensure users collection has role
    await _firestore.collection(AppConstants.usersCollection).doc(teacher.uid).set({
      'role': 'teacher',
      'displayName': teacher.displayName,
      'photoUrl': teacher.photoUrl,
      'email': teacher.email,
    }, SetOptions(merge: true));
  }

  // Class Management
  Future<String> createClass(ClassModel classModel) async {
    final docRef = _firestore.collection('classes').doc();
    final newClass = ClassModel(
      id: docRef.id,
      schoolId: classModel.schoolId,
      name: classModel.name,
      description: classModel.description,
      teacherId: classModel.teacherId,
      studentIds: classModel.studentIds,
      assignmentIds: classModel.assignmentIds,
      coverImageUrl: classModel.coverImageUrl,
      level: classModel.level,
      maxStudents: classModel.maxStudents,
      createdAt: DateTime.now(),
      isActive: true,
      schedule: classModel.schedule,
    );
    await docRef.set(newClass.toMap());
    // Add class to teacher
    await _firestore.collection('teachers').doc(classModel.teacherId).update({
      'classIds': FieldValue.arrayUnion([docRef.id])
    });
    // Add to school
    await _firestore.collection('schools').doc(classModel.schoolId).update({
      'classIds': FieldValue.arrayUnion([docRef.id])
    });
    return docRef.id;
  }

  Stream<List<ClassModel>> getTeacherClasses(String teacherId) {
    return _firestore.collection('classes').where('teacherId', isEqualTo: teacherId).snapshots().map((snap) => snap.docs.map((d) => ClassModel.fromMap(d.data(), d.id)).toList());
  }

  Stream<List<ClassModel>> getSchoolClasses(String schoolId) {
    return _firestore.collection('classes').where('schoolId', isEqualTo: schoolId).snapshots().map((snap) => snap.docs.map((d) => ClassModel.fromMap(d.data(), d.id)).toList());
  }

  Future<void> addStudentToClass(String classId, String studentId) async {
    await _firestore.collection('classes').doc(classId).update({
      'studentIds': FieldValue.arrayUnion([studentId])
    });
    await _firestore.collection(AppConstants.usersCollection).doc(studentId).update({
      'classId': classId,
    });
  }

  // Assignments
  Future<String> createAssignment(AssignmentModel assignment) async {
    final docRef = _firestore.collection('assignments').doc();
    final newAssignment = AssignmentModel(
      id: docRef.id,
      title: assignment.title,
      description: assignment.description,
      instructions: assignment.instructions,
      teacherId: assignment.teacherId,
      teacherName: assignment.teacherName,
      classId: assignment.classId,
      schoolId: assignment.schoolId,
      moduleId: assignment.moduleId,
      lessonId: assignment.lessonId,
      referenceImageUrls: assignment.referenceImageUrls,
      createdAt: DateTime.now(),
      dueDate: assignment.dueDate,
      maxScore: assignment.maxScore,
      status: assignment.status,
      tags: assignment.tags,
      allowLateSubmission: assignment.allowLateSubmission,
    );
    await docRef.set(newAssignment.toMap());
    await _firestore.collection('classes').doc(assignment.classId).update({
      'assignmentIds': FieldValue.arrayUnion([docRef.id])
    });
    await _firestore.collection('teachers').doc(assignment.teacherId).update({
      'totalAssignments': FieldValue.increment(1)
    });
    return docRef.id;
  }

  Stream<List<AssignmentModel>> getClassAssignments(String classId) {
    return _firestore.collection('assignments').where('classId', isEqualTo: classId).orderBy('dueDate').snapshots().map((snap) => snap.docs.map((d) => AssignmentModel.fromMap(d.data(), d.id)).toList());
  }

  Stream<List<SubmissionModel>> getAssignmentSubmissions(String assignmentId) {
    return _firestore.collection('submissions').where('assignmentId', isEqualTo: assignmentId).orderBy('submittedAt', descending: true).snapshots().map((snap) => snap.docs.map((d) => SubmissionModel.fromMap(d.data(), d.id)).toList());
  }

  Future<void> gradeSubmission({required String submissionId, required int score, required String feedback, List<String>? annotationUrls}) async {
    await _firestore.collection('submissions').doc(submissionId).update({
      'score': score,
      'feedback': feedback,
      'status': 'reviewed',
      'reviewedAt': DateTime.now().toIso8601String(),
      'teacherAnnotationUrls': annotationUrls ?? [],
    });
  }

  // Mock data for Phase 2 demo when Firestore empty
  List<ClassModel> getMockClasses(String teacherId) {
    return [
      ClassModel(id: 'c1', schoolId: 's1', name: 'Beginner Fine Art - Morning', description: 'Intro to Fine Art & Elements for new students', teacherId: teacherId, studentIds: List.generate(12, (i) => 's$i'), assignmentIds: ['a1', 'a2'], level: 'beginner', maxStudents: 25, createdAt: DateTime.now().subtract(const Duration(days: 30)), schedule: 'Mon, Wed 9am-11am'),
      ClassModel(id: 'c2', schoolId: 's1', name: 'Portrait Mastery - Evening', description: 'Advanced facial drawing & anatomy', teacherId: teacherId, studentIds: List.generate(8, (i) => 's$i'), assignmentIds: ['a3'], level: 'advanced', maxStudents: 15, createdAt: DateTime.now().subtract(const Duration(days: 20)), schedule: 'Tue, Thu 5pm-7pm'),
    ];
  }

  List<AssignmentModel> getMockAssignments(String classId) {
    return [
      AssignmentModel(id: 'a1', title: 'Loomis Head - 5 Angles', description: 'Draw head using Loomis method from front, 3/4, side, up, down', instructions: '1. Light construction with sphere & cross\n2. Show thirds/fifths\n3. No shading, focus on structure\n4. Capture with camera, upload 5 images', teacherId: 't1', teacherName: 'Donlee Instructor', classId: classId, schoolId: 's1', moduleId: 'facial_drawing', createdAt: DateTime.now().subtract(const Duration(days: 2)), dueDate: DateTime.now().add(const Duration(days: 3)), maxScore: 100, tags: ['Portrait', 'Loomis'], requireCameraPhoto: true),
      AssignmentModel(id: 'a2', title: 'Value Scale & Sphere Study', description: 'Create 9-step value scale + render sphere with 5 elements of light/shadow', instructions: 'Observe egg under single lamp, practice core shadow & reflected light. Upload value scale and sphere.', teacherId: 't1', teacherName: 'Donlee Instructor', classId: classId, schoolId: 's1', moduleId: 'elements_of_art', createdAt: DateTime.now().subtract(const Duration(days: 1)), dueDate: DateTime.now().add(const Duration(days: 5)), maxScore: 100, tags: ['Value', 'Shading']),
    ];
  }
}
