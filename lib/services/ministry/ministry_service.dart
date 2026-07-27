import '../../models/ministry/ministry_model.dart';

class MinistryService {
  Future<List<WelcomeMessage>> getWelcomeMessages() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [WelcomeMessage.ministryWelcome(), WelcomeMessage.donleeFounder()];
  }

  Future<MinistryStats> getMinistryStats() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MinistryStats.mock();
  }

  Future<List<PolicyDocument>> getPolicyDocuments() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      PolicyDocument(id: 'pol1', title: 'National Art Education Policy 2025', summary: 'Inclusive art education for 36 states + FCT, offline-first, AI tutor teacher-guided, parent portal consent', status: PolicyStatus.published, publishedAt: DateTime.now().subtract(const Duration(days: 30)), publishedBy: 'Federal Ministry of Education', affectedRegions: ['All']),
      PolicyDocument(id: 'pol2', title: 'Offline Learning & Low-Bandwidth Guidelines', summary: 'Guidelines for 68% North-East offline adoption, smart sync no duplicate, low-BW compression 40% quality', status: PolicyStatus.published, publishedAt: DateTime.now().subtract(const Duration(days: 15)), publishedBy: 'Federal Ministry of Education', affectedRegions: ['NorthEast', 'NorthWest', 'NorthCentral']),
      PolicyDocument(id: 'pol3', title: 'AI in Education - Privacy & Teacher Review Policy', summary: 'AI tutor, drawing feedback proportion/shading/composition, quiz generator, lesson plan generator - teacher reviewed before student sees, encryption AES-256, consent required, no training without Data Collection consent', status: PolicyStatus.published, publishedAt: DateTime.now().subtract(const Duration(days: 7)), publishedBy: 'Federal Ministry of Education + Donlee AI Ethics Board', affectedRegions: ['All']),
    ];
  }

  Future<List<ApprovalRequest>> getPendingApprovals() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(5, (i) => ApprovalRequest(
      id: 'appr_$i',
      type: ApprovalType.values[i % ApprovalType.values.length],
      requesterId: 'user_$i',
      requesterName: ['Donlee Main - Lagos New Branch', 'Greensprings Competition Approval', 'Nike Art Gallery Sponsorship', 'MTN Foundation Scholarship'][i % 4],
      schoolId: 's${i + 1}',
      title: ['New School Branch - Kano', 'National Competition - Still Life', 'Sponsorship - 5M NGN', 'Scholarship - 10 slots'][i % 4],
      description: 'Request pending ministry approval - 36 states coverage goal 100%, currently 92%',
      status: PolicyStatus.underReview,
      requestedAt: DateTime.now().subtract(Duration(days: i * 2)),
    ));
  }
}
