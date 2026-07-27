import '../../models/competition_model.dart';

enum Region { northCentral, northEast, northWest, southEast, southSouth, southWest }
enum SchoolType { public, private, federal, state, artAcademy }
enum EquityIndicator { gender, ruralUrban, income, disability, stateRepresentation }

class RegionalStat {
  final Region region;
  final int totalSchools;
  final int totalStudents;
  final int totalTeachers;
  final int competitionEntries;
  final double avgCompletionRate;
  final double offlineUsageRate;
  final Map<String, int> stateBreakdown;

  RegionalStat({
    required this.region,
    required this.totalSchools,
    required this.totalStudents,
    required this.totalTeachers,
    required this.competitionEntries,
    required this.avgCompletionRate,
    required this.offlineUsageRate,
    this.stateBreakdown = const {},
  });
}

class NationalStats {
  final int totalSchools;
  final int totalStudents;
  final int totalTeachers;
  final int totalParents;
  final int totalCompetitions;
  final int totalSubmissions;
  final int totalCertificates;
  final int totalResources;
  final double nationalCompletionRate;
  final double offlineAdoptionRate;
  final double aiAdoptionRate;
  final Map<Region, RegionalStat> regionalStats;
  final DateTime lastUpdated;

  NationalStats({
    required this.totalSchools,
    required this.totalStudents,
    required this.totalTeachers,
    required this.totalParents,
    required this.totalCompetitions,
    required this.totalSubmissions,
    required this.totalCertificates,
    required this.totalResources,
    required this.nationalCompletionRate,
    required this.offlineAdoptionRate,
    required this.aiAdoptionRate,
    required this.regionalStats,
    required this.lastUpdated,
  });

  factory NationalStats.mock() {
    return NationalStats(
      totalSchools: 1247,
      totalStudents: 45892,
      totalTeachers: 3421,
      totalParents: 28934,
      totalCompetitions: 56,
      totalSubmissions: 12456,
      totalCertificates: 8934,
      totalResources: 1245,
      nationalCompletionRate: 0.68,
      offlineAdoptionRate: 0.41,
      aiAdoptionRate: 0.73,
      regionalStats: {
        Region.southWest: RegionalStat(region: Region.southWest, totalSchools: 423, totalStudents: 18234, totalTeachers: 1234, competitionEntries: 4523, avgCompletionRate: 0.74, offlineUsageRate: 0.32, stateBreakdown: {'Lagos': 234, 'Oyo': 89, 'Ogun': 100}),
        Region.southEast: RegionalStat(region: Region.southEast, totalSchools: 234, totalStudents: 9234, totalTeachers: 678, competitionEntries: 2345, avgCompletionRate: 0.71, offlineUsageRate: 0.38),
        Region.northCentral: RegionalStat(region: Region.northCentral, totalSchools: 345, totalStudents: 12456, totalTeachers: 923, competitionEntries: 3456, avgCompletionRate: 0.62, offlineUsageRate: 0.52),
        Region.northWest: RegionalStat(region: Region.northWest, totalSchools: 123, totalStudents: 3456, totalTeachers: 234, competitionEntries: 823, avgCompletionRate: 0.58, offlineUsageRate: 0.61),
        Region.southSouth: RegionalStat(region: Region.southSouth, totalSchools: 89, totalStudents: 1789, totalTeachers: 189, competitionEntries: 567, avgCompletionRate: 0.69, offlineUsageRate: 0.44),
        Region.northEast: RegionalStat(region: Region.northEast, totalSchools: 33, totalStudents: 723, totalTeachers: 63, competitionEntries: 234, avgCompletionRate: 0.54, offlineUsageRate: 0.68),
      },
      lastUpdated: DateTime.now(),
    );
  }
}

class EquityMetric {
  final EquityIndicator indicator;
  final String label;
  final double currentValue;
  final double targetValue;
  final double nationalAverage;
  final String description;
  final List<Map<String, dynamic>> trendData;

  EquityMetric({
    required this.indicator,
    required this.label,
    required this.currentValue,
    required this.targetValue,
    required this.nationalAverage,
    required this.description,
    this.trendData = const [],
  });

  static List<EquityMetric> mockMetrics() {
    return [
      EquityMetric(indicator: EquityIndicator.gender, label: "Female Student Participation", currentValue: 0.48, targetValue: 0.5, nationalAverage: 0.45, description: "Female students in art competitions", trendData: [{'month': 'Jan', 'value': 0.42}, {'month': 'Jun', 'value': 0.48}]),
      EquityMetric(indicator: EquityIndicator.ruralUrban, label: "Rural Offline Adoption", currentValue: 0.68, targetValue: 0.75, nationalAverage: 0.41, description: "Rural students using offline + low-bandwidth", trendData: []),
      EquityMetric(indicator: EquityIndicator.stateRepresentation, label: "State Coverage", currentValue: 0.92, targetValue: 1.0, nationalAverage: 0.85, description: "36 states + FCT with at least 1 active school", trendData: []),
      EquityMetric(indicator: EquityIndicator.disability, label: "Accessibility Usage", currentValue: 0.12, targetValue: 0.20, nationalAverage: 0.08, description: "Students using accessibility features (screen reader, high contrast, dyslexia font)", trendData: []),
    ];
  }
}

class SchoolDetailedProfile {
  final String id;
  final String name;
  final SchoolType type;
  final Region region;
  final String state;
  final String lga;
  final int totalStudents;
  final int totalTeachers;
  final int totalParents;
  final int totalClasses;
  final double completionRate;
  final double competitionParticipation;
  final double offlineUsage;
  final double aiUsage;
  final int certificatesIssued;
  final bool isVerified;
  final DateTime joinedAt;
  final Map<String, dynamic> infrastructure; // power, internet, devices

  SchoolDetailedProfile({
    required this.id,
    required this.name,
    required this.type,
    required this.region,
    required this.state,
    required this.lga,
    required this.totalStudents,
    required this.totalTeachers,
    required this.totalParents,
    required this.totalClasses,
    required this.completionRate,
    required this.competitionParticipation,
    required this.offlineUsage,
    required this.aiUsage,
    required this.certificatesIssued,
    this.isVerified = false,
    required this.joinedAt,
    this.infrastructure = const {},
  });
}
