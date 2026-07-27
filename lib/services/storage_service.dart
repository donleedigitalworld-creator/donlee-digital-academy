import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // Profile Photos: profiles/{uid}/avatar.jpg - secure per user
  Future<String?> uploadProfilePhoto(String uid, XFile file) async {
    try {
      final ref = _storage.ref().child('profiles/$uid/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg');
      if (kIsWeb) {
        final bytes = await file.readAsBytes();
        await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
      } else {
        await ref.putFile(File(file.path), SettableMetadata(contentType: 'image/jpeg'));
      }
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint("Upload profile photo failed: $e");
      return null;
    }
  }

  // Artwork Uploads: portfolios/{uid}/{assignmentId?}/{timestamp}.jpg
  Future<List<String>> uploadArtworkImages({
    required String uid,
    required List<XFile> files,
    String? assignmentId,
    String? classId,
  }) async {
    List<String> urls = [];
    for (var file in files) {
      try {
        final path = assignmentId != null
            ? 'submissions/$assignmentId/$uid/${DateTime.now().millisecondsSinceEpoch}_${file.name}'
            : 'portfolios/$uid/${DateTime.now().millisecondsSinceEpoch}_${file.name}';
        final ref = _storage.ref().child(path);
        if (kIsWeb) {
          final bytes = await file.readAsBytes();
          await ref.putData(bytes);
        } else {
          await ref.putFile(File(file.path));
        }
        final url = await ref.getDownloadURL();
        urls.add(url);
      } catch (e) {
        debugPrint("Upload artwork failed: $e");
      }
    }
    return urls;
  }

  // Camera capture for drawings
  Future<XFile?> captureWithCamera() async {
    try {
      return await _picker.pickImage(source: ImageSource.camera, imageQuality: 80, maxWidth: 2000);
    } catch (e) {
      debugPrint("Camera capture failed: $e");
      return null;
    }
  }

  Future<List<XFile>?> pickFromGallery({bool allowMultiple = true}) async {
    try {
      if (allowMultiple) {
        return await _picker.pickMultiImage(imageQuality: 80, maxWidth: 2000);
      } else {
        final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80, maxWidth: 2000);
        return file != null ? [file] : null;
      }
    } catch (e) {
      debugPrint("Gallery pick failed: $e");
      return null;
    }
  }

  Future<void> deleteFile(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } catch (e) {
      debugPrint("Delete failed: $e");
    }
  }
}
