import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/artwork_model.dart';
import '../core/constants/app_constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Gallery - public artworks
  Stream<List<ArtworkModel>> getGalleryArtworks() {
    return _firestore
        .collection(AppConstants.artworksCollection)
        .where('isInGallery', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => ArtworkModel.fromMap({...d.data(), 'id': d.id})).toList());
  }

  // User Portfolio
  Stream<List<ArtworkModel>> getUserPortfolio(String userId) {
    return _firestore
        .collection(AppConstants.artworksCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => ArtworkModel.fromMap({...d.data(), 'id': d.id})).toList());
  }

  Future<void> uploadArtwork(ArtworkModel artwork) async {
    await _firestore.collection(AppConstants.artworksCollection).doc(artwork.id).set(artwork.toMap());
    await _firestore.collection(AppConstants.usersCollection).doc(artwork.userId).update({
      'totalArtworksUploaded': FieldValue.increment(1),
    });
  }

  // Notifications - mock for Phase 1
  Stream<List<NotificationModel>> getUserNotifications(String userId) {
    // In Phase 1, we return mock data if collection empty
    return _firestore
        .collection(AppConstants.notificationsCollection)
        .where('userId', whereIn: [userId, 'global'])
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
          if (snap.docs.isEmpty) {
            return _mockNotifications();
          }
          return snap.docs.map((d) {
            final data = d.data();
            return NotificationModel(
              id: d.id,
              title: data['title'] ?? '',
              body: data['body'] ?? '',
              type: data['type'] ?? 'general',
              isRead: data['isRead'] ?? false,
              createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : DateTime.now(),
              actionLink: data['actionLink'],
            );
          }).toList();
        });
  }

  List<NotificationModel> _mockNotifications() {
    final now = DateTime.now();
    return [
      NotificationModel(
        id: '1',
        title: 'Welcome to Donlee Academy!',
        body: 'Start your journey with Introduction to Fine Art. Your creativity awaits!',
        type: 'lesson',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 2)),
        actionLink: 'intro_fine_art',
      ),
      NotificationModel(
        id: '2',
        title: 'New Challenge: 7-Day Sketch',
        body: 'Challenge yourself to sketch for 7 days straight. Share in gallery!',
        type: 'challenge',
        isRead: false,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: '3',
        title: 'Color Theory Lesson Updated',
        body: 'We added new step-by-step tutorials for understanding complementary colors.',
        type: 'lesson',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 2)),
        actionLink: 'color_theory',
      ),
    ];
  }
}
