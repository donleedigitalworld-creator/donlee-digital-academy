import '../../models/cms/cms_model.dart';

class CMSService {
  Future<List<LessonDraft>> getDrafts({LessonStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final all = LessonDraft.mockDrafts();
    if (status != null) return all.where((d) => d.status == status).toList();
    return all;
  }

  Future<LessonDraft> createDraft(LessonDraft draft) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return draft;
  }

  Future<LessonDraft> updateDraft(LessonDraft draft) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return draft;
  }

  Future<void> submitForReview(String draftId) async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> approveDraft(String draftId, String reviewerId) async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> publishDraft(String draftId) async {
    await Future.delayed(const Duration(milliseconds: 800));
  }
}
