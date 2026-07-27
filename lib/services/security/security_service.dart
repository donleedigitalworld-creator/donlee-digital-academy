import 'package:flutter/foundation.dart';
import '../../models/security/security_model.dart';

class SecurityService {
  List<SecurityAuditLog> _mockLogs = [];
  bool _isBiometricEnabled = false;
  bool _isTwoFactorEnabled = false;

  Future<void> init() async {
    _mockLogs = List.generate(10, (i) => SecurityAuditLog(
      id: 'log_$i',
      userId: 'user_${i % 5}',
      userName: ['Amara Okafor', 'Admin Donlee', 'Judge Nike', 'Mrs. Okafor (Parent)', 'Ms. Amara Teacher'][i % 5],
      action: AuditAction.values[i % AuditAction.values.length],
      level: SecurityLevel.values[i % 4],
      timestamp: DateTime.now().subtract(Duration(hours: i * 3)),
      ipAddress: '192.168.1.${10 + i}',
      deviceInfo: ['Android 13', 'iOS 17', 'Chrome Windows'][i % 3],
      details: {'resource': ['competition_submission', 'ai_feedback', 'certificate', 'offline_queue'][i % 4], 'status': i % 7 == 0 ? 'suspicious' : 'normal'},
      isSuspicious: i % 7 == 0,
    ));
  }

  Future<List<SecurityAuditLog>> getAuditLogs({int limit = 20}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockLogs.take(limit).toList();
  }

  Future<List<RolePermission>> getRolePermissions() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return RolePermission.defaultRoles().values.toList();
  }

  Future<List<DataRetentionPolicy>> getRetentionPolicies() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DataRetentionPolicy.defaultPolicies();
  }

  Future<List<FeatureFlag>> getFeatureFlags() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return FeatureFlag.defaultFlags();
  }

  Future<bool> enableBiometric() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _isBiometricEnabled = true;
    debugPrint("Biometric enabled");
    return true;
  }

  Future<bool> enableTwoFactor(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _isTwoFactorEnabled = true;
    debugPrint("2FA enabled for $email - code sent");
    return true;
  }

  bool get isBiometricEnabled => _isBiometricEnabled;
  bool get isTwoFactorEnabled => _isTwoFactorEnabled;

  Future<void> logAction({required String userId, required String userName, required AuditAction action, required SecurityLevel level, Map<String, dynamic> details = const {}}) async {
    final log = SecurityAuditLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      userName: userName,
      action: action,
      level: level,
      timestamp: DateTime.now(),
      details: details,
    );
    _mockLogs.insert(0, log);
    debugPrint("Security Log: ${action.name} by $userName level ${level.name}");
  }

  Map<String, dynamic> getScalabilityMetrics() {
    return {
      'totalUsers': 45892,
      'activeNow': 1247,
      'apiVersion': 'v5',
      'multiTenant': true,
      'featureFlagsCount': FeatureFlag.defaultFlags().length,
      'offlineQueueAvg': 2.3,
      'lowBandwidthUsers': '41%',
      'aiRequestsPerDay': 12456,
      'storageUsedGB': 234.5,
      'cdnHitRate': 0.89,
      'autoScale': true,
      'localizationLanguages': 5, // en, yo, ig, ha, fr
    };
  }
}
