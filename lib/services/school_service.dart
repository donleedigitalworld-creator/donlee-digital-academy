import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/school_model.dart';

class SchoolService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> registerSchool(SchoolModel school) async {
    final docRef = _firestore.collection('schools').doc();
    final newSchool = SchoolModel(
      id: docRef.id,
      name: school.name,
      logoUrl: school.logoUrl,
      email: school.email,
      phone: school.phone,
      address: school.address,
      city: school.city,
      ownerId: school.ownerId,
      teacherIds: school.teacherIds,
      classIds: [],
      totalStudents: 0,
      createdAt: DateTime.now(),
      isActive: true,
      description: school.description,
    );
    await docRef.set(newSchool.toMap());
    return docRef.id;
  }

  Future<SchoolModel?> getSchool(String schoolId) async {
    try {
      final doc = await _firestore.collection('schools').doc(schoolId).get();
      if (!doc.exists) return null;
      return SchoolModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      debugPrint("Get school failed: $e");
      return null;
    }
  }

  Stream<List<SchoolModel>> getAllSchools() {
    return _firestore.collection('schools').orderBy('createdAt', descending: true).snapshots().map((snap) => snap.docs.map((d) => SchoolModel.fromMap(d.data(), d.id)).toList());
  }

  Stream<List<SchoolModel>> getOwnerSchools(String ownerId) {
    return _firestore.collection('schools').where('ownerId', isEqualTo: ownerId).snapshots().map((snap) => snap.docs.map((d) => SchoolModel.fromMap(d.data(), d.id)).toList());
  }

  Future<void> addTeacherToSchool(String schoolId, String teacherId) async {
    await _firestore.collection('schools').doc(schoolId).update({
      'teacherIds': FieldValue.arrayUnion([teacherId])
    });
    await _firestore.collection('teachers').doc(teacherId).update({
      'schoolIds': FieldValue.arrayUnion([schoolId])
    });
  }

  // Mock for demo
  List<SchoolModel> getMockSchools() {
    return [
      SchoolModel(id: 's1', name: 'Donlee Main Academy - Lagos', logoUrl: null, email: 'lagos@donlee.art', phone: '+234 801 234 5678', address: '12 Art Street, Yaba', city: 'Lagos', ownerId: 'admin1', teacherIds: ['t1', 't2'], classIds: ['c1', 'c2'], totalStudents: 127, createdAt: DateTime.now().subtract(const Duration(days: 90)), description: 'Flagship academy specializing in digital fine art education'),
      SchoolModel(id: 's2', name: 'Donlee Abuja Creative Hub', logoUrl: null, email: 'abuja@donlee.art', phone: '+234 802 345 6789', address: '3rd Floor, Arts Complex', city: 'Abuja', ownerId: 'admin1', teacherIds: ['t3'], classIds: ['c3'], totalStudents: 58, createdAt: DateTime.now().subtract(const Duration(days: 45)), description: 'Abuja branch focused on portrait and landscape mastery'),
    ];
  }
}
