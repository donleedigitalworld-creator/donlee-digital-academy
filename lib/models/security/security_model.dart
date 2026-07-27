enum AuditAction { login, logout, dataAccess, dataModification, permissionChange, certificateIssued, competitionJudged, aiAnalysis, offlineSync }
enum SecurityLevel { low, medium, high, critical }
enum AuthMethod { password, biometric, twoFactor, sso }

class SecurityAuditLog {
  final String id;
  final String userId;
  final String userName;
  final AuditAction action;
  final SecurityLevel level;
  final DateTime timestamp;
  final String? ipAddress;
  final String? deviceInfo;
  final Map<String, dynamic> details;
  final bool isSuspicious;

  SecurityAuditLog({
    required this.id,
    required this.userId,
    required this.userName,
    required this.action,
    required this.level,
    required this.timestamp,
    this.ipAddress,
    this.deviceInfo,
    this.details = const {},
    this.isSuspicious = false,
  });
}

class RolePermission {
  final String role; // student, teacher, judge, parent, schoolAdmin, nationalAdmin
  final List<String> permissions; // e.g. ["read_own_submissions", "judge_competition", "manage_schools"]
  final Map<String, bool> featureFlags; // feature toggles for scalability
  final bool canAccessAI;
  final bool canAccessCompetitionJudging;
  final bool canManageUsers;
  final bool canViewAnalytics;
  final bool canIssueCertificates;

  RolePermission({
    required this.role,
    required this.permissions,
    this.featureFlags = const {},
    this.canAccessAI = false,
    this.canAccessCompetitionJudging = false,
    this.canManageUsers = false,
    this.canViewAnalytics = false,
    this.canIssueCertificates = false,
  });

  static Map<String, RolePermission> defaultRoles() {
    return {
      'student': RolePermission(role: 'student', permissions: ['read_own_progress', 'submit_artwork', 'view_gallery', 'access_ai_tutor', 'offline_queue'], canAccessAI: true, featureFlags: {'ai_tutor': true, 'competitions': true, 'offline': true}),
      'parent': RolePermission(role: 'parent', permissions: ['view_child_progress', 'view_child_certificates', 'receive_notifications', 'consent_management'], canViewAnalytics: true, featureFlags: {'parent_portal': true, 'ai_analytics': true}),
      'teacher': RolePermission(role: 'teacher', permissions: ['manage_classes', 'create_assignments', 'grade_submissions', 'view_student_progress', 'use_ai_teacher_tools', 'judge_competition_if_assigned'], canAccessAI: true, canAccessCompetitionJudging: true, canViewAnalytics: true, canIssueCertificates: true, featureFlags: {'teacher_portal': true, 'ai_tools': true, 'judging': true}),
      'judge': RolePermission(role: 'judge', permissions: ['judge_competition', 'view_submissions_blind', 'submit_scores'], canAccessCompetitionJudging: true, featureFlags: {'judging': true}),
      'schoolAdmin': RolePermission(role: 'schoolAdmin', permissions: ['manage_school', 'manage_teachers', 'manage_students', 'view_school_analytics', 'manage_resources'], canManageUsers: true, canViewAnalytics: true, canIssueCertificates: true, featureFlags: {'school_management': true}),
      'nationalAdmin': RolePermission(role: 'nationalAdmin', permissions: ['manage_all_schools', 'manage_national_competitions', 'manage_users', 'view_national_analytics', 'manage_exhibitions_scholarships', 'audit_logs'], canManageUsers: true, canViewAnalytics: true, canIssueCertificates: true, canAccessCompetitionJudging: true, canAccessAI: true, featureFlags: {'national_dashboard': true, 'admin': true, 'all': true}),
    };
  }
}

class DataRetentionPolicy {
  final String dataType; // e.g. "ai_chats", "artwork_submissions", "voice_recordings"
  final int retentionDays;
  final bool autoDelete;
  final bool encryptAtRest;
  final String description;

  DataRetentionPolicy({
    required this.dataType,
    required this.retentionDays,
    required this.autoDelete,
    required this.encryptAtRest,
    required this.description,
  });

  static List<DataRetentionPolicy> defaultPolicies() {
    return [
      DataRetentionPolicy(dataType: 'ai_chats', retentionDays: 365, autoDelete: false, encryptAtRest: true, description: 'AI tutor chats encrypted, kept 1 year unless user deletes, consent required'),
      DataRetentionPolicy(dataType: 'artwork_submissions', retentionDays: 1095, autoDelete: false, encryptAtRest: true, description: 'Competition and assignment submissions kept 3 years for portfolio + exhibition history'),
      DataRetentionPolicy(dataType: 'voice_recordings', retentionDays: 90, autoDelete: true, encryptAtRest: true, description: 'Voice recordings auto-delete after 90 days unless user saves, encrypted'),
      DataRetentionPolicy(dataType: 'analytics', retentionDays: 730, autoDelete: false, encryptAtRest: true, description: 'Anonymized analytics kept 2 years for national trends, no PII'),
      DataRetentionPolicy(dataType: 'offline_queue', retentionDays: 30, autoDelete: true, encryptAtRest: true, description: 'Offline queue items auto-delete after 30 days if not synced, encrypted local'),
    ];
  }
}

class FeatureFlag {
  final String key;
  final bool enabled;
  final String description;
  final List<String> enabledForRoles;
  final bool requiresNationalAdmin;

  FeatureFlag({
    required this.key,
    required this.enabled,
    required this.description,
    this.enabledForRoles = const [],
    this.requiresNationalAdmin = false,
  });

  static List<FeatureFlag> defaultFlags() {
    return [
      FeatureFlag(key: 'ai_tutor', enabled: true, description: 'AI Tutor Chat', enabledForRoles: ['student', 'teacher']),
      FeatureFlag(key: 'ai_drawing_feedback', enabled: true, description: 'AI Drawing Analysis', enabledForRoles: ['student', 'teacher']),
      FeatureFlag(key: 'national_competitions', enabled: true, description: 'National Competitions', enabledForRoles: ['student', 'teacher', 'schoolAdmin', 'nationalAdmin']),
      FeatureFlag(key: 'offline_mode', enabled: true, description: 'Offline Queue & Low-Bandwidth', enabledForRoles: ['all']),
      FeatureFlag(key: 'parent_portal', enabled: true, description: 'Parent Portal - child progress + consents', enabledForRoles: ['parent', 'schoolAdmin', 'nationalAdmin']),
      FeatureFlag(key: 'career_center', enabled: true, description: 'Career & Opportunity Center', enabledForRoles: ['student', 'teacher']),
      FeatureFlag(key: 'community', enabled: true, description: 'Community Feed, Forums, Clubs', enabledForRoles: ['all']),
      FeatureFlag(key: 'advanced_analytics', enabled: true, description: 'Advanced Analytics + Predictions', enabledForRoles: ['teacher', 'schoolAdmin', 'nationalAdmin', 'parent']),
      FeatureFlag(key: 'digital_certificates', enabled: true, description: 'Verifiable Certificates with QR + Blockchain mock', enabledForRoles: ['all']),
      FeatureFlag(key: 'resource_library', enabled: true, description: 'Resource Library - videos, templates, reference images', enabledForRoles: ['all']),
      FeatureFlag(key: 'accessibility', enabled: true, description: 'Accessibility Options', enabledForRoles: ['all']),
      FeatureFlag(key: 'exhibition_scholarship', enabled: true, description: 'Exhibition & Scholarship Future-Ready', enabledForRoles: ['all']),
    ];
  }
}
