enum OpportunityType { job, internship, scholarship, exhibition, mentorship, competition, grant }
enum CareerLevel { student, emerging, professional, master }
enum ApplicationStatus { open, closed, applied, shortlisted, awarded }

class CareerPath {
  final String id;
  final String title;
  final String description;
  final String icon;
  final List<String> requiredSkills;
  final List<String> recommendedModules;
  final double avgSalaryRangeLow;
  final double avgSalaryRangeHigh;
  final String currency;

  CareerPath({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.requiredSkills = const [],
    this.recommendedModules = const [],
    this.avgSalaryRangeLow = 0,
    this.avgSalaryRangeHigh = 0,
    this.currency = 'NGN',
  });

  static List<CareerPath> mockPaths() {
    return [
      CareerPath(id: 'c1', title: 'Portrait Artist', description: 'Commissioned portraits, galleries, exhibitions', icon: '👤', requiredSkills: ['Loomis Method', 'Anatomy', 'Color Theory'], recommendedModules: ['facial_drawing', 'human_anatomy', 'color_theory'], avgSalaryRangeLow: 100000, avgSalaryRangeHigh: 500000, currency: 'NGN'),
      CareerPath(id: 'c2', title: 'Digital Illustrator', description: 'Publishing, editorial, concept art, Pixar-style', icon: '💻', requiredSkills: ['Digital Art', 'Composition', 'Storytelling'], recommendedModules: ['elements_of_art', 'principles_design', 'landscape'], avgSalaryRangeLow: 150000, avgSalaryRangeHigh: 800000),
      CareerPath(id: 'c3', title: 'Art Teacher', description: 'Teach in schools, academies, Donlee network', icon: '👩‍🏫', requiredSkills: ['All modules mastery', 'Pedagogy', 'Communication'], recommendedModules: ['all'], avgSalaryRangeLow: 80000, avgSalaryRangeHigh: 300000),
      CareerPath(id: 'c4', title: 'Animator', description: '2D/3D animation, Motion graphics', icon: '🎬', requiredSkills: ['Gesture Drawing', 'Perspective', 'Timing'], recommendedModules: ['human_anatomy', 'perspective', 'principles_design'], avgSalaryRangeLow: 200000, avgSalaryRangeHigh: 1000000),
    ];
  }
}

class OpportunityModel {
  final String id;
  final String title;
  final String organization;
  final OpportunityType type;
  final String description;
  final String? coverImageUrl;
  final String location;
  final bool isRemote;
  final DateTime deadline;
  final List<String> requirements;
  final List<String> tags;
  final String? salaryRange;
  final ApplicationStatus status;
  final bool isScholarshipLinked;
  final bool isExhibitionLinked;
  final String? applicationUrl;
  final bool isForNationalCompetitionWinners;

  OpportunityModel({
    required this.id,
    required this.title,
    required this.organization,
    required this.type,
    required this.description,
    this.coverImageUrl,
    required this.location,
    this.isRemote = false,
    required this.deadline,
    this.requirements = const [],
    this.tags = const [],
    this.salaryRange,
    this.status = ApplicationStatus.open,
    this.isScholarshipLinked = false,
    this.isExhibitionLinked = false,
    this.applicationUrl,
    this.isForNationalCompetitionWinners = false,
  });

  factory OpportunityModel.mock(String id, OpportunityType type) {
    final now = DateTime.now();
    return OpportunityModel(
      id: id,
      title: {
        OpportunityType.scholarship: 'Donlee Full Scholarship - Art Academy 1 Year',
        OpportunityType.exhibition: 'Nike Art Gallery Annual Exhibition - Emerging Artists',
        OpportunityType.mentorship: 'Mentorship with Prof. Nike Davies - 3 Months',
        OpportunityType.job: 'Junior Illustrator - Publishing House Lagos',
        OpportunityType.internship: 'Internship - Donlee Content Team',
      }[type] ?? '${type.name} Opportunity',
      organization: {
        OpportunityType.scholarship: 'Donlee Foundation',
        OpportunityType.exhibition: 'Nike Art Gallery',
        OpportunityType.mentorship: 'Donlee Academy',
        OpportunityType.job: 'Cassava Republic Press',
      }[type] ?? 'Donlee Partners',
      type: type,
      description: 'This opportunity is linked to National Art Championship performance. Top 10 exhibition selected + scholarship eligible get fast-track. Future-ready: auto-flagged from competition results.',
      coverImageUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=800',
      location: 'Lagos, Nigeria',
      isRemote: type == OpportunityType.mentorship || type == OpportunityType.scholarship,
      deadline: now.add(Duration(days: 30 + id.hashCode % 60)),
      requirements: ['Age 13-25', 'Portfolio of 5 works', 'Donlee certificate'],
      tags: ['National Competition', 'Scholarship Eligible', 'Exhibition'],
      salaryRange: type == OpportunityType.scholarship ? '₦500k + Training' : null,
      status: ApplicationStatus.open,
      isScholarshipLinked: type == OpportunityType.scholarship,
      isExhibitionLinked: type == OpportunityType.exhibition,
      isForNationalCompetitionWinners: true,
    );
  }
}
