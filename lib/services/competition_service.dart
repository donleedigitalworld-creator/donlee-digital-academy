import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/competition_model.dart';

class CompetitionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Competition CRUD (Admin)
  Future<String> createCompetition(CompetitionModel comp) async {
    final docRef = _firestore.collection('competitions').doc();
    final newComp = CompetitionModel(
      id: docRef.id,
      title: comp.title,
      description: comp.description,
      theme: comp.theme,
      organizer: comp.organizer,
      sponsor: comp.sponsor,
      coverImageUrl: comp.coverImageUrl,
      status: comp.status,
      categories: comp.categories,
      judgingCriteria: comp.judgingCriteria,
      createdAt: DateTime.now(),
      registrationStart: comp.registrationStart,
      registrationEnd: comp.registrationEnd,
      submissionStart: comp.submissionStart,
      submissionEnd: comp.submissionEnd,
      judgingStart: comp.judgingStart,
      judgingEnd: comp.judgingEnd,
      resultsDate: comp.resultsDate,
      eligibleSchoolIds: comp.eligibleSchoolIds,
      judgeIds: comp.judgeIds,
      chiefJudgeId: comp.chiefJudgeId,
      prizes: comp.prizes,
      allowOfflineSubmission: comp.allowOfflineSubmission,
      lowBandwidthMode: comp.lowBandwidthMode,
      isScholarshipLinked: comp.isScholarshipLinked,
      isExhibitionLinked: comp.isExhibitionLinked,
      tags: comp.tags,
    );
    await docRef.set(newComp.toMap());
    return docRef.id;
  }

  Stream<List<CompetitionModel>> getCompetitions() {
    return _firestore.collection('competitions').orderBy('createdAt', descending: true).snapshots().map((snap) => snap.docs.map((d) => CompetitionModel.fromMap(d.data(), d.id)).toList());
  }

  Stream<List<CompetitionModel>> getActiveCompetitions() {
    return _firestore.collection('competitions').where('status', whereIn: ['registrationOpen', 'submissionOpen', 'judging', 'resultsPublished']).orderBy('resultsDate').snapshots().map((snap) => snap.docs.map((d) => CompetitionModel.fromMap(d.data(), d.id)).toList());
  }

  Future<CompetitionModel?> getCompetition(String id) async {
    try {
      final doc = await _firestore.collection('competitions').doc(id).get();
      if (!doc.exists) return null;
      return CompetitionModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      debugPrint("Get competition failed: $e");
      return null;
    }
  }

  // Registration
  Future<String> registerForCompetition(CompetitionRegistration reg) async {
    final docRef = _firestore.collection('competition_registrations').doc();
    final newReg = CompetitionRegistration(
      id: docRef.id,
      competitionId: reg.competitionId,
      studentId: reg.studentId,
      studentName: reg.studentName,
      studentPhotoUrl: reg.studentPhotoUrl,
      schoolId: reg.schoolId,
      schoolName: reg.schoolName,
      classId: reg.classId,
      categoryId: reg.categoryId,
      registeredAt: DateTime.now(),
      isApproved: true,
    );
    await docRef.set(newReg.toMap());
    await _firestore.collection('competitions').doc(reg.competitionId).update({
      'totalRegistrations': FieldValue.increment(1),
    });
    return docRef.id;
  }

  Stream<List<CompetitionRegistration>> getCompetitionRegistrations(String competitionId) {
    return _firestore.collection('competition_registrations').where('competitionId', isEqualTo: competitionId).snapshots().map((snap) => snap.docs.map((d) => CompetitionRegistration.fromMap(d.data(), d.id)).toList());
  }

  // Submission - online
  Future<String> submitArtwork(CompetitionSubmission submission) async {
    final docRef = _firestore.collection('competition_submissions').doc();
    final newSub = CompetitionSubmission(
      id: docRef.id,
      competitionId: submission.competitionId,
      registrationId: submission.registrationId,
      studentId: submission.studentId,
      studentName: submission.studentName,
      studentPhotoUrl: submission.studentPhotoUrl,
      schoolId: submission.schoolId,
      schoolName: submission.schoolName,
      categoryId: submission.categoryId,
      title: submission.title,
      description: submission.description,
      artistStatement: submission.artistStatement,
      imageUrls: submission.imageUrls,
      lowResImageUrls: submission.lowResImageUrls,
      submissionType: SubmissionType.online,
      submittedAt: DateTime.now(),
      isVerified: submission.isVerified,
      metadata: submission.metadata,
    );
    await docRef.set(newSub.toMap());
    await _firestore.collection('competitions').doc(submission.competitionId).update({
      'totalSubmissions': FieldValue.increment(1),
    });
    return docRef.id;
  }

  Stream<List<CompetitionSubmission>> getCompetitionSubmissions(String competitionId) {
    return _firestore.collection('competition_submissions').where('competitionId', isEqualTo: competitionId).orderBy('submittedAt', descending: true).snapshots().map((snap) => snap.docs.map((d) => CompetitionSubmission.fromMap(d.data(), d.id)).toList());
  }

  Stream<List<CompetitionSubmission>> getStudentSubmissions(String studentId) {
    return _firestore.collection('competition_submissions').where('studentId', isEqualTo: studentId).orderBy('submittedAt', descending: true).snapshots().map((snap) => snap.docs.map((d) => CompetitionSubmission.fromMap(d.data(), d.id)).toList());
  }

  // Judging
  Future<void> submitScore(JudgingScore score) async {
    final docRef = _firestore.collection('judging_scores').doc();
    await docRef.set({...score.toMap(), 'id': docRef.id});
  }

  Stream<List<JudgingScore>> getSubmissionScores(String submissionId) {
    return _firestore.collection('judging_scores').where('submissionId', isEqualTo: submissionId).snapshots().map((snap) => snap.docs.map((d) => JudgingScore.fromMap(d.data(), d.id)).toList());
  }

  // Results
  Future<void> publishResults(List<CompetitionResult> results) async {
    final batch = _firestore.batch();
    for (var res in results) {
      final docRef = _firestore.collection('competition_results').doc();
      batch.set(docRef, {...res.toMap(), 'id': docRef.id});
      // Auto-certificate for top 3
      if (res.rank <= 3) {
        final certRef = _firestore.collection('certificates').doc();
        batch.set(certRef, {
          'studentId': res.studentId,
          'studentName': res.studentName,
          'type': 'challenge',
          'title': 'National Art Competition - Rank #${res.rank}',
          'description': '${res.title} - ${res.schoolName} - Rank ${res.rank} out of category',
          'competitionId': res.competitionId,
          'issuedBy': 'Donlee National Competition Jury',
          'issuedAt': DateTime.now().toIso8601String(),
          'certificateNumber': 'DON-NAC-2025-${docRef.id.substring(0, 6).toUpperCase()}',
          'score': res.finalScore.toInt(),
        });
      }
    }
    await batch.commit();
    // Update competition status
    await _firestore.collection('competitions').doc(results.first.competitionId).update({'status': 'resultsPublished'});
  }

  Stream<List<CompetitionResult>> getCompetitionResults(String competitionId) {
    return _firestore.collection('competition_results').where('competitionId', isEqualTo: competitionId).orderBy('rank').snapshots().map((snap) => snap.docs.map((d) => CompetitionResult.fromMap(d.data(), d.id)).toList());
  }

  // Mock data for Phase 3 demo
  List<CompetitionModel> getMockCompetitions() {
    final now = DateTime.now();
    return [
      CompetitionModel(
        id: 'comp1',
        title: 'Donlee National Art Championship 2025',
        description: 'Nigeria\'s biggest student art competition celebrating creativity, culture, and unity. Open to all secondary schools nationwide.',
        theme: 'Nigeria at 65: Unity in Diversity Through Art',
        organizer: 'Donlee Digital World Academy',
        sponsor: 'MTN Foundation & Lagos State Ministry of Education',
        coverImageUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=800',
        status: CompetitionStatus.submissionOpen,
        categories: [
          CompetitionCategory(id: 'cat1', name: 'Junior Drawing (8-12)', description: 'Pencil, charcoal, ink', type: CompetitionCategoryType.drawing, ageGroup: '8-12'),
          CompetitionCategory(id: 'cat2', name: 'Senior Painting (13-17)', description: 'Watercolor, acrylic, oil', type: CompetitionCategoryType.painting, ageGroup: '13-17'),
          CompetitionCategory(id: 'cat3', name: 'Digital Art Open', description: 'Digital illustration, tablet art', type: CompetitionCategoryType.digitalArt, ageGroup: 'Open'),
          CompetitionCategory(id: 'cat4', name: 'Portrait Masters', description: 'Any medium, focus on face', type: CompetitionCategoryType.portrait, ageGroup: 'Open'),
        ],
        judgingCriteria: [
          JudgingCriteria(id: 'c1', name: 'Creativity & Originality', description: 'Unique idea, personal voice', maxScore: 10, weight: 0.3),
          JudgingCriteria(id: 'c2', name: 'Technical Skill', description: 'Control of medium, proportion, anatomy', maxScore: 10, weight: 0.25),
          JudgingCriteria(id: 'c3', name: 'Composition', description: 'Balance, perspective, visual flow', maxScore: 10, weight: 0.2),
          JudgingCriteria(id: 'c4', name: 'Theme Interpretation', description: 'How well theme Unity in Diversity expressed', maxScore: 10, weight: 0.15),
          JudgingCriteria(id: 'c5', name: 'Emotional Impact', description: 'Connection, storytelling', maxScore: 10, weight: 0.1),
        ],
        createdAt: now.subtract(const Duration(days: 30)),
        registrationStart: now.subtract(const Duration(days: 25)),
        registrationEnd: now.add(const Duration(days: 5)),
        submissionStart: now.subtract(const Duration(days: 10)),
        submissionEnd: now.add(const Duration(days: 20)),
        judgingStart: now.add(const Duration(days: 21)),
        judgingEnd: now.add(const Duration(days: 35)),
        resultsDate: now.add(const Duration(days: 40)),
        judgeIds: ['judge1', 'judge2', 'judge3'],
        chiefJudgeId: 'judge1',
        prizes: {
          '1st': '₦500,000 + Scholarship + Lagos Exhibition',
          '2nd': '₦200,000 + Tablet + Certificate',
          '3rd': '₦100,000 + Art Kit + Certificate',
          'Top 10': 'Exhibition at Nike Art Gallery + Scholarship Eligible',
        },
        allowOfflineSubmission: true,
        lowBandwidthMode: true,
        isScholarshipLinked: true,
        isExhibitionLinked: true,
        totalRegistrations: 342,
        totalSubmissions: 187,
        tags: ['National', 'Scholarship', 'Exhibition', 'Offline Support'],
      ),
      CompetitionModel(
        id: 'comp2',
        title: 'Lagos State Inter-School Still Life Challenge',
        description: 'Still life mastery - observe Lagos markets, daily life',
        theme: 'Market Day - Colors of Lagos',
        organizer: 'Donlee Lagos Branch',
        coverImageUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=800',
        status: CompetitionStatus.registrationOpen,
        categories: [
          CompetitionCategory(id: 'cat5', name: 'Still Life Junior', description: 'Observe objects', type: CompetitionCategoryType.stillLife, ageGroup: '8-12'),
          CompetitionCategory(id: 'cat6', name: 'Still Life Senior', description: 'Advanced light/shadow', type: CompetitionCategoryType.stillLife, ageGroup: '13-17'),
        ],
        judgingCriteria: [
          JudgingCriteria(id: 'c1', name: 'Observation', description: 'Accuracy', maxScore: 10, weight: 0.4),
          JudgingCriteria(id: 'c2', name: 'Light & Shadow', description: '5 values', maxScore: 10, weight: 0.3),
          JudgingCriteria(id: 'c3', name: 'Composition', description: 'Arrangement', maxScore: 10, weight: 0.3),
        ],
        createdAt: now.subtract(const Duration(days: 5)),
        registrationStart: now.subtract(const Duration(days: 3)),
        registrationEnd: now.add(const Duration(days: 10)),
        submissionStart: now.add(const Duration(days: 11)),
        submissionEnd: now.add(const Duration(days: 25)),
        judgingStart: now.add(const Duration(days: 26)),
        judgingEnd: now.add(const Duration(days: 30)),
        resultsDate: now.add(const Duration(days: 35)),
        prizes: {'1st': '₦100k + Exhibition'},
        totalRegistrations: 89,
        totalSubmissions: 0,
        tags: ['Lagos', 'Still Life'],
      ),
    ];
  }

  List<CompetitionResult> getMockResults(String competitionId) {
    return [
      CompetitionResult(id: 'r1', competitionId: competitionId, categoryId: 'cat2', submissionId: 's1', studentId: 'stu1', studentName: 'Amara Okafor', schoolName: 'Donlee Main - Lagos', title: 'Unity Mask - Mother and Child', imageUrl: 'https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?w=800', rank: 1, finalScore: 94.5, avgScore: 94.5, totalJudges: 3, prize: {'title': '1st Prize', 'details': '₦500k + Scholarship + Exhibition'}, exhibitionSelected: true, scholarshipEligible: true, exhibitionStatus: ExhibitionStatus.awarded),
      CompetitionResult(id: 'r2', competitionId: competitionId, categoryId: 'cat2', submissionId: 's2', studentId: 'stu2', studentName: 'Tunde Adebayo', schoolName: 'Greensprings School', title: 'Danfo Dreams - Lagos Traffic', imageUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=800', rank: 2, finalScore: 91.2, avgScore: 91.2, totalJudges: 3, prize: {'title': '2nd Prize', 'details': '₦200k + Tablet'}, exhibitionSelected: true, scholarshipEligible: true, exhibitionStatus: ExhibitionStatus.selected),
      CompetitionResult(id: 'r3', competitionId: competitionId, categoryId: 'cat4', submissionId: 's3', studentId: 'stu3', studentName: 'Chioma Nwosu', schoolName: 'Donlee Abuja Hub', title: 'My Grandmothers Hands', imageUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800', rank: 3, finalScore: 89.8, avgScore: 89.8, totalJudges: 3, prize: {'title': '3rd Prize', 'details': '₦100k + Art Kit'}, exhibitionSelected: true, scholarshipEligible: false, exhibitionStatus: ExhibitionStatus.selected),
    ];
  }
}
