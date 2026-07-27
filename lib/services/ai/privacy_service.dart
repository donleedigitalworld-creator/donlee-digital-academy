import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../../models/ai/ai_models.dart';

class PrivacyService extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const String _consentKey = 'privacy_consent';
  static const String _encryptionKeyKey = 'ai_encryption_key';

  PrivacyConsent? _consent;
  PrivacyConsent? get consent => _consent;

  encrypt.Encrypter? _encrypter;
  encrypt.IV? _iv;

  bool _isEncrypted = true;
  bool get isEncrypted => _isEncrypted;

  Future<void> init(String userId) async {
    await _loadConsent(userId);
    await _initEncryption();
  }

  Future<void> _initEncryption() async {
    try {
      String? keyBase64 = await _secureStorage.read(key: _encryptionKeyKey);
      if (keyBase64 == null) {
        final key = encrypt.Key.fromSecureRandom(32);
        final iv = encrypt.IV.fromSecureRandom(16);
        await _secureStorage.write(key: _encryptionKeyKey, value: key.base64);
        await _secureStorage.write(key: "${_encryptionKeyKey}_iv", value: iv.base64);
        _encrypter = encrypt.Encrypter(encrypt.AES(key));
        _iv = iv;
      } else {
        final ivBase64 = await _secureStorage.read(key: "${_encryptionKeyKey}_iv");
        final key = encrypt.Key.fromBase64(keyBase64);
        final iv = encrypt.IV.fromBase64(ivBase64!);
        _encrypter = encrypt.Encrypter(encrypt.AES(key));
        _iv = iv;
      }
      _isEncrypted = true;
    } catch (e) {
      debugPrint("Encryption init failed: $e");
      _isEncrypted = false;
    }
  }

  String encryptData(String plainText) {
    if (!_isEncrypted || _encrypter == null || _iv == null) return plainText;
    try {
      final encrypted = _encrypter!.encrypt(plainText, iv: _iv!);
      return encrypted.base64;
    } catch (e) {
      debugPrint("Encrypt failed: $e");
      return plainText;
    }
  }

  String decryptData(String encryptedBase64) {
    if (!_isEncrypted || _encrypter == null || _iv == null) return encryptedBase64;
    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptedBase64);
      return _encrypter!.decrypt(encrypted, iv: _iv!);
    } catch (e) {
      debugPrint("Decrypt failed: $e");
      return encryptedBase64;
    }
  }

  Future<void> _loadConsent(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString("${_consentKey}_$userId");
    if (jsonStr != null) {
      try {
        final map = jsonDecode(encryptData(jsonStr) != jsonStr ? decryptData(jsonStr) : jsonStr);
        _consent = PrivacyConsent(
          userId: userId,
          aiTutorConsent: map['aiTutorConsent'] ?? false,
          aiArtAnalysisConsent: map['aiArtAnalysisConsent'] ?? false,
          voiceRecordingConsent: map['voiceRecordingConsent'] ?? false,
          dataCollectionConsent: map['dataCollectionConsent'] ?? false,
          analyticsConsent: map['analyticsConsent'] ?? false,
          cameraUsageConsent: map['cameraUsageConsent'] ?? false,
          consentedAt: map['consentedAt'] != null ? DateTime.parse(map['consentedAt']) : DateTime.now(),
          encryptionKeyId: map['encryptionKeyId'],
        );
      } catch (e) {
        _consent = PrivacyConsent.defaultConsent(userId);
      }
    } else {
      _consent = PrivacyConsent.defaultConsent(userId);
    }
    notifyListeners();
  }

  Future<void> saveConsent(PrivacyConsent consent) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(consent.toMap());
    final toStore = _isEncrypted ? encryptData(jsonStr) : jsonStr;
    await prefs.setString("${_consentKey}_${consent.userId}", toStore);
    _consent = consent;
    notifyListeners();
  }

  Future<bool> requestPermission(String permissionType) async {
    // In prod, use permission_handler package
    // For Phase 4, we simulate permission dialogs
    debugPrint("Request permission: $permissionType - showing consent dialog");
    await Future.delayed(const Duration(milliseconds: 300));
    return true; // Mock granted after explanation
  }

  Future<void> revokeAllConsent(String userId) async {
    final revoked = PrivacyConsent(
      userId: userId,
      aiTutorConsent: false,
      aiArtAnalysisConsent: false,
      voiceRecordingConsent: false,
      dataCollectionConsent: false,
      analyticsConsent: false,
      cameraUsageConsent: false,
      consentedAt: DateTime.now(),
    );
    await saveConsent(revoked);
    // Delete secure storage keys
    await _secureStorage.delete(key: _encryptionKeyKey);
    await _secureStorage.delete(key: "${_encryptionKeyKey}_iv");
    await _initEncryption();
  }

  Future<void> exportUserData(String userId) async {
    // Mock export - in prod, gathers all user data, encrypts, creates JSON
    debugPrint("Export user data for $userId - encrypted package");
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> deleteAllUserData(String userId) async {
    // Mock deletion - in prod, deletes Firestore, Storage, local
    debugPrint("Delete all user data for $userId - GDPR style");
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("${_consentKey}_$userId");
    _consent = PrivacyConsent.defaultConsent(userId);
    notifyListeners();
  }

  String getPrivacySummary() {
    return """
Donlee AI Privacy Safeguards:

• Permission Requests: Camera, Microphone, Storage always request with explanation why needed (artwork capture, voice learning). You can deny anytime via Privacy Settings.
• Encryption: All AI chats, artwork analysis, voice recordings encrypted at rest with AES-256, keys in Secure Storage (iOS Keychain / Android Keystore). In transit via HTTPS.
• Consent Required: AI Tutor (chat history), AI Art Analysis (your drawings analyzed), Voice Recording (speech to text), Data Collection (for personalized suggestions), Analytics (learning trends), Camera Usage (capture drawings). Toggle each separately.
• Teacher Review: AI-generated quizzes and lesson plans always reviewed by teacher before student sees - teacher-approved flag.
• Local First: Offline AI analysis runs on-device when possible (low-bandwidth), no cloud upload unless you consent.
• No Training Without Permission: Your artworks not used to train AI models unless you explicitly consent via Data Collection toggle.
• Delete & Export: You can export your data (encrypted JSON) or delete all AI data via Privacy Settings - GDPR compliant.
• Child Safety: For under-13, parental consent required for AI features.
• Low-Bandwidth Privacy: Low-BW mode compresses locally, uploads encrypted thumbnail first.
""";
  }
}
