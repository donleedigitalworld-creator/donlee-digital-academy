import '../../models/partnership/partnership_model.dart';

class PartnershipService {
  Future<List<Sponsor>> getSponsors() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Sponsor.mockSponsors();
  }

  Future<List<SponsoredEvent>> getSponsoredEvents() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      SponsoredEvent(id: 'se1', sponsorId: 'spon1', sponsorName: 'MTN Foundation', eventTitle: 'National Art Championship 2025 - Title Sponsorship', description: 'Title sponsor for national competition, offline kits for rural areas', date: DateTime.now().add(const Duration(days: 20)), isNationalCompetition: true, expectedReach: 45892, branding: {'logoPlacement': 'Cover, Certificates, Exhibition'}),
      SponsoredEvent(id: 'se2', sponsorId: 'spon2', sponsorName: 'Nike Art Gallery', eventTitle: 'Annual Exhibition - Emerging Artists', description: 'Top 10 national competition exhibited, scholarship awards', date: DateTime.now().add(const Duration(days: 15)), isNationalCompetition: false, expectedReach: 5000, branding: {'venue': 'Nike Art Gallery'}),
    ];
  }

  Future<List<ImpactMetric>> getImpactMetrics(String sponsorId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [ImpactMetric(sponsorId: sponsorId, studentsReached: 45892, schoolsReached: 1247, artworksCreated: 12456, offlineKitsDistributed: 2340, scholarshipsAwarded: 50, brandVisibilityScore: 8.9)];
  }
}

class ScholarshipService {
  Future<List<dynamic>> getScholarships() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }
}

class MarketplaceService {
  Future<List<dynamic>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }
}

class ResearchService {
  Future<List<dynamic>> getStudies() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }
}

class MFAService {
  Future<List<dynamic>> getMethods() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }
}
