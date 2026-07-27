import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/lesson_model.dart';

class ProgressTracker extends StatelessWidget {
  final Map<String, double> moduleProgress;
  final List<ModuleModel> modules;
  const ProgressTracker({super.key, required this.moduleProgress, required this.modules});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Your Progress", style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/modules'), child: Text("View All", style: GoogleFonts.poppins(color: AppColors.primaryGold, fontSize: 12))),
        ]),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: modules.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final mod = modules[index];
              final progress = moduleProgress[mod.id] ?? 0;
              return Container(
                width: 140,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: progress > 0 ? AppColors.primaryGold.withOpacity(0.4) : AppColors.primaryBlackLighter)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(mod.icon, style: const TextStyle(fontSize: 22)),
                      Text("${(progress * 100).toInt()}%", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: progress > 0 ? AppColors.primaryGold : AppColors.mediumGrey)),
                    ]),
                    const SizedBox(height: 8),
                    Text(mod.title, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryWhite), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: progress, backgroundColor: AppColors.primaryBlackLighter, color: AppColors.primaryGold, minHeight: 4)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class QuickStatsWidget extends StatelessWidget {
  final int lessonsCompleted;
  final int artworks;
  const QuickStatsWidget({super.key, required this.lessonsCompleted, required this.artworks});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: _statCard(Icons.check_circle, "$lessonsCompleted", "Lessons")),
      const SizedBox(width: 12),
      Expanded(child: _statCard(Icons.palette_outlined, "$artworks", "Artworks")),
      const SizedBox(width: 12),
      Expanded(child: _statCard(Icons.local_fire_department, "5", "Day Streak")),
    ]);
  }

  Widget _statCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.primaryBlackLighter)),
      child: Column(children: [
        Icon(icon, color: AppColors.primaryGold, size: 22),
        const SizedBox(height: 6),
        Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        Text(label, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
      ]),
    );
  }
}
