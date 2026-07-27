import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/lesson_model.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_service.dart';

class LessonDetailScreen extends StatefulWidget {
  final LessonModel lesson;
  const LessonDetailScreen({super.key, required this.lesson});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  int _currentStep = 0;
  bool _completed = false;

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primaryBlack,
            leading: IconButton(icon: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle), child: const Icon(Icons.arrow_back_ios, size: 16, color: AppColors.primaryWhite)), onPressed: () => Navigator.pop(context)),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(imageUrl: lesson.thumbnailUrl, fit: BoxFit.cover, placeholder: (c, u) => Container(color: AppColors.primaryBlackLighter), errorWidget: (c, u, e) => Container(color: AppColors.primaryBlackLighter)),
                  Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.8), AppColors.primaryBlack]))),
                  Positioned(bottom: 20, left: 20, right: 20, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: AppColors.primaryGold, borderRadius: BorderRadius.circular(20)), child: Text(lesson.moduleTitle.toUpperCase(), style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryBlack))),
                    const SizedBox(height: 10),
                    Text(lesson.title, style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                    const SizedBox(height: 6),
                    Row(children: [
                      Icon(Icons.schedule, size: 14, color: AppColors.primaryGold.withOpacity(0.8)),
                      const SizedBox(width: 4),
                      Text("${lesson.estimatedMinutes} min lesson", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.offWhite)),
                      const SizedBox(width: 16),
                      Icon(Icons.layers, size: 14, color: AppColors.primaryGold.withOpacity(0.8)),
                      const SizedBox(width: 4),
                      Text(lesson.steps.length.toString() + " steps", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.offWhite)),
                    ]),
                  ])),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("About this Lesson", style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                  const SizedBox(height: 10),
                  Text(lesson.longDescription, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.mediumGrey, height: 1.6)),
                  const SizedBox(height: 24),
                  Row(children: [
                    Text("Progress", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.mediumGrey)),
                    const Spacer(),
                    Text("${_currentStep + 1} / ${lesson.steps.length}", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primaryGold, fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 8),
                  ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: ( _currentStep + 1) / lesson.steps.length, backgroundColor: AppColors.primaryBlackLighter, color: AppColors.primaryGold, minHeight: 6)),
                  const SizedBox(height: 24),
                  ...lesson.steps.asMap().entries.map((entry) {
                    final i = entry.key;
                    final step = entry.value;
                    final isActive = i == _currentStep;
                    final isDone = i < _currentStep;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(color: isActive ? AppColors.primaryBlackLight : AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: isActive ? AppColors.primaryGold : Colors.transparent, width: isActive ? 1.2 : 0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Container(width: 36, height: 36, decoration: BoxDecoration(color: isDone ? AppColors.success : isActive ? AppColors.primaryGold : AppColors.primaryBlackLighter, shape: BoxShape.circle), child: Center(child: isDone ? const Icon(Icons.check, size: 18, color: Colors.white) : Text("${step.order}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: isActive ? AppColors.primaryBlack : AppColors.mediumGrey)))),
                            title: Text(step.title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: isActive ? AppColors.primaryWhite : AppColors.mediumGrey)),
                            trailing: isActive ? null : Icon(isDone ? Icons.check_circle : Icons.circle_outlined, color: isDone ? AppColors.success : AppColors.darkGrey, size: 20),
                            onTap: () => setState(() => _currentStep = i),
                          ),
                          if (isActive) Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            if (step.imageUrl != null) ...[ClipRRect(borderRadius: BorderRadius.circular(12), child: CachedNetworkImage(imageUrl: step.imageUrl!, height: 180, width: double.infinity, fit: BoxFit.cover)), const SizedBox(height: 12)],
                            Text(step.description, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.offWhite, height: 1.6)),
                            if (step.tip != null) ...[
                              const SizedBox(height: 12),
                              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.lightbulb, size: 16, color: AppColors.primaryGold), const SizedBox(width: 8), Expanded(child: Text(step.tip!, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.goldLight, fontStyle: FontStyle.italic)))])),
                            ],
                            const SizedBox(height: 16),
                            Row(children: [
                              if (_currentStep > 0) Expanded(child: OutlinedButton(onPressed: () => setState(() => _currentStep--), child: const Text("Previous"))),
                              if (_currentStep > 0) const SizedBox(width: 12),
                              Expanded(child: ElevatedButton(onPressed: () {
                                if (_currentStep < lesson.steps.length - 1) {
                                  setState(() => _currentStep++);
                                } else {
                                  setState(() => _completed = true);
                                }
                              }, child: Text(_currentStep == lesson.steps.length - 1 ? "Complete Lesson" : "Next Step"))),
                            ]),
                          ])),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  if (_completed) Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(16)),
                    child: Column(children: [
                      const Icon(Icons.celebration, size: 40, color: AppColors.primaryBlack),
                      const SizedBox(height: 12),
                      Text("Lesson Completed! 🎉", style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryBlack)),
                      const SizedBox(height: 6),
                      Text("Great work! You've finished this lesson. Take the quiz to solidify your knowledge and practice in your portfolio.", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primaryBlack.withOpacity(0.8)), textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      Row(children: [
                        Expanded(child: OutlinedButton(style: OutlinedButton.styleFrom(backgroundColor: AppColors.primaryBlack, side: BorderSide.none), onPressed: () {
                          Provider.of<AuthService>(context, listen: false).markLessonCompleted(lesson.id, lesson.moduleId);
                          Navigator.pushNamed(context, '/quiz', arguments: lesson);
                        }, child: Text("TAKE QUIZ", style: GoogleFonts.poppins(color: AppColors.primaryGold, fontWeight: FontWeight.bold)))),
                        const SizedBox(width: 12),
                        Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlack), onPressed: () {
                          Provider.of<AuthService>(context, listen: false).markLessonCompleted(lesson.id, lesson.moduleId);
                          Navigator.pushNamed(context, '/practice');
                        }, child: Text("PRACTICE NOW", style: GoogleFonts.poppins(color: AppColors.primaryWhite)))),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
