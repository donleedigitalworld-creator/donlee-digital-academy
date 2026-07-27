enum PolicyStatus { draft, underReview, approved, published, archived }
enum ApprovalType { newSchool, competition, certificate, sponsorship, scholarship }

class WelcomeMessage {
  final String id;
  final String title;
  final String message;
  final String authorName;
  final String authorTitle; // e.g., Hon. Minister of Education
  final String? authorPhotoUrl;
  final DateTime publishedAt;
  final bool isActive;
  final String? videoUrl;
  final List<String> tags;

  WelcomeMessage({
    required this.id,
    required this.title,
    required this.message,
    required this.authorName,
    required this.authorTitle,
    this.authorPhotoUrl,
    required this.publishedAt,
    this.isActive = true,
    this.videoUrl,
    this.tags = const [],
  });

  factory WelcomeMessage.ministryWelcome() {
    return WelcomeMessage(
      id: 'welcome_ministry_2025',
      title: 'Welcome to Donlee National Art Education Ecosystem',
      message: 'On behalf of the Federal Ministry of Education, I welcome all students, parents, teachers, and schools across Nigeria\'s 36 states and FCT to Donlee Digital World Creative Art Academy - our national platform for fine art education.\n\nThis platform represents our commitment to inclusive, equitable, and quality art education. With 1,247 schools onboarded, 45,892 students learning, and 41% adoption in rural areas via offline and low-bandwidth modes, we are bridging the digital divide.\n\nOur partnership with Donlee has enabled:\n• National Art Championship 2025 with theme "Nigeria at 65: Unity in Diversity"\n• Offline-first learning for limited connectivity areas - smart sync ensures no child is left behind\n• AI-powered tutor providing personalized guidance on proportion, shading, composition - teacher-reviewed for quality\n• Digital certificates verifiable via QR and blockchain-ready for future\n• Parent Portal with consent management and progress tracking\n• Exhibition at Nike Art Gallery and scholarship linkages for top talents\n\nWe encourage all schools to join, parents to engage via Parent Portal, and teachers to use professional development center. Together, we nurture creativity as promised in our tagline: Empowering Creativity Through Digital Fine Art Education.\n\nCreativity is national wealth. Let\'s build it together.',
      authorName: 'Prof. Tahir Mamman',
      authorTitle: 'Honorable Minister of Education, Federal Republic of Nigeria',
      authorPhotoUrl: null,
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      isActive: true,
      tags: ['Ministry', 'National', 'Welcome', 'Inclusive Education'],
    );
  }

  factory WelcomeMessage.donleeFounder() {
    return WelcomeMessage(
      id: 'welcome_donlee_founder',
      title: 'Message from Donlee Founder',
      message: 'Welcome to Donlee family! I started Donlee Digital World Creative Art Academy with a simple dream: every Nigerian child, whether in Lagos or in rural North-East with limited internet, should access world-class fine art education.\n\nPhase 1 was foundation - 10 modules from Intro to Color Theory. Phase 2 brought teachers together. Phase 3 made it national with competitions and offline support - because 68% of North-East students rely on offline queue. Phase 4 added AI tutor that explains Loomis head 3/4 angle and gives drawing feedback on proportion - jaw 10% too long, core shadow darker - but always teacher-reviewed.\n\nNow Phase 5-6 brings Ministry integration, parent engagement, professional development for teachers, and future expansion to music, dance, drama. This is not just an app - it is national ecosystem.\n\nYour artworks uploaded via camera are encrypted, verified, and could be exhibited at Nike Art Gallery. Your certificates are verifiable nationally via QR. Your offline submissions sync smartly without duplicate.\n\nLet\'s keep creating. Your creativity is valid.',
      authorName: 'Donlee Founder',
      authorTitle: 'Creative Director, Donlee Digital World',
      publishedAt: DateTime.now().subtract(const Duration(days: 10)),
      isActive: true,
    );
  }
}

class PolicyDocument {
  final String id;
  final String title;
  final String summary;
  final String? fileUrl;
  final PolicyStatus status;
  final DateTime publishedAt;
  final String publishedBy;
  final List<String> affectedRegions;

  PolicyDocument({
    required this.id,
    required this.title,
    required this.summary,
    this.fileUrl,
    required this.status,
    required this.publishedAt,
    required this.publishedBy,
    this.affectedRegions = const [],
  });
}

class ApprovalRequest {
  final String id;
  final ApprovalType type;
  final String requesterId;
  final String requesterName;
  final String schoolId;
  final String title;
  final String description;
  final PolicyStatus status;
  final DateTime requestedAt;
  final DateTime? reviewedAt;
  final String? reviewedBy;
  final String? feedback;

  ApprovalRequest({
    required this.id,
    required this.type,
    required this.requesterId,
    required this.requesterName,
    required this.schoolId,
    required this.title,
    required this.description,
    required this.status,
    required this.requestedAt,
    this.reviewedAt,
    this.reviewedBy,
    this.feedback,
  });
}

class MinistryStats {
  final int totalSchoolsPendingApproval;
  final int totalCompetitionsPendingApproval;
  final int totalPolicyDocuments;
  final int totalActiveSchools;
  final Map<String, int> regionPendingCounts;

  MinistryStats({
    required this.totalSchoolsPendingApproval,
    required this.totalCompetitionsPendingApproval,
    required this.totalPolicyDocuments,
    required this.totalActiveSchools,
    this.regionPendingCounts = const {},
  });

  factory MinistryStats.mock() {
    return MinistryStats(
      totalSchoolsPendingApproval: 23,
      totalCompetitionsPendingApproval: 5,
      totalPolicyDocuments: 12,
      totalActiveSchools: 1247,
      regionPendingCounts: {'SouthWest': 5, 'NorthEast': 8, 'NorthWest': 6, 'SouthSouth': 2},
    );
  }
}
