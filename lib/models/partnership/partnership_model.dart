enum SponsorshipTier { bronze, silver, gold, platinum, title }
enum PartnershipStatus { prospect, active, renewing, expired }

class Sponsor {
  final String id;
  final String name;
  final String logoUrl;
  final String description;
  final String contactEmail;
  final String? website;
  final SponsorshipTier tier;
  final PartnershipStatus status;
  final DateTime partnershipStart;
  final DateTime partnershipEnd;
  final double totalContribution;
  final String currency;

  Sponsor({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.description,
    required this.contactEmail,
    this.website,
    required this.tier,
    required this.status,
    required this.partnershipStart,
    required this.partnershipEnd,
    required this.totalContribution,
    this.currency = 'NGN',
  });

  static List<Sponsor> mockSponsors() {
    return [
      Sponsor(id: 'spon1', name: 'MTN Foundation', logoUrl: '', description: 'Supporting national art education, offline connectivity in rural areas', contactEmail: 'csr@mtn.com', tier: SponsorshipTier.title, status: PartnershipStatus.active, partnershipStart: DateTime.now().subtract(const Duration(days: 100)), partnershipEnd: DateTime.now().add(const Duration(days: 265)), totalContribution: 5000000, currency: 'NGN'),
      Sponsor(id: 'spon2', name: 'Nike Art Gallery', logoUrl: '', description: 'Exhibition venue for Top 10 national competition, scholarship linkage', contactEmail: 'curator@nikeartgallery.com', tier: SponsorshipTier.gold, status: PartnershipStatus.active, partnershipStart: DateTime.now().subtract(const Duration(days: 80)), partnershipEnd: DateTime.now().add(const Duration(days: 200)), totalContribution: 2000000),
      Sponsor(id: 'spon3', name: 'Lagos State Ministry of Education', logoUrl: '', description: 'Policy support, school onboarding, teacher training', contactEmail: 'education@lagosstate.gov.ng', tier: SponsorshipTier.platinum, status: PartnershipStatus.active, partnershipStart: DateTime.now().subtract(const Duration(days: 200)), partnershipEnd: DateTime.now().add(const Duration(days: 500)), totalContribution: 10000000),
    ];
  }
}

class SponsoredEvent {
  final String id;
  final String sponsorId;
  final String sponsorName;
  final String eventTitle;
  final String description;
  final DateTime date;
  final bool isNationalCompetition;
  final int expectedReach;
  final Map<String, dynamic> branding;

  SponsoredEvent({
    required this.id,
    required this.sponsorId,
    required this.sponsorName,
    required this.eventTitle,
    required this.description,
    required this.date,
    this.isNationalCompetition = false,
    required this.expectedReach,
    this.branding = const {},
  });
}

class ImpactMetric {
  final String sponsorId;
  final int studentsReached;
  final int schoolsReached;
  final int artworksCreated;
  final int offlineKitsDistributed;
  final int scholarshipsAwarded;
  final double brandVisibilityScore;

  ImpactMetric({
    required this.sponsorId,
    required this.studentsReached,
    required this.schoolsReached,
    required this.artworksCreated,
    required this.offlineKitsDistributed,
    required this.scholarshipsAwarded,
    required this.brandVisibilityScore,
  });
}
