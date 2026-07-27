import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/assignment_model.dart';
import '../models/certificate_model.dart';

class AssignmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Student - assignments for their class
  Stream<List<AssignmentModel>> getStudentAssignments(String classId) {
    return _firestore.collection('assignments').where('classId', isEqualTo: classId).where('status', isEqualTo: 'published').orderBy('dueDate').snapshots().map((snap) => snap.docs.map((d) => AssignmentModel.fromMap(d.data(), d.id)).toList());
  }

  // Submit assignment with camera/gallery images
  Future<String> submitAssignment(SubmissionModel submission) async {
    final docRef = _firestore.collection('submissions').doc();
    final newSub = SubmissionModel(
      id: docRef.id,
      assignmentId: submission.assignmentId,
      studentId: submission.studentId,
      studentName: submission.studentName,
      studentPhotoUrl: submission.studentPhotoUrl,
      classId: submission.classId,
      artworkImageUrls: submission.artworkImageUrls,
      textResponse: submission.textResponse,
      submittedAt: DateTime.now(),
      status: SubmissionStatus.submitted,
      isLate: submission.isLate,
    );
    await docRef.set(newSub.toMap());
    await _firestore.collection('assignments').doc(submission.assignmentId).update({
      'submissionIds': FieldValue.arrayUnion([docRef.id])
    });
    return docRef.id;
  }

  Stream<List<SubmissionModel>> getStudentSubmissions(String studentId) {
    return _firestore.collection('submissions').where('studentId', isEqualTo: studentId).orderBy('submittedAt', descending: true).snapshots().map((snap) => snap.docs.map((d) => SubmissionModel.fromMap(d.data(), d.id)).toList());
  }

  // Certificates
  Future<String> generateCertificate(CertificateModel cert) async {
    final docRef = _firestore.collection('certificates').doc();
    final newCert = CertificateModel(
      id: docRef.id,
      studentId: cert.studentId,
      studentName: cert.studentName,
      studentPhotoUrl: cert.studentPhotoUrl,
      type: cert.type,
      title: cert.title,
      description: cert.description,
      moduleId: cert.moduleId,
      assignmentId: cert.assignmentId,
      classId: cert.classId,
      schoolId: cert.schoolId,
      issuedBy: cert.issuedBy,
      issuedById: cert.issuedById,
      issuedAt: DateTime.now(),
      certificateNumber: 'DON-${DateTime.now().year}-${docRef.id.substring(0, 6).toUpperCase()}',
      score: cert.score,
      metadata: cert.metadata,
    );
    await docRef.set(newCert.toMap());
    return docRef.id;
  }

  Stream<List<CertificateModel>> getStudentCertificates(String studentId) {
    return _firestore.collection('certificates').where('studentId', isEqualTo: studentId).orderBy('issuedAt', descending: true).snapshots().map((snap) => snap.docs.map((d) => CertificateModel.fromMap(d.data(), d.id)).toList());
  }

  // Mock data for demo
  List<AssignmentModel> getMockStudentAssignments(String classId) {
    return [
      AssignmentModel(
        id: 'a1',
        title: 'Loomis Head - 5 Angles',
        description: 'Master Loomis head construction',
        instructions: 'Draw 5 heads different angles. Light construction, no shading. Capture with camera.',
        teacherId: 't1',
        teacherName: 'Ms. Amara - Portrait Expert',
        classId: classId,
        schoolId: 's1',
        moduleId: 'facial_drawing',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        dueDate: DateTime.now().add(const Duration(days: 2)),
        maxScore: 100,
        tags: ['Portrait', 'Loomis'],
        requireCameraPhoto: true,
      ),
      AssignmentModel(
        id: 'a2',
        title: '30 Gesture Drawings',
        description: 'Quick poses to capture energy',
        instructions: '30 gestures, 60 sec each. Use line of action. Upload selected 10 best.',
        teacherId: 't1',
        teacherName: 'Ms. Amara',
        classId: classId,
        schoolId: 's1',
        moduleId: 'human_anatomy',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        dueDate: DateTime.now().add(const Duration(days: 4)),
        maxScore: 100,
        tags: ['Anatomy', 'Gesture'],
      ),
    ];
  }
}
