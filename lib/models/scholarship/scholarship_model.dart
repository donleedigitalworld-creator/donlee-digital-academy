enum ScholarshipType { full, partial, mentorship, exhibition, grant }
enum ApplicationStage { draft, submitted, underReview, shortlisted, interview, awarded, rejected, disbursed }

class ScholarshipProgram {
  final String id;
  final String title;
  final String organization;
  final ScholarshipType type;
  final String description;
  final double amount;
  final String currency;
  final DateTime deadline;
  final List<String> eligibilityCriteria;
  final List<String> requiredDocuments;
  final bool isForCompetitionWinners;
  final bool isForExhibitionSelected;
  final int availableSlots;
  final int appliedCount;

  ScholarshipProgram({
    required this.id,
    required this.title,
    required this.organization,
    required this.type,
    required this.description,
    required this.amount,
    this.currency = 'NGN',
    required this.deadline,
    this.eligibilityCriteria = const [],
    this.requiredDocuments = const [],
    this.isForCompetitionWinners = false,
    this.isForExhibitionSelected = false,
    required this.availableSlots,
    required this.appliedCount,
  });

  static List<ScholarshipProgram> mock() {
    final now = DateTime.now();
    return [
      ScholarshipProgram(
        id: 'sch1',
        title: 'Donlee National Championship Scholarship - 1 Year Full Academy',
        organization: 'Donlee Foundation + MTN Foundation',
        type: ScholarshipType.full,
        description: '1 year full scholarship at Donlee Academy, mentorship with Prof. Nike Davies, exhibition at Nike Art Gallery, portfolio review. For Top 3 national competition + exhibition selected.',
        amount: 500000,
        deadline: now.add(const Duration(days: 20)),
        eligibilityCriteria: ['Rank Top 3 national OR exhibition selected', 'Age 13-25', 'Portfolio 5 works', 'Parental consent'],
        requiredDocuments: ['Birth certificate', 'School ID', 'Portfolio PDF', 'Recommendation letter', 'Parent consent form'],
        isForCompetitionWinners: true,
        isForExhibitionSelected: true,
        availableSlots: 10,
        appliedCount: 34,
      ),
      ScholarshipProgram(
        id: 'sch2',
        title: 'Nike Art Gallery Residency Grant',
        organization: 'Nike Art Gallery',
        type: ScholarshipType.grant,
        description: '1 month residency at Nike Art Gallery, Lagos, materials provided, final exhibition.',
        amount: 200000,
        deadline: now.add(const Duration(days: 35)),
        eligibilityCriteria: ['Exhibition selected at National Championship', 'Age 16+'],
        requiredDocuments: ['Portfolio', 'Artist statement'],
        isForExhibitionSelected: true,
        availableSlots: 5,
        appliedCount: 12,
      ),
    ];
  }
}

class ScholarshipApplication {
  final String id;
  final String scholarshipId;
  final String studentId;
  final String studentName;
  final String schoolName;
  final ApplicationStage stage;
  final DateTime appliedAt;
  final List<String> documentUrls;
  final String? personalStatement;
  final double? gpa;
  final int? competitionRank;
  final bool isExhibitionSelected;
  final String? reviewerNotes;
  final double? awardedAmount;
  final DateTime? disbursedAt;

  ScholarshipApplication({
    required this.id,
    required this.scholarshipId,
    required this.studentId,
    required this.studentName,
    required this.schoolName,
    required this.stage,
    required this.appliedAt,
    this.documentUrls = const [],
    this.personalStatement,
    this.gpa,
    this.competitionRank,
    this.isExhibitionSelected = false,
    this.reviewerNotes,
    this.awardedAmount,
    this.disbursedAt,
  });
}
