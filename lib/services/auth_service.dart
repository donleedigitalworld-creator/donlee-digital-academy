import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/teacher_model.dart';
import '../core/constants/app_constants.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentFirebaseUser => _auth.currentUser;
  UserModel? _currentUserModel;
  UserModel? get currentUserModel => _currentUserModel;

  UserRole _currentRole = UserRole.student;
  UserRole get currentRole => _currentRole;

  String? _currentSchoolId;
  String? get currentSchoolId => _currentSchoolId;
  String? _currentClassId;
  String? get currentClassId => _currentClassId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> loadUserModel() async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) return;
    try {
      final doc = await _firestore.collection(AppConstants.usersCollection).doc(fbUser.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _currentUserModel = UserModel.fromMap(data, fbUser.uid);
        // Phase 2 role handling
        final roleStr = data['role'] ?? 'student';
        _currentRole = UserRole.values.byName(roleStr);
        _currentSchoolId = data['schoolId'];
        _currentClassId = data['classId'];
      } else {
        final newUser = UserModel(
          uid: fbUser.uid,
          email: fbUser.email ?? '',
          displayName: fbUser.displayName ?? fbUser.email?.split('@')[0] ?? 'Artist',
          photoUrl: fbUser.photoURL,
          createdAt: DateTime.now(),
        );
        await _firestore.collection(AppConstants.usersCollection).doc(fbUser.uid).set({
          ...newUser.toMap(),
          'role': 'student',
        });
        _currentUserModel = newUser;
        _currentRole = UserRole.student;
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading user model: $e");
    }
  }

  Future<UserModel?> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
    UserRole role = UserRole.student,
    String? photoUrl,
    String? schoolId,
    String? classId,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await cred.user?.updateDisplayName(displayName);
      if (photoUrl != null) await cred.user?.updatePhotoURL(photoUrl);
      
      final userModel = UserModel(
        uid: cred.user!.uid,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
        createdAt: DateTime.now(),
      );
      await _firestore.collection(AppConstants.usersCollection).doc(cred.user!.uid).set({
        ...userModel.toMap(),
        'role': role.name,
        'schoolId': schoolId,
        'classId': classId,
        'photoUrl': photoUrl ?? cred.user?.photoURL,
      });
      
      if (role == UserRole.teacher) {
        final teacher = TeacherModel(
          uid: cred.user!.uid,
          email: email,
          displayName: displayName,
          photoUrl: photoUrl,
          joinedAt: DateTime.now(),
        );
        await _firestore.collection('teachers').doc(cred.user!.uid).set(teacher.toMap());
      }

      _currentUserModel = userModel;
      _currentRole = role;
      notifyListeners();
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserModel?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await loadUserModel();
      return _currentUserModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _currentUserModel = null;
    _currentRole = UserRole.student;
    notifyListeners();
  }

  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateProfile({String? displayName, String? photoUrl, String? bio}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final updateMap = <String, dynamic>{};
    if (displayName != null) updateMap['displayName'] = displayName;
    if (photoUrl != null) updateMap['photoUrl'] = photoUrl;
    if (bio != null) updateMap['bio'] = bio;
    await _firestore.collection(AppConstants.usersCollection).doc(uid).update(updateMap);
    if (_currentRole == UserRole.teacher) {
      await _firestore.collection('teachers').doc(uid).update(updateMap);
    }
    await loadUserModel();
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found': return 'No account found for this email.';
      case 'wrong-password': return 'Incorrect password.';
      case 'email-already-in-use': return 'This email is already registered.';
      case 'weak-password': return 'Password is too weak (min 6 characters).';
      case 'invalid-email': return 'Invalid email address.';
      default: return e.message ?? 'An authentication error occurred.';
    }
  }

  Future<void> updateProgress({required String moduleId, required double progress}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final current = _currentUserModel?.moduleProgress ?? {};
    current[moduleId] = progress;
    await _firestore.collection(AppConstants.usersCollection).doc(uid).update({
      'moduleProgress': current,
    });
    _currentUserModel = UserModel(
      uid: _currentUserModel!.uid,
      email: _currentUserModel!.email,
      displayName: _currentUserModel!.displayName,
      photoUrl: _currentUserModel!.photoUrl,
      createdAt: _currentUserModel!.createdAt,
      moduleProgress: current,
      completedLessonIds: _currentUserModel!.completedLessonIds,
      totalLessonsCompleted: _currentUserModel!.totalLessonsCompleted,
      totalArtworksUploaded: _currentUserModel!.totalArtworksUploaded,
    );
    notifyListeners();
  }

  Future<void> markLessonCompleted(String lessonId, String moduleId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || _currentUserModel == null) return;
    
    final completed = [..._currentUserModel!.completedLessonIds];
    if (!completed.contains(lessonId)) {
      completed.add(lessonId);
      final progressMap = {..._currentUserModel!.moduleProgress};
      final currentProgress = progressMap[moduleId] ?? 0;
      final newProgress = (currentProgress + 0.33).clamp(0.0, 1.0);

      await _firestore.collection(AppConstants.usersCollection).doc(uid).update({
        'completedLessonIds': completed,
        'moduleProgress': {...progressMap, moduleId: newProgress},
        'totalLessonsCompleted': FieldValue.increment(1),
      });
      await loadUserModel();
    }
  }
}
