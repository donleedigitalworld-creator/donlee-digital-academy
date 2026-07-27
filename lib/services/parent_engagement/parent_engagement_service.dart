import '../../models/parent_engagement/parent_engagement_model.dart';

class ParentEngagementService {
  Future<List<FamilyArtChallenge>> getFamilyChallenges() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return FamilyArtChallenge.mock();
  }

  Future<List<MeetingSchedule>> getMeetings(String parentId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MeetingSchedule.mock();
  }

  Future<List<ParentLearningResource>> getParentResources() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return ParentLearningResource.mock();
  }

  Future<ParentEngagementMetric> getEngagementMetric(String parentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ParentEngagementMetric(
      parentId: parentId,
      meetingAttendanceRate: 0.85,
      familyChallengesCompleted: 3,
      volunteerHours: 12,
      learningResourcesViewed: 8,
      communicationResponseRate: 0.92,
    );
  }
}
