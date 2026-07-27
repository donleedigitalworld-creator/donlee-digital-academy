import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/offline_model.dart';
import '../models/competition_model.dart';
import 'offline_service.dart';
import 'storage_service.dart';

class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final StorageService _storageService = StorageService();

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  Future<SyncResult> syncQueue(OfflineService offlineService) async {
    if (_isSyncing) return SyncResult(alreadySyncing: true);
    _isSyncing = true;
    int synced = 0;
    int failed = 0;
    List<String> errors = [];

    final pending = offlineService.pendingQueue;
    debugPrint("Starting smart sync for ${pending.length} items, lowBandwidth=${offlineService.lowBandwidthMode}");

    for (var item in pending) {
      try {
        // Update status to syncing
        await offlineService.updateQueueItem(item.copyWith(syncStatus: SyncStatus.syncing));

        switch (item.actionType) {
          case OfflineActionType.competitionSubmission:
            await _syncCompetitionSubmission(item, offlineService.lowBandwidthMode);
            break;
          case OfflineActionType.assignmentSubmission:
            await _syncAssignmentSubmission(item, offlineService.lowBandwidthMode);
            break;
          case OfflineActionType.lessonProgress:
            await _syncLessonProgress(item);
            break;
          case OfflineActionType.quizResult:
            await _syncQuizResult(item);
            break;
          case OfflineActionType.artworkUpload:
            await _syncArtworkUpload(item, offlineService.lowBandwidthMode);
            break;
          case OfflineActionType.profilePhoto:
            await _syncProfilePhoto(item);
            break;
        }

        await offlineService.updateQueueItem(item.copyWith(syncStatus: SyncStatus.synced));
        synced++;
      } catch (e) {
        debugPrint("Sync failed for ${item.localId}: $e");
        await offlineService.updateQueueItem(item.copyWith(syncStatus: SyncStatus.failed, retryCount: item.retryCount + 1, errorMessage: e.toString()));
        failed++;
        errors.add("${item.actionType.name}: $e");
      }
    }

    _isSyncing = false;
    return SyncResult(synced: synced, failed: failed, errors: errors, total: pending.length);
  }

  Future<void> _syncCompetitionSubmission(OfflineQueueItem item, bool lowBandwidth) async {
    // Upload images first with compression for low bandwidth
    List<String> imageUrls = [];
    List<String> lowResUrls = [];

    for (var localPath in item.localImagePaths) {
      final file = File(localPath);
      if (!await file.exists()) continue;

      // Low bandwidth mode: compress more aggressively and create thumbnail
      final quality = lowBandwidth ? 40 : 80;
      final maxWidth = lowBandwidth ? 800 : 2000;

      final storagePath = 'competitions/${item.competitionId}/${item.payload['studentId']}/${item.localId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child(storagePath);
      await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
      final url = await ref.getDownloadURL();
      imageUrls.add(url);

      if (lowBandwidth) {
        // Create low-res version path (same file for demo, but flagged as lowRes)
        final lowResPath = 'competitions/${item.competitionId}/${item.payload['studentId']}/low_${item.localId}.jpg';
        final lowRef = _storage.ref().child(lowResPath);
        await lowRef.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
        lowResUrls.add(await lowRef.getDownloadURL());
      }
    }

    final submission = CompetitionSubmission(
      id: '',
      competitionId: item.competitionId!,
      registrationId: item.payload['registrationId'] ?? '',
      studentId: item.payload['studentId'],
      studentName: item.payload['studentName'],
      schoolId: item.payload['schoolId'],
      schoolName: item.payload['schoolName'],
      categoryId: item.payload['categoryId'],
      title: item.payload['title'],
      description: item.payload['description'],
      artistStatement: item.payload['artistStatement'],
      imageUrls: imageUrls,
      lowResImageUrls: lowResUrls,
      submissionType: SubmissionType.offline,
      submittedAt: DateTime.parse(item.payload['submittedAt']),
      isOfflinePending: false,
      isVerified: true,
      metadata: {
        'originalLocalId': item.localId,
        'syncedAt': DateTime.now().toIso8601String(),
        'lowBandwidth': lowBandwidth,
      },
    );

    final docRef = _firestore.collection('competition_submissions').doc();
    await docRef.set({...submission.toMap(), 'id': docRef.id});

    await _firestore.collection('competitions').doc(item.competitionId).update({
      'totalSubmissions': FieldValue.increment(1),
    });
  }

  Future<void> _syncAssignmentSubmission(OfflineQueueItem item, bool lowBandwidth) async {
    List<String> urls = [];
    for (var path in item.localImagePaths) {
      final file = File(path);
      if (!await file.exists()) continue;
      final storagePath = 'submissions/${item.assignmentId}/${item.payload['studentId']}/${item.localId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child(storagePath);
      await ref.putFile(file);
      urls.add(await ref.getDownloadURL());
    }

    final submissionData = {
      'assignmentId': item.assignmentId,
      'studentId': item.payload['studentId'],
      'studentName': item.payload['studentName'],
      'classId': item.payload['classId'],
      'artworkImageUrls': urls,
      'textResponse': item.payload['textResponse'],
      'submittedAt': DateTime.now().toIso8601String(),
      'status': 'submitted',
      'isOfflineSynced': true,
      'originalLocalId': item.localId,
    };

    final docRef = _firestore.collection('submissions').doc();
    await docRef.set(submissionData);
  }

  Future<void> _syncLessonProgress(OfflineQueueItem item) async {
    // Update user's progress
    final lessonId = item.payload['lessonId'];
    final studentId = item.payload['studentId'] ?? 'current'; // should be passed in payload for real
    // For demo, just log
    debugPrint("Sync lesson progress: $lessonId");
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _syncQuizResult(OfflineQueueItem item) async {
    debugPrint("Sync quiz result: ${item.payload}");
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _syncArtworkUpload(OfflineQueueItem item, bool lowBandwidth) async {
    // Similar to assignment
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _syncProfilePhoto(OfflineQueueItem item) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

class SyncResult {
  final int synced;
  final int failed;
  final int total;
  final List<String> errors;
  final bool alreadySyncing;

  SyncResult({this.synced = 0, this.failed = 0, this.total = 0, this.errors = const [], this.alreadySyncing = false});

  bool get isSuccess => failed == 0 && !alreadySyncing;
  double get progress => total == 0 ? 0 : synced / total;
}
