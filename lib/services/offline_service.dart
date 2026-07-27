import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/offline_model.dart';
import '../models/competition_model.dart';

class OfflineService extends ChangeNotifier {
  static const String _queueKey = 'offline_queue';
  static const String _lessonsKey = 'offline_lessons';
  static const String _lowBandwidthKey = 'low_bandwidth_mode';
  static const String _offlineModeKey = 'offline_mode_enabled';

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  bool _lowBandwidthMode = false;
  bool get lowBandwidthMode => _lowBandwidthMode;

  bool _offlineModeEnabled = false;
  bool get offlineModeEnabled => _offlineModeEnabled;

  final Connectivity _connectivity = Connectivity();
  List<OfflineQueueItem> _queue = [];
  List<OfflineQueueItem> get queue => _queue;
  List<OfflineQueueItem> get pendingQueue => _queue.where((e) => e.syncStatus == SyncStatus.pending || e.syncStatus == SyncStatus.failed).toList();

  final _uuid = const Uuid();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      await Hive.initFlutter();
    } catch (e) {
      debugPrint("Hive init failed: $e");
    }
    await _loadPreferences();
    await _loadQueue();
    _listenConnectivity();
    _initialized = true;
    notifyListeners();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _lowBandwidthMode = prefs.getBool(_lowBandwidthKey) ?? false;
    _offlineModeEnabled = prefs.getBool(_offlineModeKey) ?? false;
  }

  Future<void> setLowBandwidthMode(bool enabled) async {
    _lowBandwidthMode = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_lowBandwidthKey, enabled);
    notifyListeners();
  }

  Future<void> setOfflineModeEnabled(bool enabled) async {
    _offlineModeEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_offlineModeKey, enabled);
    notifyListeners();
  }

  void _listenConnectivity() {
    _connectivity.onConnectivityChanged.listen((results) {
      final wasOnline = _isOnline;
      _isOnline = results.any((r) => r != ConnectivityResult.none);
      if (!wasOnline && _isOnline && _queue.isNotEmpty) {
        debugPrint("Back online, ${_queue.length} items pending sync");
        // trigger sync via SyncService
      }
      notifyListeners();
    });
    // Initial check
    _connectivity.checkConnectivity().then((results) {
      _isOnline = results.any((r) => r != ConnectivityResult.none);
      notifyListeners();
    });
  }

  Future<void> _loadQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_queueKey);
      if (jsonStr != null) {
        final List list = jsonDecode(jsonStr);
        _queue = list.map((e) => OfflineQueueItem.fromMap(e)).toList();
      }
    } catch (e) {
      debugPrint("Load queue failed: $e");
    }
  }

  Future<void> _saveQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(_queue.map((e) => e.toMap()).toList());
      await prefs.setString(_queueKey, jsonStr);
    } catch (e) {
      debugPrint("Save queue failed: $e");
    }
    notifyListeners();
  }

  String generateLocalId() => _uuid.v4();

  // Add competition submission offline
  Future<String> queueCompetitionSubmission({
    required String competitionId,
    required String categoryId,
    required String title,
    required String description,
    String? artistStatement,
    required List<String> localImagePaths,
    required String studentId,
    required String studentName,
    required String schoolId,
    required String schoolName,
  }) async {
    final localId = generateLocalId();
    final item = OfflineQueueItem(
      localId: localId,
      actionType: OfflineActionType.competitionSubmission,
      competitionId: competitionId,
      payload: {
        'categoryId': categoryId,
        'title': title,
        'description': description,
        'artistStatement': artistStatement,
        'studentId': studentId,
        'studentName': studentName,
        'schoolId': schoolId,
        'schoolName': schoolName,
        'submittedAt': DateTime.now().toIso8601String(),
        'isVerified': true,
      },
      localImagePaths: localImagePaths,
      createdAt: DateTime.now(),
      lowBandwidthMode: _lowBandwidthMode,
    );
    _queue.add(item);
    await _saveQueue();
    return localId;
  }

  // Add assignment submission offline
  Future<String> queueAssignmentSubmission({
    required String assignmentId,
    required String studentId,
    required String studentName,
    required String classId,
    required String notes,
    required List<String> localImagePaths,
  }) async {
    final localId = generateLocalId();
    final item = OfflineQueueItem(
      localId: localId,
      actionType: OfflineActionType.assignmentSubmission,
      assignmentId: assignmentId,
      payload: {
        'studentId': studentId,
        'studentName': studentName,
        'classId': classId,
        'textResponse': notes,
        'submittedAt': DateTime.now().toIso8601String(),
      },
      localImagePaths: localImagePaths,
      createdAt: DateTime.now(),
      lowBandwidthMode: _lowBandwidthMode,
    );
    _queue.add(item);
    await _saveQueue();
    return localId;
  }

  // Queue lesson progress offline
  Future<void> queueLessonProgress({required String lessonId, required String moduleId, double? progress, bool? completed}) async {
    final localId = generateLocalId();
    final item = OfflineQueueItem(
      localId: localId,
      actionType: OfflineActionType.lessonProgress,
      payload: {
        'lessonId': lessonId,
        'moduleId': moduleId,
        'progress': progress,
        'completed': completed,
        'timestamp': DateTime.now().toIso8601String(),
      },
      createdAt: DateTime.now(),
    );
    _queue.add(item);
    await _saveQueue();
  }

  // Queue quiz result offline
  Future<void> queueQuizResult({required String lessonId, required int score, required int total}) async {
    final localId = generateLocalId();
    final item = OfflineQueueItem(
      localId: localId,
      actionType: OfflineActionType.quizResult,
      payload: {
        'lessonId': lessonId,
        'score': score,
        'total': total,
        'timestamp': DateTime.now().toIso8601String(),
      },
      createdAt: DateTime.now(),
    );
    _queue.add(item);
    await _saveQueue();
  }

  Future<void> removeFromQueue(String localId) async {
    _queue.removeWhere((e) => e.localId == localId);
    await _saveQueue();
  }

  Future<void> updateQueueItem(OfflineQueueItem updated) async {
    final idx = _queue.indexWhere((e) => e.localId == updated.localId);
    if (idx != -1) {
      _queue[idx] = updated;
      await _saveQueue();
    }
  }

  // Offline lessons download
  Future<void> saveOfflineLesson(OfflineLesson lesson) async {
    final prefs = await SharedPreferences.getInstance();
    final existingStr = prefs.getString(_lessonsKey);
    List list = existingStr != null ? jsonDecode(existingStr) : [];
    list.removeWhere((e) => e['lessonId'] == lesson.lessonId);
    list.add(lesson.toMap());
    await prefs.setString(_lessonsKey, jsonEncode(list));
  }

  Future<List<OfflineLesson>> getOfflineLessons() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_lessonsKey);
    if (jsonStr == null) return [];
    final List list = jsonDecode(jsonStr);
    return list.map((e) => OfflineLesson.fromMap(e)).toList();
  }

  Future<void> clearSynced() async {
    _queue.removeWhere((e) => e.syncStatus == SyncStatus.synced);
    await _saveQueue();
  }

  int get pendingCount => pendingQueue.length;
}
