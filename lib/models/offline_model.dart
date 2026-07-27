import 'competition_model.dart';

enum OfflineActionType { competitionSubmission, assignmentSubmission, lessonProgress, quizResult, artworkUpload, profilePhoto }
enum SyncStatus { pending, syncing, synced, failed, conflict }

class OfflineQueueItem {
  final String localId;
  final OfflineActionType actionType;
  final String? competitionId;
  final String? assignmentId;
  final Map<String, dynamic> payload;
  final List<String> localImagePaths;
  final DateTime createdAt;
  final SyncStatus syncStatus;
  final int retryCount;
  final String? errorMessage;
  final bool lowBandwidthMode;

  OfflineQueueItem({
    required this.localId,
    required this.actionType,
    this.competitionId,
    this.assignmentId,
    required this.payload,
    this.localImagePaths = const [],
    required this.createdAt,
    this.syncStatus = SyncStatus.pending,
    this.retryCount = 0,
    this.errorMessage,
    this.lowBandwidthMode = false,
  });

  factory OfflineQueueItem.fromMap(Map<String, dynamic> map) {
    return OfflineQueueItem(
      localId: map['localId'] ?? '',
      actionType: OfflineActionType.values.byName(map['actionType'] ?? 'competitionSubmission'),
      competitionId: map['competitionId'],
      assignmentId: map['assignmentId'],
      payload: Map<String, dynamic>.from(map['payload'] ?? {}),
      localImagePaths: List<String>.from(map['localImagePaths'] ?? []),
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      syncStatus: SyncStatus.values.byName(map['syncStatus'] ?? 'pending'),
      retryCount: map['retryCount'] ?? 0,
      errorMessage: map['errorMessage'],
      lowBandwidthMode: map['lowBandwidthMode'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'localId': localId,
    'actionType': actionType.name,
    'competitionId': competitionId,
    'assignmentId': assignmentId,
    'payload': payload,
    'localImagePaths': localImagePaths,
    'createdAt': createdAt.toIso8601String(),
    'syncStatus': syncStatus.name,
    'retryCount': retryCount,
    'errorMessage': errorMessage,
    'lowBandwidthMode': lowBandwidthMode,
  };

  OfflineQueueItem copyWith({SyncStatus? syncStatus, int? retryCount, String? errorMessage}) {
    return OfflineQueueItem(
      localId: localId,
      actionType: actionType,
      competitionId: competitionId,
      assignmentId: assignmentId,
      payload: payload,
      localImagePaths: localImagePaths,
      createdAt: createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      lowBandwidthMode: lowBandwidthMode,
    );
  }
}

class OfflineLesson {
  final String lessonId;
  final String moduleId;
  final String title;
  final String contentJson;
  final List<String> imageUrls;
  final DateTime downloadedAt;
  final bool quizCompleted;
  final int? quizScore;

  OfflineLesson({
    required this.lessonId,
    required this.moduleId,
    required this.title,
    required this.contentJson,
    this.imageUrls = const [],
    required this.downloadedAt,
    this.quizCompleted = false,
    this.quizScore,
  });

  Map<String, dynamic> toMap() => {
    'lessonId': lessonId,
    'moduleId': moduleId,
    'title': title,
    'contentJson': contentJson,
    'imageUrls': imageUrls,
    'downloadedAt': downloadedAt.toIso8601String(),
    'quizCompleted': quizCompleted,
    'quizScore': quizScore,
  };

  factory OfflineLesson.fromMap(Map<String, dynamic> map) {
    return OfflineLesson(
      lessonId: map['lessonId'] ?? '',
      moduleId: map['moduleId'] ?? '',
      title: map['title'] ?? '',
      contentJson: map['contentJson'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      downloadedAt: map['downloadedAt'] != null ? DateTime.parse(map['downloadedAt']) : DateTime.now(),
      quizCompleted: map['quizCompleted'] ?? false,
      quizScore: map['quizScore'],
    );
  }
}
