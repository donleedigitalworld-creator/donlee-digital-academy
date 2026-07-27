import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/custom_app_bar.dart';
import '../data/lessons_data.dart';
import '../../../models/lesson_model.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_service.dart';

class ModulesListScreen extends StatelessWidget {
  const ModulesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = LessonsData.modules;
    final auth = Provider.of<AuthService>(context);
    final progressMap = auth.currentUserModel?.moduleProgress ?? {};

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Learning Path", subtitle: "10 Modules • Foundation to Advanced"),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: modules.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final mod = modules[index];
          final progress = progressMap[mod.id] ?? 0;
          final lessons = LessonsData.allLessons.where((l) => l.moduleId == mod.id).toList();
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ModuleDetailScreen(module: mod))),
            child: Container(
              decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(20), border: Border.all(color: progress > 0 ? AppColors.primaryGold.withOpacity(0.3) : Colors.transparent)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(children: [
                    ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: CachedNetworkImage(imageUrl: mod.thumbnailUrl, height: 140, width: double.infinity, fit: BoxFit.cover, placeholder: (c, u) => Container(height: 140, color: AppColors.primaryBlackLighter), errorWidget: (c, u, e) => Container(height: 140, color: AppColors.primaryBlackLighter, child: const Icon(Icons.image)))),
                    Container(height: 140, decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.8)]))),
                    Positioned(top: 12, left: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: AppColors.primaryBlack.withOpacity(0.7), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.primaryGold.withOpacity(0.3))), child: Text("MODULE ${mod.order}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryGold, fontWeight: FontWeight.bold, letterSpacing: 1)))),
                    Positioned(top: 12, right: 12, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.primaryBlack.withOpacity(0.7), shape: BoxShape.circle), child: Center(child: Text(mod.icon, style: const TextStyle(fontSize: 20))))),
                    Positioned(bottom: 12, left: 12, right: 12, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(mod.title, style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryGold, borderRadius: BorderRadius.circular(10)), child: Text("${lessons.length} LESSONS", style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primaryBlack))),
                    ])),
                  ]),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(mod.description, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.mediumGrey), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: progress, backgroundColor: AppColors.primaryBlackLighter, color: AppColors.primaryGold, minHeight: 6))),
                        const SizedBox(width: 12),
                        Text("${(progress * 100).toInt()}%", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryGold)),
                      ]),
                      const SizedBox(height: 8),
                      Row(children: mod.learningOutcomes.take(2).map((o) => Expanded(child: Row(children: [const Icon(Icons.check, size: 10, color: AppColors.success), const SizedBox(width: 4), Expanded(child: Text(o, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey), maxLines: 1, overflow: TextOverflow.ellipsis))]))).toList()),
                    ]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ModuleDetailScreen extends StatelessWidget {
  final ModuleModel module;
  const ModuleDetailScreen({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final lessons = LessonsData.allLessons.where((l) => l.moduleId == module.id).toList();
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: CustomAppBar(title: module.title, subtitle: module.description, showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("What You'll Learn", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
              const SizedBox(height: 12),
              ...module.learningOutcomes.map((outcome) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(margin: const EdgeInsets.only(top: 4), width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.primaryGold, shape: BoxShape.circle)), const SizedBox(width: 10), Expanded(child: Text(outcome, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.offWhite)))]))),
            ]),
          ),
          const SizedBox(height: 24),
          Text("Lessons (${lessons.length})", style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          const SizedBox(height: 12),
          ...lessons.asMap().entries.map((entry) {
            final idx = entry.key;
            final lesson = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Stack(alignment: Alignment.center, children: [
                  Container(width: 50, height: 50, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), image: DecorationImage(image: NetworkImage(lesson.thumbnailUrl), fit: BoxFit.cover))),
                  Container(width: 50, height: 50, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.black.withOpacity(0.4))),
                  Text("${idx + 1}", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                ]),
                title: Text(lesson.title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryWhite)),
                subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 4),
                  Text(lesson.description, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey), maxLines: 2),
                  const SizedBox(height: 6),
                  Row(children: [
                    Icon(Icons.access_time, size: 10, color: AppColors.primaryGold.withOpacity(0.7)),
                    const SizedBox(width: 4),
                    Text("${lesson.estimatedMinutes}m", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
                    const SizedBox(width: 10),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: [AppColors.success, AppColors.primaryGold, AppColors.error][lesson.difficulty - 1].withOpacity(0.15), borderRadius: BorderRadius.circular(4)), child: Text(["Easy", "Medium", "Hard"][lesson.difficulty - 1], style: GoogleFonts.poppins(fontSize: 9, color: [AppColors.success, AppColors.primaryGold, AppColors.error][lesson.difficulty - 1]))),
                  ]),
                ]),
                trailing: const Icon(Icons.play_arrow_rounded, color: AppColors.primaryGold),
                onTap: () => Navigator.pushNamed(context, '/lessonDetail', arguments: lesson),
              ),
            );
          }),
        ],
      ),
    );
  }
}
