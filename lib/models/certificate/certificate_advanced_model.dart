import 'package:flutter/material.dart';

enum CertificateTemplate { classicGold, modernMinimal, nationalChampionship, exhibition, scholarship, completion }
enum VerificationStatus { valid, expired, revoked, notFound }
enum SharePlatform { linkedin, twitter, whatsapp, email, pdf }

class DigitalCertificateAdvanced {
  final String id;
  final String certificateNumber; // DON-YYYY-XXXXXX or DON-NAC-XXXX
  final CertificateTemplate template;
  final String studentId;
  final String studentName;
  final String? studentPhotoUrl;
  final String title;
  final String description;
  final String issuedBy;
  final String issuedById;
  final String? schoolId;
  final String? schoolName;
  final String? competitionId;
  final String? moduleId;
  final String? courseId;
  final DateTime issuedAt;
  final DateTime? expiresAt;
  final int? score;
  final String? grade;
  final String qrCodeData; // verification URL
  final String blockchainHash; // mock hash for future blockchain
  final bool isRevoked;
  final String? revokedReason;
  final Map<String, dynamic> metadata;
  final List<String> skills; // e.g. ["Loomis Method", "Value Mastery"]
  final VerificationStatus verificationStatus;

  DigitalCertificateAdvanced({
    required this.id,
    required this.certificateNumber,
    required this.template,
    required this.studentId,
    required this.studentName,
    this.studentPhotoUrl,
    required this.title,
    required this.description,
    required this.issuedBy,
    required this.issuedById,
    this.schoolId,
    this.schoolName,
    this.competitionId,
    this.moduleId,
    this.courseId,
    required this.issuedAt,
    this.expiresAt,
    this.score,
    this.grade,
    required this.qrCodeData,
    required this.blockchainHash,
    this.isRevoked = false,
    this.revokedReason,
    this.metadata = const {},
    this.skills = const [],
    this.verificationStatus = VerificationStatus.valid,
  });

  factory DigitalCertificateAdvanced.mockNational() {
    final now = DateTime.now();
    return DigitalCertificateAdvanced(
      id: 'cert_nat_1',
      certificateNumber: 'DON-NAC-2025-A1B2C3',
      template: CertificateTemplate.nationalChampionship,
      studentId: 'student1',
      studentName: 'Amara Okafor',
      title: 'National Art Championship 2025 - 1st Place',
      description: 'Awarded for outstanding artwork "Unity Mask - Mother and Child" - Theme: Nigeria at 65: Unity in Diversity. Rank #1 out of 187 submissions, judged by 3 judges + Chief Judge, secure blind review.',
      issuedBy: 'Donlee National Jury - Chief Judge Prof. Nike Davies',
      issuedById: 'judge1',
      schoolId: 's1',
      schoolName: 'Donlee Main - Lagos',
      competitionId: 'comp1',
      issuedAt: now.subtract(const Duration(days: 5)),
      score: 94,
      grade: 'Distinction',
      qrCodeData: 'https://donlee.art/verify/DON-NAC-2025-A1B2C3',
      blockchainHash: '0x9f8c...a1b2 Mock Blockchain Hash for Future',
      skills: ['Portrait Mastery', 'Color Harmony', 'Cultural Storytelling', 'Composition'],
      metadata: {'rank': 1, 'totalEntries': 187, 'exhibitionSelected': true, 'scholarshipEligible': true},
    );
  }

  factory DigitalCertificateAdvanced.mockModule() {
    return DigitalCertificateAdvanced(
      id: 'cert_mod_1',
      certificateNumber: 'DON-2024-E8F9G0',
      template: CertificateTemplate.completion,
      studentId: 'student1',
      studentName: 'Amara Okafor',
      title: 'Elements of Art - Mastery Certificate',
      description: 'Successfully completed Elements of Art module with distinction - mastering line, shape, form, color, value, texture, space',
      issuedBy: 'Donlee Academy - Ms. Amara',
      issuedById: 't1',
      moduleId: 'elements_of_art',
      issuedAt: DateTime.now().subtract(const Duration(days: 20)),
      score: 92,
      grade: 'A',
      qrCodeData: 'https://donlee.art/verify/DON-2024-E8F9G0',
      blockchainHash: '0xabc123...mock',
      skills: ['7 Elements of Art', 'Value Scale 9 Steps', 'Texture Marks'],
    );
  }
}

class CertificateVerificationResult {
  final String certificateNumber;
  final VerificationStatus status;
  final DigitalCertificateAdvanced? certificate;
  final String? error;
  final DateTime verifiedAt;

  CertificateVerificationResult({
    required this.certificateNumber,
    required this.status,
    this.certificate,
    this.error,
    required this.verifiedAt,
  });
}
