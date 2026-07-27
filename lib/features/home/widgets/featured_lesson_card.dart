import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/lesson_model.dart';

class FeaturedLessonCard extends StatelessWidget {
  final LessonModel lesson;
  final VoidCallback onTap;
  const FeaturedLessonCard({super.key, required this.lesson, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))]),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: lesson.thumbnailUrl,
                width: double.infinity, height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (c, u) => Container(color: AppColors.primaryBlackLighter),
                errorWidget: (c, u, e) => Container(color: AppColors.primaryBlackLighter, child: const Icon(Icons.image, color: AppColors.mediumGrey)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.9)]),
              ),
            ),
            Positioned(
              top: 16, left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.star, size: 14, color: AppColors.primaryBlack),
                  const SizedBox(width: 4),
                  Text("FEATURED", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryBlack, letterSpacing: 1)),
                ]),
              ),
            ),
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.primaryBlack.withOpacity(0.6), borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.primaryGold.withOpacity(0.3))),
                      child: Text(lesson.moduleTitle.toUpperCase(), style: GoogleFonts.poppins(fontSize: 9, color: AppColors.primaryGold, letterSpacing: 1)),
                    ),
                    const SizedBox(height: 8),
                    Text(lesson.title, style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryWhite), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.access_time, size: 12, color: AppColors.mediumGrey),
                      const SizedBox(width: 4),
                      Text("${lesson.estimatedMinutes} mins", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)),
                      const SizedBox(width: 12),
                      const Icon(Icons.signal_cellular_alt, size: 12, color: AppColors.mediumGrey),
                      const SizedBox(width: 4),
                      Text(["Beginner", "Intermediate", "Advanced"][lesson.difficulty - 1], style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
