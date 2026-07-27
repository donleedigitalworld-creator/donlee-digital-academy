enum MFAMethodType { totp, sms, email, biometric, recoveryCode }
enum MFAStatus { disabled, enabled, pendingSetup }

class MFAMethod {
  final String id;
  final MFAMethodType type;
  final MFAStatus status;
  final bool isPrimary;
  final DateTime? enrolledAt;
  final DateTime? lastUsedAt;
  final String? maskedIdentifier; // e.g., ***1234 for phone

  MFAMethod({
    required this.id,
    required this.type,
    required this.status,
    this.isPrimary = false,
    this.enrolledAt,
    this.lastUsedAt,
    this.maskedIdentifier,
  });
}

class TrustedDevice {
  final String id;
  final String deviceName;
  final String deviceModel;
  final String? ipAddress;
  final DateTime trustedAt;
  final DateTime lastActiveAt;
  final bool isCurrentDevice;

  TrustedDevice({
    required this.id,
    required this.deviceName,
    required this.deviceModel,
    this.ipAddress,
    required this.trustedAt,
    required this.lastActiveAt,
    this.isCurrentDevice = false,
  });
}

class RecoveryCode {
  final String code;
  final bool isUsed;
  final DateTime createdAt;

  RecoveryCode({required this.code, this.isUsed = false, required this.createdAt});
}
